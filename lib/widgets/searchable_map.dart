import 'package:awesome_icons/awesome_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/provider/models/event.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/event_controller.dart';
import '../controllers/invited_users_controller.dart';
import '../provider/models/invited_user.dart';
import 'address_item.dart';

class SearchableMap extends StatefulWidget {
  String newEventName;
  String newEventDate;

  SearchableMap({required this.newEventDate, required this.newEventName, Key? key}) : super(key: key);

  @override
  _SearchableMapState createState() => _SearchableMapState();
}

class _SearchableMapState extends State<SearchableMap> {
  final ValueNotifier<String> addressToSearch = ValueNotifier<String>("");
  final ValueNotifier<LatLng> latlng = ValueNotifier<LatLng>(LatLng(37.967157990981946, 23.709239806050036));

  final MapController _controller = MapController();

  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Stack(
      children: [
        ValueListenableBuilder<LatLng>(
            builder: (ctx, latlng, child) {
              return FlutterMap(
                  mapController: _controller,
                  options: MapOptions(
                    controller: _controller,
                    center: latlng,
                    zoom: 13.0,
                    onTap: (tapPosition, tapLatLon) async {},
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                      attributionBuilder: (_) {
                        return const Text("© OpenStreetMap contributors");
                      },
                    ),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 30.0,
                          height: 30.0,
                          point: latlng,
                          builder: (ctx) => const Icon(FontAwesomeIcons.mapPin, color: Colors.teal),
                        )
                      ],
                    ),
                  ]);
            },
            valueListenable: latlng),
        SearchStack(addressToSearch: addressToSearch, controller: _controller, latlng: latlng),
        ValueListenableBuilder<String>(
          builder: (ctx, address, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton.extended(
                  heroTag: "submitEvent",
                  onPressed: () async {
                    if (widget.newEventName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid event name')));
                      return;
                    }

                    // final invitedUsers = Provider.of<InvitedUser>(context, listen: false).invitedUsers;

                    final InviteUsersController inviteUsersController = Get.put(InviteUsersController());

                    if (inviteUsersController.invitedUsers.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invite people!')));
                      return;
                    }

                    if (DateTime.parse(widget.newEventDate).year < DateTime.now().year) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please pick a date for the event to take place')));
                      return;
                    }

                    registerEvent(widget.newEventName, widget.newEventDate, inviteUsersController.invitedUsers, latlng.value, userId!);
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.black54,
                  label: const Text('Create event'),
                  icon: const Icon(Icons.event),
                ),
              ),
            );
          },
          valueListenable: addressToSearch,
        )
      ],
    );
  }

  void registerEvent(String name, String date, List<InvitedUserItem> invitedUsers, LatLng latlng, String loggedInUser) {
    FirebaseFirestore.instance.collection('events').add({
      'event_location': latlng.latitude.toString() + ', ' + latlng.longitude.toString(),
      'event_address': addressToSearch.value,
      'event_name': name,
      'event_date': date,
      'event_creator': loggedInUser,
      'images': [],
      'invited_users': FieldValue.arrayUnion(invitedUsers
          .map(
            (value) => value.user.id,
          )
          .toList())
    }).then((docRef) {
      Event newEventToAdd = Event(docRef.id, date, [], [], name, addressToSearch.value, loggedInUser, latlng.latitude.toString() + ', ' + latlng.longitude.toString());

      // Provider.of<Events>(context, listen: false).addEvent(newEventToAdd);

      EventController eventController = Get.put(EventController());
      newEventToAdd.setInvitedUsers(invitedUsers.map((e) => e.user.id).toList());
      eventController.addEvent(newEventToAdd);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event created successfully!')));
    });
  }
}

class SearchStack extends StatefulWidget {
  final ValueNotifier<String> addressToSearch;
  final MapController controller;
  final ValueNotifier<LatLng> latlng;

  const SearchStack({required this.addressToSearch, required this.controller, required this.latlng, Key? key}) : super(key: key);

  @override
  _SearchStackState createState() => _SearchStackState();
}

class _SearchStackState extends State<SearchStack> {
  Widget? _popInWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton.small(
                  heroTag: "searchAddress",
                  backgroundColor: Colors.black54,
                  child: const Icon(FontAwesomeIcons.locationArrow, size: 16),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_popInWidget == null) {
                      _popInWidget = AnimatedSearch(
                        addressToSearch: widget.addressToSearch,
                        latlng: widget.latlng,
                        controller: widget.controller,
                      );
                    } else {
                      _popInWidget = null;
                    }

                    setState(() {});
                  })),
        ),
        if (_popInWidget != null) _popInWidget!
      ],
    );
  }
}

class AnimatedSearch extends StatefulWidget {
  final ValueNotifier<LatLng> latlng;
  final MapController controller;
  final ValueNotifier<String> addressToSearch;

  const AnimatedSearch({required this.addressToSearch, Key? key, required this.latlng, required this.controller}) : super(key: key);

  @override
  _AnimatedSearchState createState() => _AnimatedSearchState();
}

class _AnimatedSearchState extends State<AnimatedSearch> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.rectangle, color: Colors.black87.withOpacity(0.85), borderRadius: const BorderRadius.all(Radius.circular(8))),
          height: 300,
          width: 200,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (fieldValue) {
                    widget.addressToSearch.value = fieldValue;
                  },
                  style: const TextStyle(color: Colors.white70),
                  decoration: InputDecoration(
                      hintText: "Enter an address",
                      hintStyle: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w400),
                      // errorText: "Invalid input",
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
                      focusedBorder: const OutlineInputBorder(gapPadding: 3, borderSide: BorderSide(color: Colors.teal, width: 1.5))),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ValueListenableBuilder<String>(
                        builder: (ctx, address, child) {
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(4),
                            child: FutureBuilder<List<Address>>(
                              future: Geocoder.local.findAddressesFromQuery(address),
                              builder: (ctx, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator(
                                    color: Colors.teal,
                                  );
                                } else {
                                  List<Address>? address = snapshot.data ?? [];
                                  return ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: address.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        child: AddressItem(streetDetails: address[index].addressLine!),
                                        onTap: () {
                                          widget.latlng.value = LatLng(address[index].coordinates.latitude!, address[index].coordinates.longitude!);
                                          widget.controller.move(LatLng(address[index].coordinates.latitude!, address[index].coordinates.longitude!), 13);
                                        },
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          );
                        },
                        valueListenable: widget.addressToSearch,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
