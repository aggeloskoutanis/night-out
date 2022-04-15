import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/event_controller.dart';
import '../provider/models/event.dart';
import '../provider/models/picture.dart';

class PictureDetails extends StatelessWidget {
  final Picture image;
  final String index;
  final Event event;
  const PictureDetails({required this.image, required this.index, required this.event, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Hero(
            tag: 'image_' + index,
            child: SizedBox(
                child: CachedNetworkImage(
              imageUrl: image.imgURL,
              fit: BoxFit.fill,
              progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            )
                // Image.network(image, width: MediaQuery.of(context).size.width),
                ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AspectRatio(
                    aspectRatio: 2.0,
                    child: Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey), borderRadius: const BorderRadius.all(Radius.circular(10))),
                        child: const Text('Text here')),
                  ),
                  GestureDetector(
                    onTap: () => _deletePicture(context),
                    child: Container(
                      width: (MediaQuery.of(context).size.width / 2) - 30,
                      decoration: BoxDecoration(border: Border.all(color: Colors.redAccent), borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _deletePicture(context) {
    final eventController = Get.put(EventController());

    String eventCreator = event.eventCreator!;
    String pictureUploader = image.uploader!;

    User? loggedInUser = FirebaseAuth.instance.currentUser;

    if (loggedInUser?.uid != eventCreator && loggedInUser?.uid != pictureUploader) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete image. Only event creator and image uploader have the right to delete it.')),
      );
    }

    final Reference pictureRef = FirebaseStorage.instance.refFromURL(image.imgURL);

    pictureRef.delete();

    final picturesToDelete = event.pictures?.map((e) => e.toJson()).toList();

    picturesToDelete?.removeWhere((element) => element['id'] != image.id);

    eventController.removePictureFromEvent(event.id!, image);
    // Provider.of<Events>(context, listen: false).removePictureFromEvent(event.id, image);

    DocumentReference docRef = FirebaseFirestore.instance.doc('events/${event.id}');
    docRef.update({'images': FieldValue.arrayRemove(picturesToDelete!)});

    Get.back();
  }
}
