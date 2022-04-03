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
}
