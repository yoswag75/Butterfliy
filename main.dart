import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  MyApp({required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inspection App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(camera: camera),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final CameraDescription camera;

  SplashScreen({required this.camera});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ModeSelectionScreen(camera: widget.camera),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Butterfliy',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ModeSelectionScreen extends StatelessWidget {
  final CameraDescription camera;

  ModeSelectionScreen({required this.camera});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Mode'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeftFrontTyre(),
                      ),
                    );
                  },
                  child: Text('Training Mode'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InspectionForm(camera: camera),
                      ),
                    );
                  },
                  child: Text('Inspection Mode'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BadgesScreen(),
                    ),
                  );
                },
                child: Text('Badges'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InspectionForm extends StatefulWidget {
  final CameraDescription camera;

  InspectionForm({required this.camera});

  @override
  _InspectionFormState createState() => _InspectionFormState();
}

class _InspectionFormState extends State<InspectionForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _machineSerialNumberController =
      TextEditingController();
  final TextEditingController _machineModelController = TextEditingController();
  final TextEditingController _inspectionIDController = TextEditingController();
  final TextEditingController _inspectorNameController =
      TextEditingController();
  final TextEditingController _inspectorEmployeeIDController =
      TextEditingController();
  final TextEditingController _dateOfInspectionController =
      TextEditingController();
  final TextEditingController _timeOfInspectionController =
      TextEditingController();
  final TextEditingController _locationOfInspectionController =
      TextEditingController();
  final TextEditingController _serviceMeterHoursController =
      TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _catCustomerIDController =
      TextEditingController();

  @override
  void dispose() {
    _machineSerialNumberController.dispose();
    _machineModelController.dispose();
    _inspectionIDController.dispose();
    _inspectorNameController.dispose();
    _inspectorEmployeeIDController.dispose();
    _dateOfInspectionController.dispose();
    _timeOfInspectionController.dispose();
    _locationOfInspectionController.dispose();
    _serviceMeterHoursController.dispose();
    _customerNameController.dispose();
    _catCustomerIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inspection Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _machineSerialNumberController,
                decoration: InputDecoration(
                  labelText: 'Machine Serial Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the machine serial number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _machineModelController,
                decoration: InputDecoration(
                  labelText: 'Machine Model',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the machine model';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _inspectionIDController,
                decoration: InputDecoration(
                  labelText: 'Inspection ID',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the inspection ID';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CameraCaptureScreen(camera: widget.camera),
                    ),
                  );
                },
                child: Text('Open Camera'),
              ),
              TextFormField(
                controller: _inspectorNameController,
                decoration: InputDecoration(
                  labelText: 'Inspector Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the inspector name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _inspectorEmployeeIDController,
                decoration: InputDecoration(
                  labelText: 'Inspector Employee ID',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the inspector employee ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateOfInspectionController,
                decoration: InputDecoration(
                  labelText: 'Date of Inspection',
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateOfInspectionController.text =
                          "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the date of inspection';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _timeOfInspectionController,
                decoration: InputDecoration(
                  labelText: 'Time of Inspection',
                ),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _timeOfInspectionController.text =
                          pickedTime.format(context);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the time of inspection';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationOfInspectionController,
                decoration: InputDecoration(
                  labelText: 'Location of Inspection',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location of inspection';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _serviceMeterHoursController,
                decoration: InputDecoration(
                  labelText: 'Service Meter Hours',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the service meter hours';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _customerNameController,
                decoration: InputDecoration(
                  labelText: 'Customer Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the customer name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _catCustomerIDController,
                decoration: InputDecoration(
                  labelText: 'CAT Customer ID',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the CAT customer ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraScreen(camera: widget.camera),
                    ),
                  );
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CameraScreen extends StatelessWidget {
  final CameraDescription camera;

  CameraScreen({required this.camera});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CameraWithInputScreen(camera: camera),
              ),
            );
          },
          child: Text('Open Camera'),
        ),
      ),
    );
  }
}

class CameraCaptureScreen extends StatefulWidget {
  final CameraDescription camera;

  CameraCaptureScreen({required this.camera});

  @override
  _CameraCaptureScreenState createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Capture'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_cameraController);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await _initializeControllerFuture;
                  final image = await _cameraController.takePicture();
                  print('Image captured: ${image.path}');
                } catch (e) {
                  print(e);
                }
              },
              child: Text('Take Snapshot'),
            ),
          ),
        ],
      ),
    );
  }
}

class CameraWithInputScreen extends StatefulWidget {
  final CameraDescription camera;

  CameraWithInputScreen({required this.camera});

  @override
  _CameraWithInputScreenState createState() => _CameraWithInputScreenState();
}

class _CameraWithInputScreenState extends State<CameraWithInputScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  final TextEditingController _inputTextController = TextEditingController();
  final TextEditingController _outputTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _inputTextController.dispose();
    _outputTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera with Input'),
      ),
      body: Column(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: CameraPreview(_cameraController),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _initializeControllerFuture;
                final image = await _cameraController.takePicture();
                print('Image captured: ${image.path}');
              } catch (e) {
                print(e);
              }
            },
            child: Text('Take Snapshot'),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _inputTextController,
                      decoration: InputDecoration(
                        labelText: 'Input Text',
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _outputTextController,
                      decoration: InputDecoration(
                        labelText: 'Output Text',
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Implement microphone functionality here
                      },
                      child: Text('Use Microphone'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BadgesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Badges'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('10 Repairs in a Day'),
            subtitle:
                Text('Awarded for completing 10 repairs in a single day.'),
          ),
          ListTile(
            title: Text('Excellence in Inspection'),
            subtitle: Text('Awarded for outstanding inspection quality.'),
          ),
          ListTile(
            title: Text('Maintenance Master'),
            subtitle: Text('Awarded for completing 50 inspections.'),
          ),
          ListTile(
            title: Text('Speedy Technician'),
            subtitle:
                Text('Awarded for completing an inspection within 30 minutes.'),
          ),
          ListTile(
            title: Text('Perfect Record'),
            subtitle: Text('Awarded for a flawless inspection report.'),
          ),
          // Add more badges here as needed
        ],
      ),
    );
  }
}

class LeftFrontTyre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tyre Inspection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Check Left Front Tyre',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\n- Check tyre pressure\n- Check tyre Condition',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Image(
              image: AssetImage('images/tyres1.png'),
              height: 200,
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RightFrontTyre(),
                    ),
                  ); // Navigate to the next training step or perform the next action
                },
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RightFrontTyre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tyre Inspection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Check Right Front Tyre',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\n- Check tyre pressure\n- Check tyre Condition',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Image(
              image: AssetImage('images/tyres2.png'),
              height: 200,
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeftRearTyre(),
                    ),
                  );
                }, // Navigate to the next training step or perform the next action
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeftRearTyre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tyre Inspection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Check Left Rear Tyre',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\n- Check tyre pressure\n- Check tyre Condition',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Image(
              image: AssetImage('images/tyres1.png'),
              height: 200,
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RightRearTyre(),
                    ),
                  );
                }, // Navigate to the next training step or perform the next action
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RightRearTyre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tyre Inspection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Check Right Rear Tyre',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\n- Check tyre pressure\n- Check tyre Condition',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Image(
              image: AssetImage('images/tyres2.png'),
              height: 200,
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BatteryInspection(),
                    ),
                  );
                }, // Navigate to the next training step or perform the next action
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BatteryInspection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battery Inspection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Check Battery',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\n- Identify Battery Make\n- Record Battery Replacement Date\n- Measure Battery Voltage\n- Check Battery Water Level\n- Inspect Battery Condition\n- Check for leaks or Rust',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Image(
              image: AssetImage('images/battery0.png'),
              height: 200,
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExteriorInspection(),
                    ),
                  );
                }, // Navigate to the next training step or perform the next action
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExteriorInspection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exterior Machine Inspection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Check the Exterior Machine',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\n- Inspect for Rust, Dents, or Damage\n- Check for Oil Leaks in Suspension\n- Write an overall Exterior Machine Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Image(
              image: AssetImage('images/engine0.png'),
              height: 200,
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BrakesInspection(),
                    ),
                  );
                }, // Navigate to the next training step or perform the next action
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BrakesInspection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brakes Inspection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Check the Brakes',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\n- Check Brake Fluid Level\n- Evaluate Brake Condition (Front)\n- Evaluate Brake Condition (Rear)\n- Check Emergency Brakes\n- Write an Overall Brakes Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Image(
              image: AssetImage('images/brakes0.png'),
              height: 200,
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EngineInspection(),
                    ),
                  );
                }, // Navigate to the next training step or perform the next action
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EngineInspection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Engine Inspection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Check the Engine',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\n- Check for Rust, Dents, or Damage in Engine\n- Evaluate Engine Oil Condition\n- Assess Engine Oil Colour\n- Evaluate Brake FLuid Condition\n- Assess Brake Fluid Colour\n- Check for Oil Leaks in Engine\n- Write an overall Engine Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Image(
              image: AssetImage('images/engine0.png'),
              height: 200,
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VoiceOfCustomer(),
                    ),
                  );
                }, // Navigate to the next training step or perform the next action
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VoiceOfCustomer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice of Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Learn How to Document Customer Feedback and Related Issues',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\n- Record Customer Feedback\n- Attach Images Related to Feedback',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Image(
              image: AssetImage('images/engine0.png'),
              height: 200,
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  /*Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModeSelectionScreen(camera:), // Pass null if camera is not required
                    ),
                  );*/
                }, // Navigate to the next training step or perform the next action
                child: Text('Finish'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
