import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UtilsImage {
  static Future<File?> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    final selectedOption = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Escolha uma opção'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Galeria'),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Câmera'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );

    if (selectedOption != null) {
      final XFile? pickedFile = await picker.pickImage(source: selectedOption);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    }
    return null;
  }
}