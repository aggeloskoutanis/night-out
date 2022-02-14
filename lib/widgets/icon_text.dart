import 'package:flutter/material.dart';

class IconWithText extends StatelessWidget {
  final Text textName;
  final Icon icon;
  const IconWithText({required this.icon, required this.textName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [icon, textName],
      ),
    );
  }
}
