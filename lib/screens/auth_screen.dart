import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/forms/auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static const routeName = 'auth-screen';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                children: const [
                  SizedBox(
                    height: 100,
                  ),
                  Flexible(child: AuthForm())
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
