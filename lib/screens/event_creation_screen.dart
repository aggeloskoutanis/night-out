import 'package:flutter/material.dart';

import './../forms/event_creation_form.dart';
import '../provider/models/event.dart';

class EventCreationScreen extends StatelessWidget {
  final Event event;
  const EventCreationScreen({required this.event, Key? key}) : super(key: key);

  static const routeName = '/event-creation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text('Schedule an event', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700)),
      ),
      body: EventCreationForm(event: event),
    );
  }
}
