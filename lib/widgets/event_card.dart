import 'package:awesome_icons/awesome_icons.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/screens/event_screen.dart';
import 'package:flutter_firebase_login/widgets/user_list_item.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../controllers/event_controller.dart';
import '../provider/models/event.dart';
import '../provider/models/user.dart';

final List<String> imgList = [];

class EventCard extends StatefulWidget {
  final Event event;

  const EventCard({required this.event, Key? key}) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _deleteFlag = false;
  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final List<Card>? imageSliders = widget.event.pictures
        ?.map(
          (item) => Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: SizedBox(
                width: MediaQuery.of(context).size.width - 30,
                child:
                    // Image.network(item, fit: BoxFit.cover)
                    CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: item.getImgURL,
                  progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            elevation: 5,
            margin: const EdgeInsets.all(0),
          ),
        )
        .toList();

    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '/event-screen', arguments: [widget]);
        Get.to(() => EventScreen(event: widget.event));
      },
      child: Slidable(
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
                      padding: const EdgeInsets.all(8.0),
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
                              widget.event.eventName,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        const Icon(
                          Icons.date_range_outlined,
                          color: Colors.white70,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(child: Text(formatter.format(DateTime.parse(widget.event.eventDate)), style: const TextStyle(color: Colors.white)))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        const Icon(
                          FontAwesomeIcons.mapMarked,
                          color: Colors.white70,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(widget.event.eventAddress ?? "No location picked", style: const TextStyle(color: Colors.white))
                      ]),
                    ),
                    GestureDetector(
                      onTap: () => _showInvitedUsers(context),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          Badge(
                            padding: const EdgeInsets.all(3),
                            shape: BadgeShape.circle,
                            borderRadius: BorderRadius.circular(10),
                            position: BadgePosition.topEnd(top: -5, end: -3),
                            animationType: BadgeAnimationType.slide,
                            badgeContent: Text(
                              widget.event.invitedUsers?.length.toString() as String,
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => deleteEvent(widget.event.id!, widget.event.pictures),
                        child: _deleteFlag
                            ? const CircularProgressIndicator()
                            : Container(
                                width: (MediaQuery.of(context).size.width / 2) - 30,
                                decoration: BoxDecoration(border: Border.all(color: Colors.redAccent), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                              ),
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
                  width: MediaQuery.of(context).size.width - 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [...imageSliders!],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ])),
    );
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

                _invitedUserDetails.addAll(_getInvitedUsers(widget.event.invitedUsers, users!));

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

  void deleteEvent(String eventId, List<dynamic>? pictures) async {
    FirebaseFirestore.instance.doc('events/$eventId').delete().then((value) async => {
          for (var i = 0; i < pictures!.length; i++) {await FirebaseStorage.instance.ref().child(pictures[i]).delete()}
        });

    final eventController = Get.put(EventController());
    eventController.removeEventById(eventId);
    // Provider.of<Events>(context).removeEvent(eventId);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event successfully deleted')));
  }
}
