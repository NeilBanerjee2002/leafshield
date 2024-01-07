import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafshield/main.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      model: 'assets/model.tflite',
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<File> preprocessImage(File imageFile) async {
    // Read and decode the image
    img.Image image = img.decodeImage(await imageFile.readAsBytes())!;

    // Resize the image to the required dimensions
    img.Image resizedImage = img.copyResize(image, width: 250, height: 250);

    // Normalize pixel values to the range [0, 1]
    List<int> normalizedPixels = [];
    for (int pixel in resizedImage.getBytes()) {
      normalizedPixels.add((pixel / 255.0 * 255).toInt());
    }

    // Convert to Uint8List
    Uint8List uint8List = Uint8List.fromList(normalizedPixels);

    // Create a new File with the preprocessed image data
    File preprocessedFile = await File(imageFile.path + '_preprocessed.jpg').writeAsBytes(uint8List);

    return preprocessedFile;
  }

  Future<void> _runInference() async {
    if (_image == null) return;

    // Perform inference on the image
    final output = await Tflite.runModelOnImage(
      path: _image!.path,
      numResults: 3, // Adjust based on your model's output classes
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
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          ElevatedButton(onPressed: (){
            try{
              _auth.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Successfully Signed Out'),
                  backgroundColor: Colors.green,
                ),
              );
            }catch(e){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error Signing Out'),
                  
                  backgroundColor: Colors.orange,
                ),
              );
            }
          }, child:Text('Sign Out'))
        ],
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 25),
        title: Text('Leaf Shield'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        backgroundColor: Colors.white,
        tooltip: 'Pick Image',
        child: Image.network('https://firebasestorage.googleapis.com/v0/b/leaf-shield-93d74.appspot.com/o/360_F_107579101_QVlTG43Fwg9Q6ggwF436MPIBTVpaKKtb.jpg?alt=media&token=268e41b9-e63f-4d8d-8a02-38a67372ea60'),
        // child: Icon(Icons.upload),
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