import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/screens/auth_screen.dart';
import 'package:flutter_firebase_login/screens/events_overview.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

import './provider/events.dart';
import 'provider/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final int number = 1;

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProxyProvider<Auth, Events>(
              create: (context) => Events.defaultConstructor(),
              update: (context, auth, previousInstanceOfEvents) => Events(auth.token, auth.userId, previousInstanceOfEvents == null ? [] : previousInstanceOfEvents.events)),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => GetMaterialApp(
            title: 'Night out app',
            theme: ThemeData(
              fontFamily: 'Quicksand',
            ),
            debugShowCheckedModeBanner: false,
            // home: auth.isAuth ? EventsOverviewScreen() : AuthScreen(),
            home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, userSnapshot) {
                  if (userSnapshot.hasData) {
                    User? user = FirebaseAuth.instance.currentUser;

                    final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

                    return FutureBuilder<DocumentSnapshot>(
                        future: usersRef.doc(user!.uid).get(),
                        builder: (_, snapshot) {
                          if (snapshot.hasError) {
                            return const AuthScreen();
                          }

                          if (snapshot.connectionState == ConnectionState.done) {
                            return const EventsOverviewScreen();
                          }

                          return const CircularProgressIndicator();
                        });
                  }
                  return const AuthScreen();
                }),
          ),
        ));
  }
}
