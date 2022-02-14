import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import './../provider/models/user.dart';
import '../provider/models/invited_user.dart';
import '../widgets/user_list.dart';
import '../widgets/user_list_item.dart';

class EventCreationForm extends StatefulWidget {
  const EventCreationForm({Key? key}) : super(key: key);

  @override
  _EventCreationFormState createState() => _EventCreationFormState();
}

class _EventCreationFormState extends State<EventCreationForm> {
  final _formKey = GlobalKey<FormState>();
  String? eventName;

  List<UserDetails>? userEmails = [];

  double lat = 51.5;
  double lon = -0.09;

  int streamCounter = -1;

  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final peopleToInvite = Provider.of<InvitedUser>(context);

    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('users').get(),
        builder: (ctx, dataSnapshot) {
          if (ConnectionState.waiting == dataSnapshot.connectionState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            );
          } else if (dataSnapshot.connectionState == ConnectionState.done) {
            final fetchedData = dataSnapshot.data?.docs;

            fetchedData?.forEach((element) {
              userEmails?.add(UserDetails(id: element.id, username: element['user_name'] as String, email: element['email'] as String, profilePic: element['prof_pic'] as String));
            });

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      const Color.fromRGBO(1, 1, 1, 1).withOpacity(1),
                      const Color.fromRGBO(1, 25, 38, 1).withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0, 1]),
              ),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextFormField(
                            onSaved: (value) {
                              eventName = value!;
                            },
                            style: const TextStyle(color: Colors.white70),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.drive_file_rename_outline,
                                  color: Colors.white70,
                                ),
                                hintText: "Enter an event name",
                                hintStyle: const TextStyle(color: Colors.white70),
                                // errorText: "Invalid input",
                                label: const Text(
                                  "Event name",
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
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: Colors.white.withOpacity(.1),
                                          border: Border.all(color: Colors.blueGrey),
                                          borderRadius: BorderRadius.all(Radius.circular(8))),
                                      // margin: EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.search_off,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.black54,
                                          isDismissible: true,
                                          enableDrag: true,
                                          context: context,
                                          builder: (ctx) {
                                            return UserList(userEmails: userEmails, peopleToInvite: peopleToInvite);
                                          });
                                    }),
                              ),
                              Expanded(
                                  child: GestureDetector(
                                child: Container(
                                  height: 50,
                                  margin: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle, color: Colors.white.withOpacity(.1), border: Border.all(color: Colors.blueGrey), borderRadius: BorderRadius.all(Radius.circular(8))),
                                  child: const Icon(
                                    Icons.list_alt_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.black87,
                                      isDismissible: true,
                                      enableDrag: true,
                                      context: context,
                                      builder: (ctx) {
                                        return Consumer<InvitedUser>(
                                          builder: (context, invitedUsers, child) => SingleChildScrollView(
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              height: MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height * 0.26),
                                              child: ListView.builder(
                                                itemCount: invitedUsers.invitedUsers.length,
                                                shrinkWrap: true,
                                                itemBuilder: (BuildContext context, int index) {
                                                  UserDetails user = invitedUsers.invitedUsers.values.toList().elementAt(index).user;
                                                  return UserListItems(
                                                    user: user,
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                              ))
                            ],
                          ),
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle, color: Colors.white.withOpacity(1), border: Border.all(color: Colors.blueGrey), borderRadius: BorderRadius.all(Radius.circular(8))),
                            child: FlutterMap(
                                options: MapOptions(
                                  center: LatLng(51.5, -0.09),
                                  zoom: 13.0,
                                ),
                                layers: [
                                  TileLayerOptions(
                                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                    subdomains: ['a', 'b', 'c'],
                                    attributionBuilder: (_) {
                                      return Text("© OpenStreetMap contributors");
                                    },
                                  ),
                                  MarkerLayerOptions(
                                    markers: [
                                      Marker(
                                        width: 80.0,
                                        height: 80.0,
                                        point: LatLng(51.5, -0.09),
                                        builder: (ctx) => Container(
                                          child: FlutterLogo(),
                                        ),
                                      )
                                    ],
                                  ),
                                ]),
                          ))
                        ],
                      ),
                    ),
                  )),
            );
          } else {
            return const Text('Loading');
          }
        });
  }

  Future<List<Location>> findAddress() async {
    List<Location> location = await locationFromAddress(_controller.text);

    return location;
  }
}