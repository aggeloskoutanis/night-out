import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'address_item.dart';

class SearchableMap extends StatefulWidget {
  const SearchableMap({Key? key}) : super(key: key);

  @override
  _SearchableMapState createState() => _SearchableMapState();
}

class _SearchableMapState extends State<SearchableMap> {
  final ValueNotifier<String> addressToSearch = ValueNotifier<String>("");
  final ValueNotifier<LatLng> latlng = ValueNotifier<LatLng>(LatLng(37.967157990981946, 23.709239806050036));

  final MapController _controller = MapController();

  @override
  Widget build(BuildContext context) {
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
                          builder: (ctx) => Container(
                            child: const Icon(FontAwesomeIcons.mapPin, color: Colors.teal),
                          ),
                        )
                      ],
                    ),
                  ]);
            },
            valueListenable: latlng),
        SearchStack(addressToSearch: addressToSearch, controller: _controller, latlng: latlng)
      ],
    );
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
                  backgroundColor: Colors.black54,
                  child: const Icon(FontAwesomeIcons.locationArrow, size: 16),
                  onPressed: () {
                    if (_popInWidget == null) {
                      _popInWidget = AnimatedSearch(
                        addressToSearch: widget.addressToSearch,
                        latlng: widget.latlng,
                        controller: widget.controller,
                      );
                    } else {
                      _popInWidget = null;
                      widget.addressToSearch.value = "";
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
        decoration: BoxDecoration(shape: BoxShape.rectangle, color: Colors.black87.withOpacity(0.85), borderRadius: BorderRadius.all(Radius.circular(8))),
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
    );
  }
}
