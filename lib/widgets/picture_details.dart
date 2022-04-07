import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PictureDetails extends StatelessWidget {
  final String image;
  final String index;

  const PictureDetails({required this.image, required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Hero(
            tag: 'image_' + index,
            child: SizedBox(
                child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.fill,
              progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => Icon(Icons.error),
            )
                // Image.network(image, width: MediaQuery.of(context).size.width),
                ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: Center(
                child: Text('Text here'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
