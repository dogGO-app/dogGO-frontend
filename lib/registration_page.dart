import 'dart:convert';

import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;

import 'http/add_user_response.dart';

class RegistrationPageState extends State<RegistrationPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  final url = 'https://doggo-app-server.herokuapp.com/api/auth/signup';
  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};

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
                            return showAlertDialogWithMessage(
                                'Email field must be filled!');
                          else if (passwordController.text.isEmpty ||
                              repeatPasswordController.text.isEmpty)
                            return showAlertDialogWithMessage(
                                'Both Password and Repeat password fields must be filled!');
                          else if (passwordController.text.length < 8)
                            return showAlertDialogWithMessage(
                                "Password must be at least 8 characters long!");
                          else if (passwordController.text !=
                              repeatPasswordController.text)
                            return showAlertDialogWithMessage(
                                'Passwords must match!');
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

  Future addUser() async {
    var body = jsonEncode({
      'email': '${emailController.text}',
      'password': '${passwordController.text}'
    });
    final response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
    }
    else if (response.statusCode == 400) {
      return showAlertDialogWithMessage(
          'You have to provide a valid email!');
    }
    else if (response.statusCode == 409) {
      return showAlertDialogWithMessage(
          'Account with given email already exists!');
    }
    else
      throw Exception('Failed to create user.');
  }

  Future showAlertDialogWithMessage(String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(message));
        });
  }
}

class RegistrationPage extends StatefulWidget {
  @override
  RegistrationPageState createState() => RegistrationPageState();
}
