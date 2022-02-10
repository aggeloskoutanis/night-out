import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../provider/models/user.dart';

class UserItem extends StatelessWidget {
  final UserDetails user_details;
  final user_list;
  final StreamSink<List<UserDetails>> stream_sink;
  const UserItem(
      {Key? key,
      required this.user_details,
      required this.user_list,
      required this.stream_sink})
      : super(key: key);

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
                user_list.remove(user_details);

                stream_sink.add(user_list);
              }),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: doNothing,
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: UserTile(
            username: user_details.username,
            picture: user_details.profile_pic));
  }

  void doNothing(BuildContext context) {}
}

class UserTile extends StatelessWidget {
  final username;
  final picture;

  const UserTile({Key? key, this.username, this.picture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: null,
      ),
      title: Text(username),
    );
  }
}
