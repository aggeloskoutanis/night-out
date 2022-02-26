import 'package:awesome_icons/awesome_icons.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/widgets/user_list_item.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../provider/models/user.dart';

// Dummy data to add as pictures

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class EventCard extends StatelessWidget {
  final String? eventName;
  final String? eventDate;
  final List<dynamic>? pictures;
  final List<dynamic>? invitedUsers;
  final String? eventLocation;

  const EventCard({required this.eventName, required this.eventDate, required this.eventLocation, required this.pictures, required this.invitedUsers, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final List<Widget> imageSliders = imgList
        .map(
          (item) => Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Image.network(item, fit: BoxFit.fill),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            elevation: 5,
            margin: const EdgeInsets.all(0),
          ),
        )
        .toList();

    return Slidable(
        key: UniqueKey(),
        startActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.event_note_outlined,
                          color: Colors.white70,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: Text(
                            '$eventName',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(children: [
                      const Icon(
                        Icons.date_range_outlined,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(child: Text(formatter.format(DateTime.parse(eventDate!)), style: const TextStyle(color: Colors.white)))
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(children: [
                      const Icon(
                        FontAwesomeIcons.mapMarked,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(child: Text('$eventLocation', style: const TextStyle(color: Colors.white)))
                    ]),
                  ),
                  GestureDetector(
                    onTap: () => _showInvitedUsers(context),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(children: [
                        Badge(
                          padding: const EdgeInsets.all(3),
                          shape: BadgeShape.circle,
                          borderRadius: BorderRadius.circular(10),
                          position: BadgePosition.topEnd(top: -5, end: -3),
                          animationType: BadgeAnimationType.slide,
                          badgeContent: Text(
                            invitedUsers?.length.toString() as String,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          'Who\'s coming',
                          style: TextStyle(color: Colors.white),
                        )
                      ]),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        child: Row(children: [
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.white70), borderRadius: const BorderRadius.all(Radius.circular(10))),
            width: 30,
            height: 200,
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.white70,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.blueGrey,
              child: SizedBox(
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [...imageSliders],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]));
  }

  void _showInvitedUsers(BuildContext context) {
    List<UserListItems> _invitedUserDetails = [];

    showDialog(
        context: context,
        builder: (_) {
          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('users').get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final users = snapshot.data?.docs;

                _invitedUserDetails.addAll(_getInvitedUsers(invitedUsers, users!));

                return AlertDialog(
                  title: const Text('Invited Users'),
                  content: _invitedUserDetails.isEmpty
                      ? const SizedBox(
                          height: 200,
                          width: 100,
                          child: Center(
                            child: Text('No one is invited =('),
                          ),
                        )
                      : SizedBox(
                          height: 200,
                          width: 100,
                          child: ListView(
                            shrinkWrap: true,
                            children: [..._invitedUserDetails],
                          ),
                        ),
                );
              }
            },
          );
        });
  }

  List<UserListItems> _getInvitedUsers(invitedUsers, List<QueryDocumentSnapshot> usersFromDb) {
    List<UserListItems> _invitedUserDetails = [];
    for (var invitedUser in invitedUsers) {
      final queryDoc = usersFromDb.firstWhereOrNull((element) => element.id == invitedUser);
      if (queryDoc != null) {
        _invitedUserDetails
            .add(UserListItems(user: UserDetails(username: queryDoc['user_name'] as String, email: queryDoc['email'] as String, id: queryDoc.id, profilePic: queryDoc['prof_pic'] as String)));
      }
    }

    return _invitedUserDetails;
  }
}
