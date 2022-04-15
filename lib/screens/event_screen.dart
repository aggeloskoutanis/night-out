import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/event_controller.dart';
import '../provider/models/event.dart';
import '../widgets/pictures_gallery.dart';

class EventScreen extends StatelessWidget {
  final Event event;

  const EventScreen({required this.event, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventController = Get.put(EventController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text('Event overview', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700)),
      ),
      body: GetBuilder(
        init: EventController(),
        builder: (context) => Container(
          alignment: Alignment.topCenter,
          child: PictureGallery(event: eventController.findEventById(event.id!)),
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
      ),
    );
  }
}
