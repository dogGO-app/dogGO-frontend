import 'dart:convert';

import 'package:doggo_frontend/Custom/doggo_toast.dart';
import 'package:doggo_frontend/OAuth2/oauth2_client.dart';
import 'package:doggo_frontend/User/edit_user_profile_page.dart';
import 'package:doggo_frontend/User/http/user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class _UserProfilePageState extends State<UserProfilePage> {
  Client client;
  final url = 'https://doggo-service.herokuapp.com/api/dog-lover/profiles';
  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};

  Future<User> userDetails;

  @override
  void initState() {
    userDetails = fetchUserDetails();
    super.initState();
  }

  Future<User> fetchUserDetails() async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);

    final response = await client.get(url, headers: headers);
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    else if (response.statusCode == 400)
      DoggoToast.of(context).showToast('Incorrect details format.');
    // TODO: log error
    else {
      DoggoToast.of(context).showToast('Could not fetch user details!');
      throw Exception("Could not fetch user details!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text('Your dogGO Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20.0),
              Text(
                'FIRST NAME',
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                child: FutureBuilder<User>(
                  future: userDetails,
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return Text(
                        snapshot.data.firstName,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5),
                      );
                    else if (snapshot.hasError)
                      return Text('Could not read first name');
                    else
                      return CircularProgressIndicator();
                  },
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                'LAST NAME',
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                child: FutureBuilder<User>(
                  future: userDetails,
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return Text(
                        snapshot.data.lastName,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5),
                      );
                    else if (snapshot.hasError)
                      return Text('Could not read last name');
                    else
                      return CircularProgressIndicator();
                  },
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                'AGE',
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                child: FutureBuilder<User>(
                  future: userDetails,
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return Text(
                        snapshot.data.age.toString(),
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5),
                      );
                    else if (snapshot.hasError)
                      return Text('Could not read age');
                    else
                      return CircularProgressIndicator();
                  },
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                'HOBBY',
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                child: FutureBuilder<User>(
                  future: userDetails,
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return Text(
                        snapshot.data.hobby,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5),
                      );
                    else if (snapshot.hasError)
                      return Text('Could not read hobby');
                    else
                      return CircularProgressIndicator();
                  },
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'NICKNAME',
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                child: FutureBuilder<User>(
                  future: userDetails,
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return Text(
                        snapshot.data.nickname,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5),
                      );
                    else if (snapshot.hasError)
                      return Text('Could not read hobby');
                    else
                      return CircularProgressIndicator();
                  },
                ),
              ),
              SizedBox(height: 45.0),
              Center(
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) => FutureBuilder(
                              future: userDetails,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return EditUserDataPage(
                                    userData: snapshot.data,
                                  );
                                } else if (snapshot.hasError) {
                                  throw Exception(
                                    "Couldn't acquire user data!",
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ),
                        )
                        .whenComplete(() => {
                              setState(() {
                                userDetails = fetchUserDetails();
                              })
                            });
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
                      constraints:
                          BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Edit Your Details",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.0),
              Center(
                child: MaterialButton(
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamedAndRemoveUntil(
                            '/home', (Route<dynamic> route) => false);
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
                      constraints:
                          BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Logout",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}
