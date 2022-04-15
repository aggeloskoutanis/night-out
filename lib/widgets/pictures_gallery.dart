import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/provider/models/event.dart';
import 'package:flutter_firebase_login/widgets/add_picture.dart';
import 'package:flutter_firebase_login/widgets/picture_details.dart';
import 'package:get/get.dart';

import '../provider/models/picture.dart';

class PictureGallery extends StatefulWidget {
  final Event event;

  const PictureGallery({required this.event, Key? key}) : super(key: key);

  @override
  State<PictureGallery> createState() => _PictureGalleryState();
}

class _PictureGalleryState extends State<PictureGallery> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> _picToShow = [];
    //
    widget.event.pictures?.forEach((picture) {
      _picToShow.add(Picture(id: picture.id, imgURL: picture.imgURL, uploader: picture.uploader));
    });

    _picToShow.add(AddPicture(eventId: widget.event.id));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,
              crossAxisCount: 2,
            ),
            shrinkWrap: true,
            itemCount: _picToShow.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: _picToShow[index] is Picture
                      ? GestureDetector(
                          onTap: () {
                            Get.to(() => PictureDetails(image: _picToShow[index] as Picture, index: index.toString(), event: widget.event));
                            // Navigator.push(context, MaterialPageRoute(builder: (context) {
                            //   return PictureDetails(image: _picToShow[index] as Picture, index: index.toString(), event: widget.event);
                            // }));
                          },
                          child: Hero(
                              tag: 'image_' + index.toString(),
                              child:
                                  // Image.network(_picToShow[index], fit: BoxFit.fill
                                  CachedNetworkImage(
                                imageUrl: (_picToShow[index] as Picture).getImgURL,
                                fit: BoxFit.fill,
                                progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              )))
                      : _picToShow[index],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black87,
                  margin: const EdgeInsets.all(3),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
