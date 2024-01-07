import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafshield/utilities/utilities.dart';
import 'package:tflite/tflite.dart';
import '../main.dart';

class Upload_Screen extends StatefulWidget {
  const Upload_Screen({super.key});

  @override
  State<Upload_Screen> createState() => _Upload_ScreenState();
}

class _Upload_ScreenState extends State<Upload_Screen> {
  Uint8List? _image;

  Future<void> selectImage() async {
    Uint8List? im = await pickImage(ImageSource.gallery);
    if (im != null) {
      _image = im;
      await runInference(im);
    }
  }

  Future<void> captureImage() async {
    Uint8List? im = await pickImage(ImageSource.camera);
    if (im != null) {
      _image = im;
      await runInference(im);
    }
  }

  Future<void> runInference(Uint8List imageBytes) async {
    try {
      var output = await Tflite.runModelOnBinary(binary: imageBytes);
      print(output);
      // Process the output and update UI as needed
    } catch (e) {
      print('Error during inference: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Please provide an image', style: kTextStyle),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    await selectImage();
                  },
                  child: Container(
                    child: Center(
                      child: Text('Upload from gallery'),
                    ),
                    width: 180.0,
                    height: 40.0,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      color: Colors.orangeAccent,
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                InkWell(
                  onTap: () async {
                    await captureImage();
                  },
                  child: Container(
                    child: Center(
                      child: Text('Open Camera'),
                    ),
                    width: 180.0,
                    height: 40.0,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      color: Colors.orangeAccent,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
