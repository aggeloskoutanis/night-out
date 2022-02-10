import 'package:flutter/material.dart';

import './../forms/event_creation_form.dart';

class EventCreationScreen extends StatelessWidget {
  const EventCreationScreen({Key? key}) : super(key: key);

  static const routeName = '/event-creation';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          'Recent events',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: Container(
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
          child: const EventCreationForm()),
    );
  }
}