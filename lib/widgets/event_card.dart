import 'package:flutter/material.dart';

import 'icon_text.dart';

// Dummy data to add as pictures

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class EventCard extends StatelessWidget {
  const EventCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList
        .map(
          (item) => Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Image.network(item, fit: BoxFit.fill),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            elevation: 5,
            margin: const EdgeInsets.all(0),
          ),
        )
        .toList();

    return Expanded(
      flex: 1,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.blueGrey,
        child: SizedBox(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [...imageSliders],
                  ),
                ),
              ),
              Container(
                color: Colors.grey,
                height: 200 * 0.15,
                child: Row(
                  children: const [
                    IconWithText(
                        icon: Icon(
                          Icons.person_outline,
                          size: 20,
                        ),
                        textName: Text(
                          "2",
                          style: TextStyle(fontSize: 12),
                        )),
                    Spacer(),
                    IconWithText(
                      icon: Icon(
                        Icons.date_range,
                        size: 20,
                      ),
                      textName:
                          Text("22-02-2022", style: TextStyle(fontSize: 12)),
                    ),
                    Spacer(),
                    IconWithText(
                      icon: Icon(
                        Icons.location_pin,
                        size: 20,
                      ),
                      textName: Text("Athens, Greece",
                          style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
