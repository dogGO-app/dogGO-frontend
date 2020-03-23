import 'dart:convert';

import 'package:flutter/material.dart';
import '../http/user_details_response.dart';
import 'package:http/http.dart' as http;

class UserProfileView extends StatefulWidget {

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  Map data = {};
  Future<UserDetailsResponse> userDetails;
  
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    userDetails = fetchUserDetails(data['token']);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text('Your dogGO Profile'),
        centerTitle: true,
      ),
      body: Padding(
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
            FutureBuilder<UserDetailsResponse>(
              future: userDetails,
              // ignore: missing_return
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(
                    snapshot.data.firstName,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5
                    ),
                  );
                else if (snapshot.hasError)
                  return Text('ERROR');
              },
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
            FutureBuilder<UserDetailsResponse>(
              future: userDetails,
              // ignore: missing_return
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(
                    snapshot.data.lastName,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5
                    ),
                  );
                else if (snapshot.hasError)
                  return Text('ERROR');
              },
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
            FutureBuilder<UserDetailsResponse>(
              future: userDetails,
              // ignore: missing_return
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(
                    snapshot.data.age,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5
                    ),
                  );
                else if (snapshot.hasError)
                  return Text('ERROR');
              },
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
            FutureBuilder<UserDetailsResponse>(
              future: userDetails,
              // ignore: missing_return
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(
                    snapshot.data.hobby,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5
                    ),
                  );
                else if (snapshot.hasError)
                  return Text('ERROR');
              },
            ),
            SizedBox(height: 30.0),
            Center(child: MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/dogsinfo');
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.orangeAccent,
                      Color.fromRGBO(200, 100, 20, .4)
                    ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                  alignment: Alignment.center,
                  child: Text(
                    "See Information About Your Dogs",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
            ),
            SizedBox(height: 15.0,),
            Center(child: MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/edituserdata');
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.orangeAccent,
                      Color.fromRGBO(200, 100, 20, .4)
                    ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                  alignment: Alignment.center,
                  child: Text(
                    "Edit Your Details",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
            ),
            SizedBox(height: 15.0),
            Center(child: MaterialButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home', (Route<dynamic> route) => false);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.orangeAccent,
                      Color.fromRGBO(200, 100, 20, .4)
                    ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                  alignment: Alignment.center,
                  child: Text(
                    "Logout",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
            ),

          ],
        ),
      ),
    );
  }

  Future<UserDetailsResponse> fetchUserDetails(Map data) async {
    var url = 'https://doggo-app-server.herokuapp.com/api/dogLover';
    var headers = {'Content-Type': 'application/json', 'Accept': '*/*', 'Authorization': 'Bearer ${data['token']}'};

    final response = await http.put(url, headers: headers);
    if (response.statusCode == 200) {
      return UserDetailsResponse.fromJson(json.decode(response.body));
    } else
      showAlertDialogWithMessage('Error!');
  }

  Future showAlertDialogWithMessage(String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(message));
        });
  }
}
