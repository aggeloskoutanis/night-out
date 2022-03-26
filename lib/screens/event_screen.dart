import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/widgets/pictures_gallery.dart';

import '../widgets/event_card.dart';

class EventScreen extends StatelessWidget {
  final EventCard event;

  const EventScreen({required this.event, Key? key}) : super(key: key);

  static const routeName = '/event-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text('Event overview', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700)),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: PictureGallery(pictures: event.pictures!),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                const Color.fromRGBO(1, 1, 1, 1).withOpacity(1),
                const Color.fromRGBO(1, 25, 38, 1).withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0, 1]),
        ),
      ),
    );
  }
}
