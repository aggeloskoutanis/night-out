import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.35),
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                  prefixIcon: GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.supervised_user_circle_sharp,
                      color: Colors.white70,
                    ),
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
                      borderSide: BorderSide(color: Colors.teal, width: 2))),
              // The validator receives
              // onChanged: (selectedValue) {
              //   if (peopleToInvite!.length < (userEmails as List).length) {
              //     UserDetails? foundUser = userEmails?.firstWhereOrNull(
              //         (element) => element.username == selectedValue);
              //
              //     UserDetails? alreadyInList = peopleToInvite?.firstWhereOrNull(
              //         (element) => foundUser?.id == element.id);
              //
              //     if (foundUser != null && alreadyInList == null) {
              //       peopleToInvite?.add(foundUser);
              //
              //       peopleToInviteStream.sink.add(peopleToInvite!);
              //
              //       // print('found!');
              //     }
              //   }
              // },
            ),
          ],
        ),
      ),
    );
  }
}

class UserListItem extends StatelessWidget {
  const UserListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Aggelos'),
      ),
    );
  }
}
