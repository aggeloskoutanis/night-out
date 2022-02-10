import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../widgets/profile_pic_picker.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  String? email;
  String? password;
  var _userImageFile;
  void _pickedImage(File image) {
    _userImageFile = image;
  }

  final _passwordController = TextEditingController();
  void _switchMode() {
    if (AuthMode.Login == _authMode) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An error has occurred!'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text('Okay!'))
              ],
            ));
  }

  void _submit() async {
    // Validate returns true if the form is valid, or false otherwise.

    if (_userImageFile == null && AuthMode != AuthMode.Login) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a profile picture.')),
      );
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential authResult;
        if (_authMode == AuthMode.Login) {
          // log user in
          authResult = await _auth.signInWithEmailAndPassword(
              email: email!, password: password!);
        } else {
          // Sign user up

          authResult = await _auth.createUserWithEmailAndPassword(
              email: email!, password: password!);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Processing Data')),
        );

        FocusScope.of(context).unfocus();
      } on FirebaseAuthException catch (e) {
        _showErrorDialog(e.message!);
      } catch (error) {
        const errorMessage = 'Could not authenticate you. Please try later.';
        _showErrorDialog(errorMessage);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            // Add TextFormFields and ElevatedButton here.
            if (_authMode == AuthMode.Login)
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * .5,
                child: Center(child: Image.asset('assets/drink.png')
                    // Text(
                    //   "Night Out",
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.bold, fontSize: 30),
                    // ),
                    ),
              ),
            if (_authMode == AuthMode.Signup) ProfilePicPicker(_pickedImage),

            SizedBox(
              height: 40,
            ),
            TextFormField(
              onSaved: (value) {
                email = value!;
              },
              style: TextStyle(color: Colors.white70),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.white70,
                  ),
                  hintText: "Enter username",
                  hintStyle: TextStyle(color: Colors.white70),
                  // errorText: "Invalid input",
                  label: Text(
                    "Username",
                    style: TextStyle(color: Colors.white70),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                      ),
                      borderRadius: BorderRadius.circular(8.0)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                      ),
                      borderRadius: BorderRadius.circular(8.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 2))),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              onSaved: (value) {
                email = value!;
              },
              style: TextStyle(color: Colors.white70),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.white70,
                  ),
                  hintText: "Enter e-mail",
                  hintStyle: TextStyle(color: Colors.white70),
                  // errorText: "Invalid input",
                  label: Text(
                    "E-mail",
                    style: TextStyle(color: Colors.white70),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                      ),
                      borderRadius: BorderRadius.circular(8.0)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                      ),
                      borderRadius: BorderRadius.circular(8.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 2))),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              style: TextStyle(color: Colors.white70),
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.white70,
                  ),
                  hintText: "Enter password",
                  hintStyle: TextStyle(color: Colors.white70),
                  // errorText: "Invalid password",
                  label: Text(
                    "Password",
                    style: TextStyle(color: Colors.white70),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                      ),
                      borderRadius: BorderRadius.circular(8.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 2),
                      borderRadius: BorderRadius.circular(8.0)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                      ),
                      borderRadius: BorderRadius.circular(8.0))),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (value) {
                password = value!;
              },
            ),
            if (_authMode == AuthMode.Signup)
              SizedBox(
                height: 10,
              ),
            if (_authMode == AuthMode.Signup)
              TextFormField(
                style: TextStyle(color: Colors.white70),
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.white70,
                    ),
                    hintText: "Confirm password",
                    hintStyle: TextStyle(color: Colors.white70),
                    label: Text(
                      "Confirm Password",
                      style: TextStyle(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal, width: 2),
                        borderRadius: BorderRadius.circular(8.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey,
                        ),
                        borderRadius: BorderRadius.circular(8.0)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey,
                        ),
                        borderRadius: BorderRadius.circular(8.0))),
                // The validator receives the text that the user has entered.
                validator: _authMode == AuthMode.Signup
                    ? (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match!';
                        }
                      }
                    : null,
                onSaved: (value) {
                  password = value!;
                },
              ),
            SizedBox(
              height: 40,
            ),

            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blueGrey,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10)),
                      onPressed: _submit,
                      child: Text(
                          _authMode == AuthMode.Login ? 'Login' : 'Sign up'),
                    ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
                    onPressed: _switchMode,
                    child: Text(
                        _authMode == AuthMode.Login ? 'Sign up' : 'Go back'),
                  ),
                ]),
          ],
        ),
      ),
    ));
  }
}
