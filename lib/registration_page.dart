import 'dart:convert';

import 'package:doggo_frontend/OAuth2/oauth2_client.dart';
import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

import 'Custom/doggo_toast.dart';

class RegistrationPageState extends State<RegistrationPage> {
  oauth2.Client client;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  final signUpUrl = 'https://doggo-service.herokuapp.com/api/auth/user/sign-up';

  final authority = 'doggo-service.herokuapp.com';
  final mailPath = '/api/auth/user/send-activation-mail';

  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};

  @override
  void initState() {
    _getClient();
    super.initState();
  }

  void _getClient() async {
    while (client == null) {
      client = await OAuth2Client().getClientCredentialsGrant();
    }
  }

  Future addUser() async {
    var body = jsonEncode({
      'email': '${emailController.text}',
      'password': '${passwordController.text}'
    });
    final signUpResponse =
        await client.post(signUpUrl, headers: headers, body: body);

    if (signUpResponse.statusCode == 201) {
      _sendVerificationEmail();
      DoggoToast.of(context).showToast('Registration completed. Welcome!');
      Navigator.of(context).pop();
    } else if (signUpResponse.statusCode == 400) {
      DoggoToast.of(context).showToast('You have to provide a valid email!');
    } else if (signUpResponse.statusCode == 409) {
      DoggoToast.of(context)
          .showToast('Account with given email already exists!');
    } else
      DoggoToast.of(context)
          .showToast('Failed to create user.');
    throw Exception('Failed to create user.\nCode: ${signUpResponse.statusCode}');
  }

  Future _sendVerificationEmail() async {
    var mailQueryParameters = {'userEmail': '${emailController.text}'};
    var mailUri = Uri.https(authority, mailPath, mailQueryParameters);

    final mailResponse = await client.post(mailUri, headers: headers);
    if (mailResponse.statusCode != 200) {
      DoggoToast.of(context).showToast('Activation email could not be sent!');
      throw Exception(
          'Activation email could not be sent!\nCode: ${mailResponse.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 50.0,
                      child: MaterialButton(
                        // ignore: missing_return
                        onPressed: () {
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
                                  Colors.orangeAccent,
                                  Color.fromRGBO(200, 100, 20, .4)
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
