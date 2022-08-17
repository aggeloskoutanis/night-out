import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/provider/models/user.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/event_controller.dart';
import '../controllers/invited_users_controller.dart';
import '../controllers/user_controller.dart';
import '../provider/models/event.dart';
import '../provider/models/invited_user.dart';

class UserList extends StatefulWidget {
  final Event newEvent;

  const UserList({
    Key? key,
    required this.newEvent,
  }) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final usersController = Get.put(UserController());
  final eventController = Get.put(EventController());
  final invitedUserController = Get.put(InviteUsersController());

  @override
  Widget build(BuildContext context) {
    return Container(
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
                          // onTap: () {},
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
                      invitedUserController.clearSearchList();

                      if (selectedValue == "") return;
                      // already invited users
                      List<InvitedUserItem> alreadyInvitedUsers = [];
                      if (invitedUserController.invitedUsers.isNotEmpty) {
                        for (var alreadyInv in invitedUserController.invitedUsers) {
                          InvitedUserItem user = InvitedUserItem(user: usersController.findUserById(alreadyInv.user.id), isInvited: alreadyInv.isInvited);
                          alreadyInvitedUsers.add(user);
                        }

                        (alreadyInvitedUsers.where((invitedUser) => invitedUser.user.username.contains(selectedValue)).toList().forEach((invitedUserItem) {
                          invitedUserController.insertSearchList(invitedUserItem.user, invitedUserItem.isInvited);
                        }));
                      }

                      List<UserDetails> foundUsers = usersController.searchUserByName(selectedValue);

                      // Remove any user from the search list that is already invited
                      foundUsers.removeWhere((foundUser) => invitedUserController.searchList.any((listedUser) => listedUser.user.username == foundUser.username));

                      // all users, minus the already invited ones
                      for (var foundUser in foundUsers) {
                        invitedUserController.insertSearchList(foundUser, false);
                      }
                    },
                  )),
              const SizedBox(
                height: 10,
              ),
              GetBuilder(
                init: invitedUserController,
                builder: (controller) => ListView.builder(
                    itemCount: invitedUserController.searchList.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, i) {
                      if (invitedUserController.searchList.isEmpty) {
                        return const Text('No one is invited yet!', style: TextStyle(color: Colors.white));
                      } else {
                        return Container(
                            color: Colors.transparent,
                            child: UserListItem(
                              invitedUserController: invitedUserController,
                              foundUser: invitedUserController.searchList[i],
                              // newEvent: (controller as EventController).events.firstWhere((event) => event == widget.newEvent)
                            ));
                      }
                    }),
              )
            ],
          ),
        ));
  }
}

class UserListItem extends StatefulWidget {
  final InvitedUserItem foundUser;
  // final Event newEvent;
  final InviteUsersController invitedUserController;

  const UserListItem({
    required this.invitedUserController,
    required this.foundUser,
    // required this.newEvent,
    Key? key,
  }) : super(key: key);

  @override
  State<UserListItem> createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        title: Text(widget.foundUser.user.username, style: const TextStyle(fontFamily: 'Quicksand', fontStyle: FontStyle.normal, fontWeight: FontWeight.w400)),
        value: widget.foundUser.isInvited,
        controlAffinity: ListTileControlAffinity.trailing,
        secondary: CircleAvatar(
          child: ClipOval(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(48),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget.foundUser.user.profilePic,
                progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          backgroundImage: null,
          // Image.network(user.profilePic).image,
        ),
        onChanged: (bool? value) {
          setState(() {
            widget.foundUser.isInvited = !widget.foundUser.isInvited;

            if (widget.foundUser.isInvited) {
              widget.invitedUserController.insertUserInList(widget.foundUser.user);
            } else {
              widget.invitedUserController.removeUserFromList(widget.foundUser.user);
            }
          });
        },
      ),
    );
  }
}
