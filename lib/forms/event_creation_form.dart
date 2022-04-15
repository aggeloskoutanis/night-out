import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import './../provider/models/user.dart';
import '../provider/models/event.dart';
import '../widgets/searchable_map.dart';
import '../widgets/user_list.dart';

class EventCreationForm extends StatefulWidget {
  final Event event;
  const EventCreationForm({required this.event, Key? key}) : super(key: key);

  @override
  _EventCreationFormState createState() => _EventCreationFormState();
}

class _EventCreationFormState extends State<EventCreationForm> {
  final _formKey = GlobalKey<FormState>();

  List<UserDetails>? userEmails = [];

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.event.eventName = '';
    widget.event.eventDate = DateTime.now().toIso8601String();

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
                      widget.event.eventName = value;
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
                                  shape: BoxShape.rectangle, color: Colors.white.withOpacity(.1), border: Border.all(color: Colors.blueGrey), borderRadius: const BorderRadius.all(Radius.circular(8))),
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
                              // newEvent.invitedUsers = <String>[];
                              // newEvent.pictures = <Picture>[];
                              // eventController.addEvent(widget.event);
                              FocusManager.instance.primaryFocus?.unfocus();
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.black54,
                                  isDismissible: true,
                                  enableDrag: true,
                                  context: context,
                                  builder: (ctx) {
                                    return UserList(
                                      newEvent: widget.event,
                                    );
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

                          widget.event.eventDate = (await showDatePicker(
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
                                  DateTime(2017))
                              .toIso8601String();
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
                          // GetBuilder
                          showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.black87,
                              isDismissible: true,
                              enableDrag: true,
                              context: context,
                              builder: (ctx) {
                                // return SingleChildScrollView(
                                return Container();
                                //     padding: const EdgeInsets.all(8.0),
                                //     height: MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height * 0.26),
                                //     child: ListView.builder(
                                //       itemCount: invitedUsers.invitedUsers.length,
                                //       shrinkWrap: true,
                                //       itemBuilder: (BuildContext context, int index) {
                                //         UserDetails user = invitedUsers.invitedUsers.values.toList().elementAt(index).user;
                                //         return UserListItems(
                                //           user: user,
                                //         );
                                //       },
                                //     ),
                                //   ),
                                // );
                              });
                        },
                      ))
                    ],
                  ),
                  Expanded(
                    child: SearchableMap(
                      newEventDate: widget.event.eventDate,
                      newEventName: widget.event.eventName,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
