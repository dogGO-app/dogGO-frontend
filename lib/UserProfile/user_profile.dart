import 'package:flutter/material.dart';

class UserProfileView extends StatefulWidget {

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {

  @override
  Widget build(BuildContext context) {
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
              'NAME',
              style: TextStyle(
                letterSpacing: 1.5,
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Radek',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'SURNAME',
              style: TextStyle(
                letterSpacing: 1.5,
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Leszkiewicz',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5
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
            Text(
              '21',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5
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
            Text(
              'Psy i koty',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5
              ),
            ),
            SizedBox(height: 25.0),
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
                    "See information about your dogs",
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
}
