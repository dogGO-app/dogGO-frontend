import 'dart:async';
import 'dart:io';
import 'package:doggo_frontend/Custom/doggo_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:doggo_frontend/OAuth2/oauth2_client.dart';
import 'package:oauth2/oauth2.dart';
import 'package:doggo_frontend/Location/http/useranddogs.dart';

class PeopleAndDogsInLocationPage extends StatefulWidget {
  final String markerId;
  const PeopleAndDogsInLocationPage({Key key, this.markerId}) : super(key: key);

  @override
  _PeopleAndDogsInLocationPageState createState() => _PeopleAndDogsInLocationPageState();
}

class _PeopleAndDogsInLocationPageState extends State<PeopleAndDogsInLocationPage> {

  Client client;
  final url = 'https://doggo-service.herokuapp.com/api/dog-lover/walks/dog-lovers-in-location/';
  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};

  Future<List<UserAndDogsInLocation>> _usersanddogs;

  @override
  void initState(){
    setState(() {
      _usersanddogs = _fetchUsersAndDogsInLocation(widget.markerId);
    });
    super.initState();
    Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        _usersanddogs = _fetchUsersAndDogsInLocation(widget.markerId);
      });
    });
  }

  Future<List<UserAndDogsInLocation>> _fetchUsersAndDogsInLocation(String markerId) async {
    // var jsonString = rootBundle.loadString('doggos.json');
    // List jsonResponse = jsonDecode(await jsonString);
    // return jsonResponse.map((e) => UserAndDogsInLocation.fromJson(e)).toList();
    client ??= await OAuth2Client().loadCredentialsFromFile(context);
    String newUrl = url + markerId;
    final response = await client.get(newUrl, headers: headers);
    if(response.statusCode == 200){
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((useranddogs) => UserAndDogsInLocation.fromJson(useranddogs)).toList();
    } else {
      DoggoToast.of(context).showToast('Failed to load users and dogs in given location ${response.statusCode}');
      throw Exception('Failed to load users and dogs from API');
    }


  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        title: Text('People in current location')
      ),
      body: FutureBuilder<List<UserAndDogsInLocation>>(
        future: _usersanddogs,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            List<UserAndDogsInLocation> usersanddogs = snapshot.data;
            return ListView.builder(
              itemCount: usersanddogs.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    usersanddogs[index].nickname,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text(usersanddogs[index].name),
                  leading: Icon(
                    Icons.account_circle,
                    color: Colors.orangeAccent,
                  ),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: usersanddogs[index].dogs.length,
                      itemBuilder: (context, index2){
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: screenHeight*0.005,
                            horizontal: screenWidth*0.17
                          ),
                          leading: Icon(
                            Icons.pets,
                            color: Colors.orangeAccent,
                          ),
                          title: Text(
                            usersanddogs[index].dogs[index2].name
                          ),
                          subtitle: Text(
                              usersanddogs[index].dogs[index2].breed
                          ),
                        );
                      }
                    ),
                    RaisedButton(
                      onPressed: () {

                      },
                      child: Text(
                        'Add friend'
                      ),
                    )
                  ],
                );
              }
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.orangeAccent,
            ),
          );
        }
      )
    );
  }
}
