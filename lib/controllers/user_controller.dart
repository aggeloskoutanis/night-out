import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../provider/models/user.dart';

class UserController extends GetxController {
  final List<UserDetails> _users = [];

  @override
  Future<void> onInit() async {
    FirebaseFirestore.instance.collection('users').get().then((snapshot) {
      final docs = snapshot.docs;

      docs.forEach((doc) {
        _users.add(
          UserDetails(
            id: doc.id,
            profilePic: doc['prof_pic'] as String,
            email: doc['email'] as String,
            username: doc['user_name'] as String,
          ),
        );
      });
    });

    update();
    super.onInit();
  }

  UserDetails findUserById(String id) {
    return _users.firstWhere((user) => user.id == id);
  }

  List<UserDetails> get users {
    return [..._users];
  }

  void addUser(UserDetails newUser) {
    _users.add(newUser);
    update();
  }

  void removeUser(UserDetails userToRemove) {
    _users.removeWhere((user) => user.id == userToRemove.id);
    update();
  }

  void removeUserById(String userId) {
    _users.removeWhere((user) => user.id == userId);
    update();
  }

  List<UserDetails> searchUserByName(String keyword) {
    var userToReturn = <UserDetails>[];

    for (var user in _users) {
      if (user.username.contains(keyword)) {
        userToReturn.add(user);
      }
    }

    return userToReturn;
  }
}
