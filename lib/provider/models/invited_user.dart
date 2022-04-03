import 'package:flutter/cupertino.dart';

import 'user.dart';

class InvitedUserItem {
  final UserDetails user;
  bool isInvited;

  InvitedUserItem({required this.user, this.isInvited = false});
}

class InvitedUser with ChangeNotifier {
  Map<String, InvitedUserItem> _invitedUsers = {};

  Map<String, InvitedUserItem> get invitedUsers {
    return {..._invitedUsers};
  }

  int getLength() {
    return _invitedUsers.length;
  }

  void addUserToList(UserDetails user) {
    if (_invitedUsers.containsKey(user.email)) {
      // already exists in list

      return;
    } else {
      _invitedUsers.putIfAbsent(user.email, () => InvitedUserItem(user: user, isInvited: true));
    }

    notifyListeners();
  }

  void removeUserFromList(UserDetails user) {
    if (!_invitedUsers.containsKey(user.email)) {
      return;
    } else {
      _invitedUsers.removeWhere((key, invitedUserItem) => invitedUserItem.user.email == user.email);
      notifyListeners();
    }
  }

  void toggleIsAttending(String? email) {
    if (!_invitedUsers.containsKey(email)) {
      return;
    } else {
      final user = _invitedUsers[email];

      user?.isInvited = !user.isInvited;
      notifyListeners();
    }
  }

  void clearList() {
    _invitedUsers = {};
    notifyListeners();
  }
}
