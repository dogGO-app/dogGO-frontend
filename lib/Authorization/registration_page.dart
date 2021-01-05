import 'dart:convert';

import 'package:doggo_frontend/OAuth2/oauth2_client.dart';
import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart';

import '../Custom/doggo_toast.dart';

class RegistrationPageState extends State<RegistrationPage> {
  Client client;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};
  final signUpUrl =
      'https://doggo-service.herokuapp.com/api/auth/users/sign-up';
  final authority = 'doggo-service.herokuapp.com';
  final mailPath = '/api/auth/users/send-activation-mail';

  final _passwordRegexp = RegExp(
      r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,128}$",
      caseSensitive: true,
      multiLine: false);
  final _emailRegexp = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
      caseSensitive: false, multiLine: false);
  String _credentialsVerificationMessage = '';
  bool _incorrectCredentials = true;

  @override
  void initState() {
    super.initState();
  }

  Future addUser() async {
    client ??= await OAuth2Client().getClientCredentialsGrant();
    var body = jsonEncode({
      'email': '${emailController.text}',
      'password': '${passwordController.text}'
    });

    final signUpResponse =
        await client.post(signUpUrl, headers: headers, body: body);
    if (signUpResponse.statusCode == 201) {
      DoggoToast.of(context).showToast('Registration completed. Welcome!');
      Navigator.of(context).pop();
    } else if (signUpResponse.statusCode == 400) {
      DoggoToast.of(context).showToast('You have to provide a valid email!');
    } else if (signUpResponse.statusCode == 409) {
      DoggoToast.of(context)
          .showToast('Account with given email already exists!');
    } else {
      DoggoToast.of(context).showToast('Failed to create user.');
      throw Exception(
          'Failed to create user.\nCode: ${signUpResponse.statusCode}');
    }
  }

  void _verifyCredentials(
      String email, String password, String repeatPassword) {
    if (email.isEmpty || !_emailRegexp.hasMatch(email)) {
      setState(() {
        _incorrectCredentials = true;
        _credentialsVerificationMessage =
            'You have to provide a valid email address.';
      });
    } else if (password.isEmpty || !_passwordRegexp.hasMatch(password)) {
      setState(() {
        _incorrectCredentials = true;
        _credentialsVerificationMessage =
            'Password must contain at least 1 small letter, 1 capital letter and 1 number.';
      });
    } else if (password.isEmpty || password.length < 8) {
      setState(() {
        _incorrectCredentials = true;
        _credentialsVerificationMessage =
            'Password must be at least 8 characters long.';
      });
    } else if (password != repeatPassword) {
      setState(() {
        _incorrectCredentials = true;
        _credentialsVerificationMessage = 'Passwords must match.';
      });
    } else {
      setState(() {
        _incorrectCredentials = false;
        _credentialsVerificationMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 30),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.orangeAccent,
                                blurRadius: 20,
                                offset: Offset(0, 10))
                          ]),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(),
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              onChanged: (email) {
                                _verifyCredentials(
                                    email,
                                    passwordController.text,
                                    repeatPasswordController.text);
                              },
                            ),
                          ),
                          Divider(color: Colors.grey),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              onChanged: (password) {
                                _verifyCredentials(emailController.text,
                                    password, repeatPasswordController.text);
                              },
                            ),
                          ),
                          Divider(color: Colors.grey),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: TextField(
                              controller: repeatPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Repeat password",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              onChanged: (repeatPassword) {
                                _verifyCredentials(emailController.text,
                                    passwordController.text, repeatPassword);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.1,
                        ),
                        Visibility(
                          child: Text(
                            _credentialsVerificationMessage,
                            style: TextStyle(color: Colors.red),
                          ),
                          maintainState: true,
                          visible: _incorrectCredentials,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 50.0,
                      child: MaterialButton(
                        disabledColor: Colors.grey,
                        onPressed: _incorrectCredentials
                            ? null
                            : () {
                                if (emailController.text.isEmpty)
                                  DoggoToast.of(context)
                                      .showToast('Email field must be filled!');
                                else if (passwordController.text.isEmpty ||
                                    repeatPasswordController.text.isEmpty)
                                  DoggoToast.of(context).showToast(
                                      'Both Password and Repeat password fields must be filled!');
                                else if (passwordController.text.length < 8)
                                  DoggoToast.of(context).showToast(
                                      'Password must be at least 8 characters long!');
                                else if (passwordController.text !=
                                    repeatPasswordController.text)
                                  DoggoToast.of(context)
                                      .showToast('Passwords must match!');
                                else
                                  addUser();
                              },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _incorrectCredentials
                                      ? Colors.grey
                                      : Colors.orangeAccent,
                                  _incorrectCredentials
                                      ? Colors.grey
                                      : Color.fromRGBO(200, 100, 20, .4)
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 300.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Sign Up",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
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

class RegistrationPage extends StatefulWidget {
  @override
  RegistrationPageState createState() => RegistrationPageState();
}
