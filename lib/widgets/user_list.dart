import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../provider/models/user.dart';

class UserList extends StatefulWidget {
  final List<UserDetails>? peopleToInvite;
  final List<UserDetails>? userEmails;

  const UserList({
    Key? key,
    required this.peopleToInvite,
    required this.userEmails,
  }) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final peopleToInviteStream = StreamController<List<UserDetails>>();

  @override
  void dispose() {
    // TODO: implement dispose

    peopleToInviteStream.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.35),
      color: Colors.red.withOpacity(0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: TextField(
                style: const TextStyle(color: Colors.white70),
                decoration: InputDecoration(
                    prefixIcon: GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.supervised_user_circle_sharp,
                        color: Colors.white70,
                      ),
                    ),
                    hintText: "Find users to invite",
                    hintStyle: const TextStyle(color: Colors.white70),
                    // errorText: "Invalid input",
                    label: const Text(
                      "Search user",
                      style: TextStyle(color: Colors.white70),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blueGrey,
                        ),
                        borderRadius: BorderRadius.circular(8.0)),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blueGrey,
                        ),
                        borderRadius: BorderRadius.circular(8.0)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal, width: 2))),
                // The validator receives
                onChanged: (selectedValue) {
                  if (widget.peopleToInvite!.length <
                      (widget.userEmails as List).length) {
                    UserDetails? foundUser = widget.userEmails
                        ?.firstWhereOrNull(
                            (element) => element.username == selectedValue);

                    UserDetails? alreadyInList = widget.peopleToInvite
                        ?.firstWhereOrNull(
                            (element) => foundUser?.id == element.id);

                    if (foundUser != null && alreadyInList == null) {
                      widget.peopleToInvite?.add(foundUser);

                      peopleToInviteStream.sink.add(widget.peopleToInvite!);

                      // print('found!');
                    }
                  }
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder(
                stream: peopleToInviteStream.stream,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data != null) {
                    List<UserDetails> selectedUsers =
                        snapshot.data as List<UserDetails>;
                    return Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(0.0),
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.blueGrey),
                      //     borderRadius: BorderRadius.circular(8.00),
                      //     color: Colors.red),
                      child: ListView.builder(
                          itemCount: selectedUsers.length,
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return UserListItem(
                                foundUser: selectedUsers[index]);
                          }),
                    );
                  } else {
                    return const Text('Nothing to Show');
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class UserListItem extends StatefulWidget {
  final UserDetails foundUser;

  const UserListItem({required this.foundUser, Key? key}) : super(key: key);

  @override
  State<UserListItem> createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        title: Text(widget.foundUser.username),
        value: false,
        controlAffinity: ListTileControlAffinity.trailing,
        secondary: CircleAvatar(
          backgroundImage: Image.network(widget.foundUser.profilePic).image,
        ),
        onChanged: (bool? value) {
          // TODO implement add/remove person from PeopleToInviteList

          setState(() {
            // _isChecked = !_isChecked;
          });
        },
      ),
    );
  }
}
