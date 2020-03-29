import 'dart:convert';

import 'package:doggo_frontend/User/http/user_details_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class _UserProfileViewState extends State<UserProfileView> {
  Future<UserDetailsResponse> userDetails;

  @override
  void initState() {
    super.initState();
    userDetails = fetchUserDetails();
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
                child: FutureBuilder<UserDetailsResponse>(
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
                child: FutureBuilder<UserDetailsResponse>(
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
                child: FutureBuilder<UserDetailsResponse>(
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
                child: FutureBuilder<UserDetailsResponse>(
                  future: userDetails,
                  // ignore: missing_return
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
              SizedBox(height: 30.0),
              Center(
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/dogsinfo');
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
                        "See Information About Your Dogs",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Center(
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/edituserdata');
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
                    final storage = FlutterSecureStorage();
                    await storage.delete(key: 'token');
                    Navigator.of(context).pushNamedAndRemoveUntil(
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

  Future<UserDetailsResponse> fetchUserDetails() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    var url = 'https://doggo-app-server.herokuapp.com/api/dogLover';
    var headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return UserDetailsResponse.fromJson(json.decode(response.body));
    } else
      showAlertDialogWithMessage('Could not fetch user details!');
  }

  Future showAlertDialogWithMessage(String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(message));
        });
  }
}

class UserProfileView extends StatefulWidget {
  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}
