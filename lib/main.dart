import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/provider/models/invited_user.dart';
import 'package:flutter_firebase_login/screens/auth_screen.dart';
import 'package:flutter_firebase_login/screens/event_creation_screen.dart';
import 'package:flutter_firebase_login/screens/event_screen.dart';
import 'package:flutter_firebase_login/screens/events_overview.dart';
import 'package:flutter_firebase_login/widgets/event_card.dart';
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
          ChangeNotifierProvider(create: (_) => InvitedUser()),
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProxyProvider<Auth, Events>(
              create: (context) => Events.defaultConstructor(),
              update: (context, auth, previousInstanceOfEvents) => Events(auth.token, auth.userId, previousInstanceOfEvents == null ? [] : previousInstanceOfEvents.events))
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Counter App Example',
            theme: ThemeData(
              fontFamily: 'Quicksand',
            ),
            debugShowCheckedModeBanner: false,
            // home: auth.isAuth ? EventsOverviewScreen() : AuthScreen(),
            home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, userSnapshot) {
                  if (userSnapshot.hasData) {
                    return const EventsOverviewScreen();
                  }
                  return const AuthScreen();
                }),
            routes: {
              AuthScreen.routeName: (ctx) => const AuthScreen(),
              EventCreationScreen.routeName: (ctx) => const EventCreationScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == EventScreen.routeName) {
                // EventCard event = settings.arguments as EventCard;
                List<dynamic> args = settings.arguments as List<dynamic>;

                return MaterialPageRoute(
                    builder: (_) => EventScreen(
                          event: args[1] as EventCard,
                          callback: args[0],
                        ));
              }
            },
          ),
        ));
  }
}
