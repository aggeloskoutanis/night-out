import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import './../provider/models/user.dart';
import '../widgets/user_item.dart';

class EventCreationForm extends StatefulWidget {
  const EventCreationForm({Key? key}) : super(key: key);

  @override
  _EventCreationFormState createState() => _EventCreationFormState();
}

class _EventCreationFormState extends State<EventCreationForm> {
  final _formKey = GlobalKey<FormState>();
  String? eventName;
  List<UserDetails>? userEmails = [];
  List<UserDetails>? peopleToInvite = [];
  double lat = 51.5;
  double lon = -0.09;

  final peopleToInviteStream = StreamController<List<UserDetails>>();
  int streamCounter = -1;

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    peopleToInviteStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              userEmails?.add(UserDetails(
                  id: element.id,
                  username: element['user_name'] as String,
                  email: element['email'] as String,
                  profilePic: element['prof_pic'] as String));
            });

            return SizedBox(
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
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.teal, width: 2))),
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
                        TextField(
                          style: const TextStyle(color: Colors.white70),
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.supervised_user_circle_sharp,
                                color: Colors.white70,
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
                                  borderSide: BorderSide(
                                      color: Colors.teal, width: 2))),
                          // The validator receives
                          onChanged: (selectedValue) {
                            if (peopleToInvite!.length <
                                (userEmails as List).length) {
                              UserDetails? foundUser =
                                  userEmails?.firstWhereOrNull((element) =>
                                      element.username == selectedValue);

                              UserDetails? alreadyInList =
                                  peopleToInvite?.firstWhereOrNull(
                                      (element) => foundUser?.id == element.id);

                              if (foundUser != null && alreadyInList == null) {
                                peopleToInvite?.add(foundUser);

                                peopleToInviteStream.sink.add(peopleToInvite!);

                                // print('found!');
                              }
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        StreamBuilder(
                            stream: peopleToInviteStream.stream,
                            builder: (ctx, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  snapshot.data == null) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.data != null) {
                                List<UserDetails> selectedUsers =
                                    snapshot.data as List<UserDetails>;
                                return Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                      borderRadius: BorderRadius.circular(8.00),
                                      color: Colors.white70),
                                  child: ListView.builder(
                                      itemCount: selectedUsers.length,
                                      shrinkWrap: true,
                                      itemBuilder: (ctx, index) {
                                        return UserItem(
                                            userDetails: selectedUsers[index],
                                            userList: peopleToInvite!,
                                            streamSink:
                                                peopleToInviteStream.sink);
                                      }),
                                );
                              } else {
                                return const Text('Nothing to Show');
                              }
                            }),

                        // TextFormField(
                        //   controller: _controller,
                        //   onChanged: (changed) {
                        //       _controller.text = changed;
                        //   },
                        //   style: TextStyle(color: Colors.white70),
                        //   keyboardType: TextInputType.emailAddress,
                        //   decoration: InputDecoration(
                        //       prefixIcon: Icon(
                        //         Icons.drive_file_rename_outline,
                        //         color: Colors.white70,
                        //       ),
                        //       hintText: "Enter an event name",
                        //       hintStyle: TextStyle(color: Colors.white70),
                        //       // errorText: "Invalid input",
                        //       label: Text(
                        //         "Event name",
                        //         style: TextStyle(color: Colors.white70),
                        //       ),
                        //       enabledBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             color: Colors.blueGrey,
                        //           ),
                        //           borderRadius: BorderRadius.circular(8.0)),
                        //       border: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             color: Colors.blueGrey,
                        //           ),
                        //           borderRadius: BorderRadius.circular(8.0)),
                        //       focusedBorder: OutlineInputBorder(
                        //           borderSide:
                        //               BorderSide(color: Colors.teal, width: 2))),
                        //   // The validator receives the text that the user has entered.
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Please enter some text';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // FutureBuilder(
                        //     future: findAddress(),
                        //     builder: (BuildContext context,
                        //         AsyncSnapshot<dynamic> snapshot) {
                        //       if (!snapshot.hasData ||
                        //           _controller.text.isNotEmpty)
                        //         return Center(
                        //           child: CircularProgressIndicator(
                        //             color: Colors.amber,
                        //           ),
                        //         );
                        //       else {
                        //         return Expanded(
                        //           child: Container(
                        //               child: ListView.builder(
                        //                   shrinkWrap: true,
                        //                   itemCount: snapshot.data.length,
                        //                   itemBuilder: (ctx, index) {
                        //                     return Text(
                        //                         '${snapshot.data[index].toString()}');
                        //                   })),
                        //         );
                        //       }
                        //     }),
                        // Text(lat.toString() + " " + lon.toString()),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Expanded(
                        //     child: FlutterMap(
                        //         options: MapOptions(
                        //           center: LatLng(51.5, -0.09),
                        //           zoom: 13.0,
                        //         ),
                        //         layers: [
                        //       TileLayerOptions(
                        //         urlTemplate:
                        //             "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        //         subdomains: ['a', 'b', 'c'],
                        //         attributionBuilder: (_) {
                        //           return Text("© OpenStreetMap contributors");
                        //         },
                        //       ),
                        //       MarkerLayerOptions(
                        //         markers: [
                        //           Marker(
                        //             width: 80.0,
                        //             height: 80.0,
                        //             point: LatLng(51.5, -0.09),
                        //             builder: (ctx) => Container(
                        //               child: FlutterLogo(),
                        //             ),
                        //           )
                        //         ],
                        //       ),
                        //     ]))
                      ],
                    ),
                  ),
                ));
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
