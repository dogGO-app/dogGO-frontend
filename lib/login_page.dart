import 'package:flutter/material.dart';
import 'registration_page.dart';

class LoginPage extends StatelessWidget {
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
                          emailTextField,
                          Divider(color: Colors.grey),
                          passwordTextField
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 50.0,
                      child: MaterialButton(
                        onPressed: () {},
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegistrationPage()));
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

  final emailTextField = Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(),
    child: TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Email",
        hintStyle: TextStyle(color: Colors.grey),
      ),
    ),
  );

  final passwordTextField = Container(
    padding: EdgeInsets.all(8),
    child: TextField(
      obscureText: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Password",
        hintStyle: TextStyle(color: Colors.grey),
      ),
    ),
  );
}
