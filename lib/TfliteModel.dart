import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TfliteModel(),
    );
  }
}

class TfliteModel extends StatefulWidget {
  @override
  _TfliteModelState createState() => _TfliteModelState();
}

class _TfliteModelState extends State<TfliteModel> {
  File? _image;
  List? _output;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    await Tflite.loadModel(
      model: 'assets/converted_model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _runInference();
      });
    }
  }

  Future<void> _runInference() async {
    if (_image == null) return;

    // Perform inference on the image
    final output = await Tflite.runModelOnImage(
      path: _image!.path,
      numResults: 2, // Adjust based on your model's output classes
      threshold: 0.2,
    );

    setState(() {
      _output = output;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 25),
        title: Text('Leaf Shield'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : Image.file(
              _image!,
              height: 500.0,
              width: 500.0,
            ),
            SizedBox(height: 20.0),
            _output != null
                ? Text('Inference result: ${_output![0]['label']}',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold))
                : Text('',),
          ],
        ),
      ),
    );
  }
}
