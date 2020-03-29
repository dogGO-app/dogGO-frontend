import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class EditUserData extends StatefulWidget {
  @override
  _EditUserDataState createState() => _EditUserDataState();
}

class _EditUserDataState extends State<EditUserData> {
  String dropdownValue;

  var dropdownMenuItems = List<String>.generate(99, (i) => (i + 1).toString());

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final hobbyController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    hobbyController.dispose();
    super.dispose();
  }

  Future addUserDetails() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    var url = 'https://doggo-app-server.herokuapp.com/api/dogLover';
    var body = jsonEncode({
      'firstName': '${firstNameController.text}',
      'lastName': '${lastNameController.text}',
      'age': '$dropdownValue',
      'hobby': '${hobbyController.text}'
    });
    var headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };

    final response = await http.put(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/userprofile', (Route<dynamic> route) => false);
    } else
      showAlertDialogWithMessage('Could not edit user data!');
  }

  Future showAlertDialogWithMessage(String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(message));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Your Details'),
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
                            child: TextField(
                              controller: firstNameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "First name",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          Divider(color: Colors.grey),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: TextField(
                              controller: lastNameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Last name",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          Divider(color: Colors.grey),
                          Container(
                              padding: EdgeInsets.all(8),
                              child: DropdownButton(
                                value: dropdownValue,
                                icon: Icon(Icons.arrow_downward),
                                iconSize: 16,
                                hint: Text("Age"),
                                style: TextStyle(color: Colors.orangeAccent),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                  });
                                },
                                items: dropdownMenuItems.map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )),
                          Divider(color: Colors.grey),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: TextField(
                              controller: hobbyController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Hobby",
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
                          addUserDetails();
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
                              "Edit",
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

  final firstNameTextField = Container(
    padding: EdgeInsets.all(8),
    child: TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "First name",
        hintStyle: TextStyle(color: Colors.grey),
      ),
    ),
  );

  final lastNameTextField = Container(
    padding: EdgeInsets.all(8),
    child: TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Last name",
        hintStyle: TextStyle(color: Colors.grey),
      ),
    ),
  );

  final hobbyTextField = Container(
    padding: EdgeInsets.all(8),
    child: TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Hobby",
        hintStyle: TextStyle(color: Colors.grey),
      ),
    ),
  );
}
