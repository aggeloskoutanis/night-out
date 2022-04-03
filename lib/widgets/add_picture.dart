import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPicture extends StatefulWidget {
  final Function callback;
  final eventId;
  const AddPicture({required this.eventId, required this.callback, Key? key}) : super(key: key);

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  FirebaseAuth? _auth;
  FirebaseStorage? _fbstorage;
  var userEvents;
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();

    _auth = FirebaseAuth.instance;
    _fbstorage = FirebaseStorage.instance;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _pickImage().then((uploadedPic) {
          _isLoading.value = true;
          _uploadProfilePicToFb(_auth?.currentUser?.uid, uploadedPic!, _fbstorage!).then((picPathInFirestore) async {
            if (picPathInFirestore == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to upload image.Please try again.')),
              );
            } else {
              widget.callback(picPathInFirestore);
              await FirebaseFirestore.instance.doc('events/${widget.eventId}').update({
                'images': FieldValue.arrayUnion([picPathInFirestore])
              });
              _isLoading.value = false;
            }
          });
        });
      },
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.white70, width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: Colors.red.withOpacity(0.6),
        ),
        width: 30,
        height: 50,
        child: ValueListenableBuilder<bool>(
          builder: (context, value, child) {
            return Center(
              child: value
                  ? const CircularProgressIndicator()
                  : Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
                      Icon(
                        Icons.image_search_outlined,
                        size: 50,
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Text('Add an new image')
                    ]),
            );
          },
          valueListenable: _isLoading,
        ),
      ),
    );
  }

  Future<File?> _pickImage() async {
    final picker = ImagePicker();

    final XFile? pickedImageFile = await picker.pickImage(source: ImageSource.gallery);

    return File(pickedImageFile!.path);
  }

  Future<String?> _uploadProfilePicToFb(String? userUid, File file, FirebaseStorage fireStorage) async {
    String uid = userUid!;

    Reference ref = fireStorage.ref().child("images").child(uid + DateTime.now().toIso8601String() + '.jpg');
    await ref.putFile(file);

    return ref.getDownloadURL();
  }
}
