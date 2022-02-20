import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../provider/models/user.dart';
import '../provider/models/invited_user.dart';
import '../widgets/searchable_map.dart';
import '../widgets/user_list.dart';
import '../widgets/user_list_item.dart';

class EventCreationForm extends StatefulWidget {
  const EventCreationForm({Key? key}) : super(key: key);

  @override
  _EventCreationFormState createState() => _EventCreationFormState();
}

class _EventCreationFormState extends State<EventCreationForm> {
  final _formKey = GlobalKey<FormState>();

  List<UserDetails>? userEmails = [];

  // MapController? mapController;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<EventDetails> eventDetails = ValueNotifier<EventDetails>(EventDetails('', DateTime(DateTime.now().year - 1)));
    final peopleToInvite = Provider.of<InvitedUser>(context, listen: false);

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
                            onChanged: (value) {
                              eventDetails.value.eventName = value;
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
                                          borderRadius: const BorderRadius.all(Radius.circular(8))),
                                      // margin: EdgeInsets.all(4),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: const [
                                        Icon(
                                          Icons.search_off,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'Search users',
                                          style: TextStyle(color: Colors.white70),
                                        )
                                      ]),
                                    ),
                                    onTap: () {
                                      FocusManager.instance.primaryFocus?.unfocus();
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
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle, color: Colors.white.withOpacity(.1), border: Border.all(color: Colors.blueGrey), borderRadius: BorderRadius.all(Radius.circular(8))),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: const [
                                    Icon(
                                      Icons.date_range,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Pick date',
                                      style: TextStyle(color: Colors.white70),
                                    )
                                  ]),
                                ),
                                onTap: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  final DateTime now = DateTime.now();

                                  eventDetails.value.eventDate = await showDatePicker(
                                          context: context,
                                          initialDate: now,
                                          firstDate: DateTime(now.year, now.month, now.day),
                                          lastDate: DateTime(now.year + 2),
                                          builder: (context, child) {
                                            return Theme(
                                              data: ThemeData.dark().copyWith(
                                                  colorScheme: const ColorScheme.dark(
                                                      onPrimary: Colors.black, // selected text color
                                                      onSurface: Colors.amberAccent, // default text color
                                                      primary: Colors.amberAccent // circle color
                                                      ),
                                                  dialogBackgroundColor: Colors.black54,
                                                  textButtonTheme: TextButtonThemeData(
                                                      style: TextButton.styleFrom(
                                                          textStyle: const TextStyle(color: Colors.amber, fontWeight: FontWeight.normal, fontSize: 12, fontFamily: 'Quicksand'),
                                                          primary: Colors.amber, // color of button's letters
                                                          backgroundColor: Colors.black54, // Background color
                                                          shape: RoundedRectangleBorder(
                                                              side: const BorderSide(color: Colors.transparent, width: 1, style: BorderStyle.solid), borderRadius: BorderRadius.circular(50))))),
                                              child: child!,
                                            );
                                          }) ??
                                      DateTime(2017);
                                },
                              )),
                              Expanded(
                                  child: GestureDetector(
                                child: Container(
                                  height: 50,
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle, color: Colors.white.withOpacity(.1), border: Border.all(color: Colors.blueGrey), borderRadius: BorderRadius.all(Radius.circular(8))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: const [
                                      Icon(
                                        Icons.list_alt_outlined,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        'List users',
                                        style: TextStyle(color: Colors.white70),
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
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
                                              padding: const EdgeInsets.all(8.0),
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
                              child: ValueListenableBuilder<EventDetails>(
                            builder: (context, event, child) => SearchableMap(
                              eventDetails: event,
                            ),
                            valueListenable: eventDetails,
                          )),
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
}

class EventDetails {
  String eventName;
  DateTime eventDate;

  EventDetails(this.eventName, this.eventDate);
}
