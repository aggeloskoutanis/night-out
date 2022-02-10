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
  String? event_name;
  List<UserDetails>? user_emails = [];
  List<UserDetails>? people_to_invite = [];
  double lat = 51.5;
  double lon = -0.09;

  final peopleToInviteStream = StreamController<List<UserDetails>>();
  int stream_counter = -1;

  TextEditingController _controller = TextEditingController();

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
          if (ConnectionState.waiting == dataSnapshot.connectionState)
            return Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            );
          else if (dataSnapshot.connectionState == ConnectionState.done) {
            final fetched_data = dataSnapshot.data?.docs;

            fetched_data?.forEach((element) {
              user_emails?.add(UserDetails(
                  id: element.id,
                  username: element['user_name'] as String,
                  email: element['email'] as String,
                  profile_pic: element['prof_pic'] as String));
            });

            return Container(
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
                            event_name = value!;
                          },
                          style: TextStyle(color: Colors.white70),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.drive_file_rename_outline,
                                color: Colors.white70,
                              ),
                              hintText: "Enter an event name",
                              hintStyle: TextStyle(color: Colors.white70),
                              // errorText: "Invalid input",
                              label: Text(
                                "Event name",
                                style: TextStyle(color: Colors.white70),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blueGrey,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blueGrey,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0)),
                              focusedBorder: OutlineInputBorder(
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
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          style: TextStyle(color: Colors.white70),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.supervised_user_circle_sharp,
                                color: Colors.white70,
                              ),
                              hintText: "Find users to invite",
                              hintStyle: TextStyle(color: Colors.white70),
                              // errorText: "Invalid input",
                              label: Text(
                                "Search user",
                                style: TextStyle(color: Colors.white70),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blueGrey,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blueGrey,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.teal, width: 2))),
                          // The validator receives
                          onChanged: (selectedValue) {
                            if (people_to_invite!.length <
                                (user_emails as List).length) {
                              UserDetails? found_user =
                                  user_emails?.firstWhereOrNull((element) =>
                                      element.username == selectedValue);

                              UserDetails? already_in_list = people_to_invite
                                  ?.firstWhereOrNull((element) =>
                                      found_user?.id == element.id);

                              if (found_user != null &&
                                  already_in_list == null) {
                                people_to_invite?.add(found_user);

                                peopleToInviteStream.sink
                                    .add(people_to_invite!);

                                print('found!');
                              }
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        StreamBuilder(
                            stream: peopleToInviteStream.stream,
                            builder: (ctx, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  snapshot.data == null)
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              else if (snapshot.data != null) {
                                List<UserDetails> selectedUsers =
                                    snapshot.data as List<UserDetails>;
                                return Container(
                                  padding: EdgeInsets.all(8.0),
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
                                            user_details: selectedUsers[index],
                                            user_list: people_to_invite,
                                            stream_sink:
                                                peopleToInviteStream.sink);
                                      }),
                                );
                              } else {
                                return Text('Nothing to Show');
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
            return Text('Loading');
          }
        });
  }

  Future<List<Location>> findAddress() async {
    List<Location> location = await locationFromAddress(_controller.text);

    return location;
  }
}
