import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicPicker extends StatefulWidget {
  final Function(File image) pickedImage;

  const ProfilePicPicker(this.pickedImage, {Key? key}) : super(key: key);

  @override
  _ProfilePicPickerState createState() => _ProfilePicPickerState();
}

class _ProfilePicPickerState extends State<ProfilePicPicker> {
  File? _pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();

    final XFile? pickedImageFile =
        await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            child: _pickedImage == null
                ? Image.asset(
                    'assets/pic_placeholder.png',
                    fit: BoxFit.contain,
                  )
                : null,
            backgroundImage: (_pickedImage != null)
                ? Image(
                    image: FileImage(_pickedImage!),
                  ).image
                : null),
        SizedBox(
          height: 10,
        ),
        ElevatedButton.icon(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.white.withOpacity(0)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(
                          width: 2.0,
                          color: Colors.blueGrey,
                          style: BorderStyle.solid)),
                )),
            onPressed: _pickImage,
            icon: Icon(
              Icons.image_search_outlined,
              color: Colors.teal,
            ),
            label: Text(
              'Upload image',
              style: TextStyle(color: Colors.blueGrey),
              textAlign: TextAlign.left,
            ))
      ],
    );
  }
}
