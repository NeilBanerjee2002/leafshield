import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const kTextStyle = TextStyle(
  fontFamily: 'Sofia',
  fontSize: 30.0,
  fontWeight: FontWeight.w200,
);

Future<Uint8List?> pickImage(ImageSource source) async {
  try{final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }}catch(e){
    print("$e");
    return null;
  }
}