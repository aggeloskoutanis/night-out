import 'package:flutter_firebase_login/provider/models/picture.dart';

class Event {
  String? _eventName;
  String? _eventDate;
  List<Picture> _pictures = <Picture>[];
  List<String> _invitedUsers = <String>[];
  String? _eventLocation;
  String? _id;
  String? _eventAddress;
  String? _eventCreator;

  Event.defaultConstructor();
  Event(String id, String eventDate, List<dynamic> pictures, List<dynamic> invitedUsers, String eventName, String eventAddress, String eventCreator, String eventLocation) {
    _eventName = eventName;
    _eventDate = eventDate;
    _id = id;
    _pictures = <Picture>[];
    _invitedUsers = <String>[];
    //
    // if (pictures.isNotEmpty) {
    //   _pictures = <Picture>[];
    // }

    for (var pic in pictures) {
      _pictures.add(Picture(id: pic['id'], imgURL: pic['img_url'], uploader: pic['img_uploader']));
    }

    _invitedUsers = invitedUsers.isEmpty ? [] : [...invitedUsers];

    _eventAddress = eventAddress;
    _eventLocation = eventLocation;
    _eventCreator = eventCreator;
  }

  void setInvitedUsers(List<String>? invitedUsers) {
    _invitedUsers = invitedUsers!;
  }

  String? get id => _id;

  List<Picture>? get pictures => _pictures;

  String? get eventCreator => _eventCreator;

  String? get eventAddress => _eventAddress;

  String? get eventLocation => _eventLocation;

  List<String>? get invitedUsers => _invitedUsers;

  String get eventDate => _eventDate!;

  String get eventName => _eventName!;

  set eventDate(String value) {
    _eventDate = value;
  }

  set eventName(String value) {
    _eventName = value;
  }
}
