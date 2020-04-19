import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login to DogGO!'),
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
                              obscureText: false,
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

  Future loginUser() async {
    final storage = FlutterSecureStorage();

    var postUrl = 'https://doggo-app-server.herokuapp.com/api/auth/signin';
    var postRequestBody = jsonEncode({
      'email': '${emailController.text}',
      'password': '${passwordController.text}'
    });
    var postHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    final postResponse =
        await http.post(postUrl, body: postRequestBody, headers: postHeaders);
    final token = jsonDecode(postResponse.body)['token'];

    if (postResponse.statusCode == 200) {
      var getUrl = 'https://doggo-app-server.herokuapp.com/api/dogLover';
      var getHeaders = {'Authorization': 'Bearer $token'};

      await storage.write(key: 'token', value: token);
      final getResponse = await http.get(getUrl, headers: getHeaders);

      if (getResponse.statusCode == 200) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/userprofile', (Route<dynamic> route) => false);
      } else if (getResponse.statusCode == 404) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/adduserdata', (Route<dynamic> route) => false);
      } else {
        return showAlertDialogWithMessage('Error!');
      }
    } else {
      return showAlertDialogWithMessage(
          'There is no account with given email/password!');
    }
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
