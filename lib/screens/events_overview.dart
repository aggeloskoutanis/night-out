import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/controllers/event_controller.dart';
import 'package:flutter_firebase_login/screens/event_creation_screen.dart';
import 'package:flutter_firebase_login/widgets/event_card.dart';
import 'package:get/get.dart';

import '../provider/models/event.dart';

class EventsOverviewScreen extends StatefulWidget {
  const EventsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<EventsOverviewScreen> createState() => _EventsOverviewScreenState();
}

class _EventsOverviewScreenState extends State<EventsOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    // Provider.of<Events>(context).setEvents(widget.events);

    final EventController eventController = Get.put(EventController());
    // eventController.removeUnsavedEvents();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black54.withOpacity(0.0),
          child: const Icon(
            Icons.add,
          ),
          onPressed: () {
            // Navigator.of(context).pushNamed('/event-creation');
            // EventController eventController = Get.put(EventController());
            Event newEvent = Event.defaultConstructor();
            // eventController.addEvent(newEvent);

            Get.to(() => EventCreationScreen(event: newEvent));
          }),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushReplacementNamed(context, '/auth-screen');
                });
              },
              icon: const Icon(Icons.logout))
        ],
        backgroundColor: Colors.black87,
        title: const Text('Recent events', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700)),
      ),
      body: GetBuilder(
          init: eventController,
          builder: (ctx) {
            return Container(
                height: MediaQuery.of(context).size.height,
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
                child: ListView.builder(
                  itemCount: eventController.events.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => EventCard(event: eventController.events[index]),
                ));
          }),
    );
  }
}
