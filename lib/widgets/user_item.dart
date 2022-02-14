import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../provider/models/user.dart';

class UserItem extends StatelessWidget {
  final UserDetails userDetails;
  final List<UserDetails> userList;
  final StreamSink<List<UserDetails>> streamSink;
  const UserItem({Key? key, required this.userDetails, required this.userList, required this.streamSink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
        key: UniqueKey(),
        startActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // A pane can dismiss the Slidable.
          dismissible: DismissiblePane(
              key: UniqueKey(),
              onDismissed: () {
                userList.remove(userDetails);

                streamSink.add(userList);
              }),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: doNothing,
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: UserTile(username: userDetails.username, picture: userDetails.profilePic));
  }

  void doNothing(BuildContext context) {}
}

class UserTile extends StatelessWidget {
  final String? username;
  final String? picture;

  const UserTile({Key? key, this.username, this.picture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: picture == null
            ? Image.asset(
                'assets/pic_placeholder.png',
                fit: BoxFit.contain,
              )
            : null,
        backgroundImage: (picture != null) ? Image.network(picture!).image : null,
      ),
      title: Text(username!, style: TextStyle(fontFamily: 'Lato', fontStyle: FontStyle.normal, fontWeight: FontWeight.w400)),
    );
  }
}
