import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/widgets/event_card.dart';

class EventsOverviewScreen extends StatelessWidget {
  const EventsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black54.withOpacity(0.0),
          child: const Icon(
            Icons.add,
          ),
          onPressed: () async {
            Navigator.of(context).pushNamed('/event-creation');
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
        child: Column(
          children: const [EventCard(), EventCard(), EventCard()],
        ),
      ),
    );
  }
}
