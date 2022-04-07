import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/widgets/add_picture.dart';
import 'package:flutter_firebase_login/widgets/picture_details.dart';

import 'event_card.dart';

class PictureGallery extends StatefulWidget {
  final EventCard event;
  final Function callback;

  const PictureGallery({required this.event, required this.callback, Key? key}) : super(key: key);

  @override
  State<PictureGallery> createState() => _PictureGalleryState();
}

class _PictureGalleryState extends State<PictureGallery> {
  final List<dynamic> _picToShow = [];

  @override
  Widget build(BuildContext context) {
    void _addPicture(String picPath) {
      setState(() {
        widget.event.pictures!.insert(0, picPath);
        widget.callback();
      });
    }

    // _picToShow.clear();
    if (_picToShow.isEmpty) {
      _picToShow.addAll(widget.event.pictures!);
      _picToShow.add(AddPicture(
        eventId: widget.event.id,
        callback: _addPicture,
      ));
    } else {
      _picToShow.insert(0, widget.event.pictures!.first);
    }

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
                  child: _picToShow[index] is String
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return PictureDetails(image: _picToShow[index] as String, index: index.toString());
                            }));
                          },
                          child: Hero(
                              tag: 'image_' + index.toString(),
                              child:
                                  // Image.network(_picToShow[index], fit: BoxFit.fill
                                  CachedNetworkImage(
                                imageUrl: _picToShow[index],
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
          )
        ],
      ),
    );
  }
}
