import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/event_controller.dart';
import '../provider/models/picture.dart';

class AddPicture extends StatefulWidget {
  final eventId;
  const AddPicture({required this.eventId, Key? key}) : super(key: key);

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
    final eventController = Get.put(EventController());

    return GestureDetector(
      onTap: () async {
        _pickImage().then((uploadedPic) {
          _isLoading.value = true;
          _uploadProfilePicToFb(_auth?.currentUser?.uid, uploadedPic!, _fbstorage!).then((picPathInFirestore) async {
            final CollectionReference picsRef = FirebaseFirestore.instance.collection('pictures');

            await picsRef.add({'pic_url': picPathInFirestore, 'upload_date': DateTime.now().toIso8601String(), 'uploader_uuid': _auth?.currentUser?.uid}).then((docRef) {
              Picture newPic = Picture(id: docRef.id, imgURL: picPathInFirestore!, uploader: _auth?.currentUser?.uid);

              eventController.addPictureToEvent(widget.eventId, newPic);
              // Provider.of<Events>(context).addPictureToEvent(widget.eventId, newPic);

              FirebaseFirestore.instance.doc('events/${widget.eventId}').update({
                'images': FieldValue.arrayUnion([newPic.toJson()])
              });
              _isLoading.value = false;
            }).onError((error, stackTrace) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to upload image.Please try again.')),
              );
            });
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
