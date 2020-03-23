import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailLoginController = TextEditingController();
  final passwordLoginController = TextEditingController();

  @override
  void dispose() {
    emailLoginController.dispose();
    passwordLoginController.dispose();
    super.dispose();
  }

  Future showAlertDialogWithMessage(String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(message));
        });
  }

  Future loginUser() async {

    var url = 'https://doggo-app-server.herokuapp.com/api/auth/signin';
    var reqBody = jsonEncode({'email': '${emailLoginController.text}', 
      'password': '${passwordLoginController.text}'});
    var headers = {'Content-Type': 'application/json', 'Accept': '*/*'};
    final response = await http.post(url, body: reqBody, headers: headers);
    print(response.body);
    Map<String, dynamic> token = jsonDecode(response.body);
    print(token['token']);
    if(response.statusCode == 200){
      var url2 = 'https://doggo-app-server.herokuapp.com/api/dogLover';
      var headers2 = {'Authorization': 'Bearer ${token['token']}'};
      final response2 = await http.get(url2, headers:  headers2);
      print(response2.body);
      if(response2.statusCode == 200){
        Navigator.of(context).pushNamedAndRemoveUntil('/userprofile', (Route<dynamic> route) => false,
            arguments:{ 'token': token['token'] });
      }
      else if(response2.statusCode == 404){
        Navigator.of(context).pushNamedAndRemoveUntil('/adduserdata', (Route<dynamic> route) => false,
            arguments:{ 'token': token['token'] });
      }
      else{
        return showAlertDialogWithMessage('Error!');
      }
    }
    else {
      return showAlertDialogWithMessage('Error!');
    }
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
                              controller: emailLoginController,
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
                              controller: passwordLoginController,
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
}
