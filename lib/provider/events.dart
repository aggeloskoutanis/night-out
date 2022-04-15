import 'package:flutter/material.dart';

import './models/event.dart';

class Events with ChangeNotifier {
  String? authToken;
  String? userId;

  List<Event> _events = [];

  Events.defaultConstructor();
  Events(this.authToken, this.userId, this._events);

  String? getCurrentUserId() {
    return userId;
  }

  List<Event> get events {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._events];
  }

  void addEvent(Event eventToAdd) {
    _events.add(eventToAdd);
    notifyListeners();
  }

  void setEvents(List<Event> events) {
    _events.addAll(events);
    notifyListeners();
  }

  void removeEvent(String eventId) {
    _events.removeWhere((event) => event.id == eventId);
    notifyListeners();
  }
  //
  // void removePictureFromEvent(String eventId, Picture picToRemove) {
  //   Event foundEvent = _events.firstWhere((event) => event.id == eventId);
  //
  //   foundEvent.pictures.removeWhere((picture) => picture.id == picToRemove.id);
  //   notifyListeners();
  // }
  //
  // void updatePicturesOfAnEvent(String eventId, List<Picture> updatedPictureArray) {
  //   Event foundEvent = _events.firstWhere((event) => event.id == eventId);
  //
  //   foundEvent.pictures.clear();
  //   foundEvent.pictures.addAll(updatedPictureArray);
  //   notifyListeners();
  // }
  //
  // void addPictureToEvent(String eventId, Picture newPic) {
  //   Event foundEvent = _events.firstWhere((event) => event.id == eventId);
  //
  //   foundEvent.pictures.add(newPic);
  //   notifyListeners();
  // }
}
