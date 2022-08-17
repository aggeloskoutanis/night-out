import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../provider/models/user.dart';

enum BorderColor { amber, teal, deepOrange, deepPurple, lime }

class UserListItems extends StatelessWidget {
  final UserDetails user;

  const UserListItems({required this.user, Key? key}) : super(key: key);

  MaterialColor _pickColor(BorderColor color) {
    MaterialColor materialColor;

    switch (color) {
      case BorderColor.amber:
        materialColor = Colors.amber;
        break;
      case BorderColor.teal:
        materialColor = Colors.teal;
        break;
      case BorderColor.deepOrange:
        materialColor = Colors.deepOrange;
        break;
      case BorderColor.deepPurple:
        materialColor = Colors.deepPurple;
        break;
      case BorderColor.lime:
        materialColor = Colors.lime;
        break;
    }

    return materialColor;
  }

  @override
  Widget build(BuildContext context) {
    int max = 3;
    final color = BorderColor.values.elementAt(Random().nextInt(max) + 1);

    return Card(
      shape: RoundedRectangleBorder(side: BorderSide(color: _pickColor(color), width: 1.0), borderRadius: BorderRadius.circular(4.0)),
      color: Colors.transparent,
      child: ListTile(
          leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _pickColor(color),
                width: 1.0,
              ),
            ),
            child: CircleAvatar(
              child: ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(48),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: user.profilePic,
                    progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
              backgroundImage: null,
              // Image.network(user.profilePic).image,
            ),
          ),
          title: Text(
            user.username,
            style: TextStyle(color: _pickColor(color), fontWeight: FontWeight.w400),
          )),
    );
  }
}
