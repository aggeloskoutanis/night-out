import 'package:flutter/material.dart';

class PictureGallery extends StatefulWidget {
  final List<dynamic> pictures;

  const PictureGallery({required this.pictures, Key? key}) : super(key: key);

  @override
  State<PictureGallery> createState() => _PictureGalleryState();
}

class _PictureGalleryState extends State<PictureGallery> {
  var _picToShow;
  @override
  Widget build(BuildContext context) {
    List<dynamic> picsToShow = [];
    if (widget.pictures.isEmpty) {
      picsToShow.add(SizedBox(width: 80, height: 50, child: Image.asset('assets/picture_placeholder.png')));
    } else {
      widget.pictures.forEach((pic) {
        picsToShow.add(SizedBox(
            width: 80,
            height: 50,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    _picToShow = Image(width: 80, height: 50, fit: BoxFit.fill, image: NetworkImage(pic));
                  });
                },
                child: Picture(imgUrl: pic))));
      });
    }
    return Column(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width,
            child: widget.pictures.isEmpty
                ? SizedBox(width: 80, height: 50, child: Image.asset('assets/picture_placeholder.png'))
                : (_picToShow ?? Image(width: 80, height: 50, fit: BoxFit.fill, image: NetworkImage(widget.pictures.first)))),
        Row(
          children: [...picsToShow],
        )
      ],
    );
  }
}

class Picture extends StatelessWidget {
  final String imgUrl;

  const Picture({required this.imgUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(imgUrl);
  }
}
