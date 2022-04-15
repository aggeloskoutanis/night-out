import 'package:flutter_firebase_login/provider/models/invited_user.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../provider/models/user.dart';

class InviteUsersController extends GetxController {
  final List<InvitedUserItem> _invitedUsers = [];
  final List<InvitedUserItem> _searchList = [];

  List<InvitedUserItem> get invitedUsers => [..._invitedUsers];
  List<InvitedUserItem> get searchList => [..._searchList];

  void insertUserInList(UserDetails newUser) {
    _invitedUsers.add(InvitedUserItem(user: newUser, isInvited: true));
    update();
  }

  void removeUserFromList(UserDetails removeUser) {
    _invitedUsers.removeWhere((element) => element.user.id == removeUser.id);
    update();
  }

  void insertSearchList(UserDetails newUser, bool isInvited) {
    _searchList.add(InvitedUserItem(user: newUser, isInvited: isInvited));
    update();
  }

  void removeSearchList(UserDetails removeUser) {
    _searchList.remove(InvitedUserItem(user: removeUser, isInvited: true));
    update();
  }

  void clearSearchList() {
    _searchList.clear();
    update();
  }
}
