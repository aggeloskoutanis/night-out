import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../provider/models/event.dart';
import '../provider/models/picture.dart';
import '../provider/models/user.dart';

class EventController extends GetxController {
  final List<Event> _events = [];

  @override
  Future<void> onInit() async {
    await FirebaseFirestore.instance.collection('events').get().then((snapshot) {
      final docs = snapshot.docs;

      docs.forEach((doc) {
        _events.add(
          Event(
            doc.id,
            doc['event_date'] as String,
            doc['images'] as List<dynamic>,
            doc['invited_users'] as List<dynamic>,
            doc['event_name'] as String,
            doc['event_address'] as String,
            doc['event_creator'] as String,
            doc['event_location'] as String,
          ),
        );
      });
    });
    update();
    super.onInit();
  }

  Event findEventById(String id) {
    return _events.firstWhere((event) => event.id == id);
  }

  List<Event> get events {
    return [..._events];
  }

  void addPictureToEvent(String eventId, Picture pictureToAdd) {
    Event event = _events.firstWhere((event) => event.id == eventId);
    event.pictures?.add(pictureToAdd);
    update();
  }

  void removePictureFromEvent(String eventId, Picture pictureToRemove) {
    Event event = _events.firstWhere((event) => event.id == eventId);
    event.pictures?.removeWhere((picture) => picture.id == pictureToRemove.id);
    update();
  }

  void addInvitedUserToEvent(Event newEvent, UserDetails userToAdd) {
    Event event = _events.firstWhere((event) => event == newEvent);
    event.invitedUsers?.add(userToAdd.id);
    update();
  }

  void removeInvitedUserFromEvent(Event newEvent, UserDetails userToRemove) {
    Event event = _events.firstWhere((event) => event == newEvent);
    event.invitedUsers?.removeWhere((userId) => userId == userToRemove.id);
    update();
  }

  List<String> getInvitedUsers(Event newEvent) {
    Event event = _events.firstWhere((event) => event == newEvent);

    return [...?event.invitedUsers];
  }

  List<Picture> getEventPictures(String eventId) {
    Event event = _events.firstWhere((event) => event.id == eventId);

    return [...?event.pictures];
  }

  void addEvent(Event newEvent) {
    _events.add(newEvent);
    update();
  }

  void removeEvent(Event eventToRemove) {
    _events.removeWhere((event) => event.id == eventToRemove.id);
    update();
  }

  void removeEventById(String eventId) {
    _events.removeWhere((event) => event.id == eventId);
    update();
  }

  void removeUnsavedEvents() {
    _events.map((event) {
      if (event.id == null) {
        _events.remove(event);
      }
    });

    update();
  }
}
