from gtts import gTTS
import time
import pickle 
import os
import cv2
import face_recognition #for this you will have to download dlib-19.22.99-cp39-cp39-win_amd64.whl for python9... 
import pickle #install it using pip install 'filepath/dlib-19.22.99-cp39-cp39-win_amd64.whl for python9' and then install face_recognition
import cvzone #pip install cvzone
import numpy as np
import google.generativeai as genai
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
import urllib.request

def image_inspection_summary(image_path):
    GOOGLE_API_KEY = #'api-key'
    genai.configure(api_key=GOOGLE_API_KEY)
    thumb = genai.upload_file(path=image_path)
    print(f"Uploaded file '{thumb.display_name}' as: {thumb.uri}")

    # Choose a Gemini API model.
    model = genai.GenerativeModel(model_name="gemini-1.5-pro-latest")
     
    # create prompts- one for text gen
    text_prompt ="""
        "Tire":
        The system has detected potential issues with the tire pressure or condition in the attached image. Please analyze the tire and provide maintenance recommendations.
        If the tire pressure is low, suggest possible causes such as leaks, faulty valve stems, or temperature changes, and recommend corrective actions.
        If the tire condition appears poor (e.g., worn tread, sidewall damage), recommend whether the tire needs replacement or repair, and specify the part needed.
        ,
        "Battery":
        The system has detected a potential issue with the battery voltage, water level, or physical condition in the attached image. Please analyze and suggest maintenance actions.
        If the voltage is low, determine whether the battery or charging system needs inspection or replacement. Provide the specific part needed.
        If physical damage, rust, or leaks are observed, recommend necessary repairs or replacement.
        ,
        "Exterior":
        The system has detected rust, dents, or potential oil leaks in the attached image. Please analyze the exterior and provide maintenance recommendations.
        If rust is detected, suggest treatment options or recommend replacement of the affected part. Include safety precautions.
        If an oil leak is identified, determine whether it is due to a seal or gasket failure, and suggest necessary repairs or parts replacement.
        ,
        "Brakes":
        The system has detected potential issues with the brake fluid level or condition in the attached image. Please analyze the brake system and suggest maintenance actions.
        If the brake fluid level is low, suggest checking for leaks or contamination and recommend corrective actions.
        If brake pads or rotors are worn, provide replacement recommendations and specify the parts needed.
        ,
        "Engine":
        The system has detected potential rust, dents, or oil leaks in the engine area in the attached image. Please analyze the engine condition and suggest maintenance actions.
        If the engine oil appears contaminated or old, recommend whether an oil change is necessary and specify the correct oil type.
        If leaks are detected, identify the source and suggest replacing the affected seals or gaskets.
        ,
        "Overheating":
        The system has detected potential overheating or cable/wire damage in the attached image. Please analyze the image and suggest maintenance actions.
        If overheating is detected, suggest possible causes such as misalignment, friction, or electrical issues, and recommend corrective actions.
        If cable or wire damage is observed, recommend repairs or replacements and specify the parts needed.
        Looking at the image that is uploaded to you, see if there is any above issues or damages. Suggest related maintanence action and parts replacement
        """
    text_response = model.generate_content([thumb,text_prompt])
    
    return text_response.text

def object_detection(image,image_name):
    image_path  = rf"C:\Users\TRIDNT\Documents\Codes_and_Stuff\Butterfliy\Registered_faces_Object_detection\{image_name}.jpg"
    cv2.imwrite(image_path,image)
    print(f"Image saved at {image_path}")
    GOOGLE_API_KEY = 'AIzaSyBHhq8EjXKqTXXrNXoCZ0m4Mpi1iXbAkTs'
    genai.configure(api_key=GOOGLE_API_KEY)
    thumb = genai.upload_file(path=image_path)
    print(f"Uploaded file '{thumb.display_name}' as: {thumb.uri}")

    # Choose a Gemini API model.
    model = genai.GenerativeModel(model_name="gemini-1.5-pro-latest")
     
    # create prompts- one for text gen
    text_prompt_1 = f"""Tell me what this image is. Only give me the name as output, nothing else."""

    # Prompt the model with text and the previously uploaded image.
    text_response = model.generate_content([thumb, text_prompt_1])
    
    return text_response.text

def text_to_speech(mytext):

    language = 'en'
    myobj = gTTS(text=mytext, lang=language, slow=False,tld='co.in')

    myobj.save(r"C:\Users\TRIDNT\Documents\Codes_and_Stuff\Audio_messges\welcome.mp3")

    print("file saved!!")

    # Playing the converted file
    os.system("start C:\\Users\\TRIDNT\\Documents\\Codes_and_Stuff\\Audio_messges\\welcome.mp3")

def video_reader():
    video = cv2.VideoCapture(0)
    draw_box = False  # Flag to control drawing the bounding box
    bounding_box = (100, 100, 200, 200)  # Default bounding box
    detection_text = None  # Variable to store detection text

    while True:
        ret, frame = video.read()
        if not ret:
            break
        frame = cv2.flip(frame, 1)
        current_frame = frame.copy()

        if draw_box and detection_text:
            # Draw the bounding box
            x, y, w, h = bounding_box
            cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
            # Put text around the bounding box
            cv2.putText(frame, detection_text, (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 0), 2)
        
        cv2.imshow("Object_Detection", frame)

        key = cv2.waitKey(1) & 0xFF
        if key == ord('s'):
            detection_text = object_detection(current_frame, 'sample_name')
            draw_box = True
        elif key == ord('q'):
            break
        elif key == ord('c'):
            draw_box = False

    video.release()
    cv2.destroyAllWindows()

def capture_and_save_image(inspector_name, inspection_employee_id, save_folder, encoded_file_path):
    """
    Captures an image from the webcam, saves it, and encodes the face.
    The encoded face, along with the inspector's details, is stored in a binary file.

    Parameters:
    - inspector_name: The name of the inspector.
    - inspection_employee_id: The employee ID of the inspector.
    - save_folder: Folder to save the captured images.
    - encoded_file_path: Path to the file where encodings and information are stored.
    """
    if not os.path.exists(save_folder):
        os.makedirs(save_folder)
        print(f"Created folder: {save_folder}")

    cam = cv2.VideoCapture(0)
    cam.set(3, 700)
    cam.set(4, 450)

    while True:
        ret, frame = cam.read()
        if not ret:
            print("Failed to capture image.")
            break

        frame = cv2.flip(frame, 1)
        cv2.imshow("Capture Image", frame)

        if cv2.waitKey(1) & 0xFF == ord('s'):
            # Save the image
            image_path = os.path.join(save_folder, f"{inspector_name}.jpg")
            cv2.imwrite(image_path, frame)
            print(f"Image saved at {image_path}")
            
            # Load the image, encode the face, and save it in the binary file
            load_into_database(image_path, encoded_file_path, inspector_name, inspection_employee_id)
            break

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cam.release()
    cv2.destroyAllWindows()

def load_into_database(image_path, encoded_file_path, inspector_name, inspection_employee_id):
    """
    Loads an image, encodes the face, and saves the encoding along with inspector details to a binary file.

    Parameters:
    - image_path: Path to the image to be encoded.
    - encoded_file_path: Path to the file where encodings and information are stored.
    - inspector_name: The name of the inspector.
    - inspection_employee_id: The ID of the inspector.
    """
    # Read the image
    image = cv2.imread(image_path)
    rgb_image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

    # Encode the face in the image
    try:
        encoded_face = face_recognition.face_encodings(rgb_image)[0]
        print(f"Encoding for {inspector_name} is complete.")
    except IndexError:
        print(f"No face found in {inspector_name}'s image. Encoding failed.")
        return

    # Load existing data or initialize new data
    if os.path.exists(encoded_file_path):
        with open(encoded_file_path, 'rb') as file:
            Encode_with_name = pickle.load(file)
    else:
        Encode_with_name = [[], [], {}]

    # Append the new data
    Encode_with_name[0].append(encoded_face)
    Encode_with_name[1].append(inspector_name)
    Encode_with_name[2][inspector_name] = {"inspection_employee_id": inspection_employee_id}

    # Save the updated data back to the file
    with open(encoded_file_path, 'wb') as file:
        pickle.dump(Encode_with_name, file)

    print(f"Data for {inspector_name} saved successfully.")

def recognize_and_display(encoded_file_path):
    """
    Recognizes faces in the video feed and displays the corresponding inspector's name and ID.

    Parameters:
    - encoded_file_path: Path to the file where encodings and information are stored.
    """
    # Load the encoded data
    with open(encoded_file_path, 'rb') as file:
        Known_Encoded_List_withnames = pickle.load(file)
    Known_Encodings, Inspector_Names, Inspector_Info = Known_Encoded_List_withnames

    print("Loaded inspector names:", Inspector_Names)

    cam = cv2.VideoCapture(0)
    while True:
        ret, frame = cam.read()
        if not ret:
            print("Failed to grab frame.")
            break

        frame = cv2.flip(frame, 1)
        imgS = cv2.resize(frame, (0, 0), None, fx=0.2, fy=0.2)  # Scaling down
        img_rgb = cv2.cvtColor(imgS, cv2.COLOR_BGR2RGB)

        # Recognize faces in the current frame
        cur_face_landmarks = face_recognition.face_locations(img_rgb)
        cur_face_encodings = face_recognition.face_encodings(img_rgb, cur_face_landmarks)

        for encodeFace, FaceLoc in zip(cur_face_encodings, cur_face_landmarks):
            matches = face_recognition.compare_faces(Known_Encodings, encodeFace)
            distance = np.linalg.norm(Known_Encodings - encodeFace, axis=1)
            matching_index = np.argmin(distance)

            if matches[matching_index]:
                name = Inspector_Names[matching_index]
                inspector_info = Inspector_Info[name]
                print(f"Inspector {name} found with ID: {inspector_info['inspection_employee_id']}")
                y1, x2, y2, x1 = FaceLoc
                y1, x2, y2, x1 = y1 * 5, x2 * 5, y2 * 5, x1 * 5  # Resizing to original
                bbox = x1, y1, x2 - x1, y2 - y1
                frame = cvzone.cornerRect(frame, bbox, rt=0)
                cv2.putText(frame, f'{name} ID: {inspector_info["inspection_employee_id"]}', (x1, y1 - 10),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 0), 2)
            else:
                y1, x2, y2, x1 = FaceLoc
                y1, x2, y2, x1 = y1 * 5, x2 * 5, y2 * 5, x1 * 5  # Resizing to original
                bbox = x1, y1, x2 - x1, y2 - y1
                frame = cvzone.cornerRect(frame, bbox, rt=0)
                cv2.putText(frame, 'Unregistered Person', (x1, y1 - 10), cv2.FONT_ITALIC, 0.9, (255, 0, 0), 2)

        # Display the frame
        cv2.imshow('face detection', frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cam.release()
    cv2.destroyAllWindows()

def main():
    start = input("New id?y/n")
    face_recog = input("Fill personal Details?y/n")
    registered_faces_folder = r'C:\Users\TRIDNT\Documents\Codes_and_Stuff\Butterfliy\\Registered_faces'
    encoded_file_path = r'C:\Users\TRIDNT\Documents\Codes_and_Stuff\Butterfliy\\Encodedfile.p'
    if(start=="y"):
        inspector_name = input("Enter Inspector Name: ")
        inspection_employee_id = input("Enter Inspector Employee ID: ")
        
        # Capture and save image, and load into database
        capture_and_save_image(inspector_name, inspection_employee_id, registered_faces_folder, encoded_file_path)
        recognize_and_display(encoded_file_path)
    if(face_recog=='y'):
        recognize_and_display(encoded_file_path)

    detect = input("Object Detection?y/n")
    if detect == "y":
        video_reader()
    detect = input("Image Inspection?y/n")
    if detect == "y":
        print(image_inspection_summary(r"C:\Users\TRIDNT\Downloads\tyre.jpg"))
    

if __name__ == "__main__":
    main()

