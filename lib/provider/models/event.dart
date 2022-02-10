import 'package:flutter/material.dart';

class Event with ChangeNotifier {
  final String? id;
  final String? title;
  final String? date;
  final String? location;
  final List<String>? images;

  Event(this.id, this.title, this.date, this.location, this.images);
}
