import 'package:doggo_frontend/Authorization/dto/credentials.dart';
import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart';

import '../Custom/doggo_toast.dart';
import '../OAuth2/oauth2_client.dart';

class LoginPageState extends State<LoginPage> {
  Client client;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final getUserUrl =
      'https://doggo-service.herokuapp.com/api/dog-lover/profiles';
  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future _getClient(String email, String password) async {
    client ??= await OAuth2Client()
        .getResourceOwnerPasswordGrant(email, password)
        .catchError((e) {
      if (e.description == 'Account disabled') {
        Navigator.of(context)
            .pushNamed('/verify', arguments: UserCredentials(emailController.text, passwordController.text));
      } else if (e.description == 'Invalid user credentials') {
        DoggoToast.of(context)
            .showToast('There is no account with given email/password.');
      }
    });
  }

  Future loginUser() async {
    await _getClient(emailController.text, passwordController.text);

    if (client != null) _getUser();
  }

  Future _getUser() async {
    final getUserResponse = await client.get(getUserUrl, headers: headers);

    if (getUserResponse.statusCode == 200) {
      Navigator.of(context).pushNamed('/homescreen');
    } else if (getUserResponse.statusCode == 404) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/adduserdata', (Route<dynamic> route) => false);
    } else {
      DoggoToast.of(context).showToast('Could not log in.');
      throw Exception('Could not log in.\nCode: ${getUserResponse.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login to DogGO'),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 30),
          child: Column(
            children: <Widget>[
              doggoPicture,
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 50.0,
                      child: MaterialButton(
                        onPressed: () {
                          loginUser();
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
                              "Login",
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
                    InkWell(
                      child: Text(
                        'Or Sign Up',
                        style: TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/register');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final doggoPicture = Container(
    alignment: Alignment.center,
    height: 200,
    width: 200,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(width: 1.5, color: Colors.orangeAccent),
      boxShadow: [
        BoxShadow(
            color: Colors.orangeAccent, blurRadius: 20, offset: Offset(0, 10))
      ],
      image: DecorationImage(
        fit: BoxFit.fill,
        image: AssetImage('images/doggo.jpg'),
      ),
    ),
  );

  Future showAlertDialogWithMessage(String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(message));
        });
  }
}

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}
