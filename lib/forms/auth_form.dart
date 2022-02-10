import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../widgets/profile_pic_picker.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _auth = FirebaseAuth.instance;
  final _fbstorage = FirebaseStorage.instance;

  get user => _auth.currentUser;

  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  AuthMode _authMode = AuthMode.login;
  String? email;
  String? username;
  String? password;
  String? imageURL;

  File? _userImageFile;
  void _pickedImage(File image) {
    _userImageFile = image;
  }

  final _passwordController = TextEditingController();

  Future<String?> _uploadProfilePicToFb(
      UserCredential authResult, File file) async {
    String uid = authResult.user?.uid ?? username!;

    Reference ref = _fbstorage.ref().child("images").child(uid + '.jpg');
    await ref.putFile(file);

    return ref.getDownloadURL();
  }

  void _switchMode() {
    if (AuthMode.login == _authMode) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  // void _showErrorDialog(String message) {
  //   showDialog(
  //       context: context,
  //       builder: (ctx) => AlertDialog(
  //             title: Text('An error has occurred!'),
  //             content: Text(message),
  //             actions: [
  //               TextButton(
  //                   onPressed: () => Navigator.of(ctx).pop(),
  //                   child: Text('Okay!'))
  //             ],
  //           ));
  // }

  void _submit() async {
    // Validate returns true if the form is valid, or false otherwise.

    if (_userImageFile == null && _authMode != AuthMode.login) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a profile picture.')),
      );

      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      setState(() {
        _isLoading = true;
      });

      try {
        if (_authMode == AuthMode.login) {
          // log user in
          await _auth.signInWithEmailAndPassword(
              email: email!, password: password!);
        } else {
          // Sign user up

          final UserCredential _authResult =
              await _auth.createUserWithEmailAndPassword(
                  email: email!, password: password!);

          await _uploadProfilePicToFb(_authResult, _userImageFile!)
              .then((imgURL) {
            if (imgURL == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Failed to upload image.Please try again.')),
              );
            } else {
              imageURL = imgURL;
            }
          });

          await FirebaseFirestore.instance.collection('users').add(
              {'user_name': username, 'email': email, 'prof_pic': imageURL});
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Processing Data')),
        );

        FocusScope.of(context).unfocus();
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message!)),
        );
      } catch (error) {
        // const errorMessage = 'Could not authenticate you. Please try later.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            // Add TextFormFields and ElevatedButton here.
            if (_authMode == AuthMode.login)
              SizedBox(
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
            if (_authMode == AuthMode.signup) ProfilePicPicker(_pickedImage),

            const SizedBox(
              height: 40,
            ),
            TextFormField(
              onSaved: (value) {
                username = value!;
              },
              style: const TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.white70,
                  ),
                  hintText: "Enter username",
                  hintStyle: const TextStyle(color: Colors.white70),
                  // errorText: "Invalid input",
                  label: const Text(
                    "Username",
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
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              onSaved: (value) {
                email = value!;
              },
              style: const TextStyle(color: Colors.white70),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.white70,
                  ),
                  hintText: "Enter e-mail",
                  hintStyle: const TextStyle(color: Colors.white70),
                  // errorText: "Invalid input",
                  label: const Text(
                    "E-mail",
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
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              style: const TextStyle(color: Colors.white70),
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.white70,
                  ),
                  hintText: "Enter password",
                  hintStyle: const TextStyle(color: Colors.white70),
                  // errorText: "Invalid password",
                  label: const Text(
                    "Password",
                    style: TextStyle(color: Colors.white70),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blueGrey,
                      ),
                      borderRadius: BorderRadius.circular(8.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.teal, width: 2),
                      borderRadius: BorderRadius.circular(8.0)),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(
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
            if (_authMode == AuthMode.signup)
              const SizedBox(
                height: 10,
              ),
            if (_authMode == AuthMode.signup)
              TextFormField(
                style: const TextStyle(color: Colors.white70),
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.white70,
                    ),
                    hintText: "Confirm password",
                    hintStyle: const TextStyle(color: Colors.white70),
                    label: const Text(
                      "Confirm Password",
                      style: TextStyle(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.teal, width: 2),
                        borderRadius: BorderRadius.circular(8.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blueGrey,
                        ),
                        borderRadius: BorderRadius.circular(8.0)),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blueGrey,
                        ),
                        borderRadius: BorderRadius.circular(8.0))),
                // The validator receives the text that the user has entered.
                validator: _authMode == AuthMode.signup
                    ? (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match!';
                        }
                        return null;
                      }
                    : null,
                onSaved: (value) {
                  password = value!;
                },
              ),
            const SizedBox(
              height: 40,
            ),

            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blueGrey,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10)),
                      onPressed: _submit,
                      child: Text(
                          _authMode == AuthMode.login ? 'Login' : 'Sign up'),
                    ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10)),
                    onPressed: _switchMode,
                    child: Text(
                        _authMode == AuthMode.login ? 'Sign up' : 'Go back'),
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
