import 'package:flutter/material.dart';

class AddressItem extends StatelessWidget {
  final String streetDetails;

  const AddressItem({required this.streetDetails, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      child: ListTile(
        leading: const Icon(Icons.location_pin),
        title: Text(streetDetails, style: const TextStyle(fontSize: 10)),
      ),
    );
  }
}
