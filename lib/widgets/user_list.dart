import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/provider/models/user.dart';
import 'package:provider/provider.dart';

import '../provider/models/invited_user.dart';

class UserList extends StatefulWidget {
  final InvitedUser peopleToInvite;
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
  List<InvitedUserItem> searchUserList = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<InvitedUser>(
        builder: (context, invitedUser, child) => SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height * 0.26),
                // constraints:
                //     BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.35),
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
                              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal, width: 2))),
                          // The validator receives
                          onChanged: (selectedValue) {
                            searchUserList.clear();

                            if (invitedUser.invitedUsers.isNotEmpty) {
                              InvitedUserItem? temp = invitedUser.invitedUsers.values.firstWhereOrNull((element) => element.user.username == selectedValue);

                              if (temp != null) {
                                searchUserList.add(temp);
                              }
                            }

                            if (widget.peopleToInvite.invitedUsers.length < (widget.userEmails as List).length) {
                              List<UserDetails>? foundUsers = widget.userEmails?.where((element) => element.username == selectedValue).toList();
                              if (foundUsers != null && foundUsers.isNotEmpty) {
                                // widget.peopleToInvite.addUserToList(...foundUsers);

                                for (var foundUser in foundUsers) {
                                  InvitedUserItem? doesExist = searchUserList.firstWhereOrNull((element) => element.user.email == foundUser.email);

                                  if (doesExist == null) {
                                    searchUserList.add(InvitedUserItem(user: foundUser));
                                  }
                                }

                                FocusManager.instance.primaryFocus?.unfocus();
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                          itemCount: searchUserList.length,
                          shrinkWrap: true,
                          itemBuilder: (ctx, i) {
                            if (searchUserList.isEmpty) {
                              return const Text('No one is invited yet!', style: TextStyle(color: Colors.white));
                            } else {
                              return Container(color: Colors.transparent, child: UserListItem(foundUser: searchUserList[i], invitedUsers: invitedUser));
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ));
  }
}

class UserListItem extends StatelessWidget {
  final InvitedUserItem foundUser;

  final InvitedUser invitedUsers;

  const UserListItem({
    required this.foundUser,
    Key? key,
    required this.invitedUsers,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        title: Text(foundUser.user.username, style: const TextStyle(fontFamily: 'Quicksand', fontStyle: FontStyle.normal, fontWeight: FontWeight.w400)),
        value: foundUser.isInvited,
        controlAffinity: ListTileControlAffinity.trailing,
        secondary: CircleAvatar(
          backgroundImage: Image.network(foundUser.user.profilePic).image,
        ),
        onChanged: (bool? value) {
          foundUser.isInvited = !foundUser.isInvited;

          if (foundUser.isInvited) {
            invitedUsers.addUserToList(foundUser.user);
          } else {
            invitedUsers.removeUserFromList(foundUser.user);
          }
        },
      ),
    );
  }
}
