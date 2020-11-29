import 'dart:convert';

import 'package:doggo_frontend/Custom/doggo_toast.dart';
import 'package:doggo_frontend/OAuth2/oauth2_client.dart';
import 'package:doggo_frontend/User/http/user_details_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class _EditUserDataPageState extends State<EditUserDataPage> {
  Client client;
  final url = 'https://doggo-service.herokuapp.com/api/dog-lover/profiles';
  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};

  String dropdownValue;
  var dropdownMenuItems = List<String>.generate(99, (i) => (i + 1).toString());

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final hobbyController = TextEditingController();
  final nicknameController = TextEditingController();

  @override
  void initState() {
    if (widget.userData != null) {
      firstNameController.text = widget.userData.firstName;
      lastNameController.text = widget.userData.lastName;
      dropdownValue = widget.userData.age.toString();
      hobbyController.text = widget.userData.hobby;
      nicknameController.text = widget.userData.nickname;
    }
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    hobbyController.dispose();
    super.dispose();
  }

  Future addUserDetails() async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);
    final body = jsonEncode({
      'firstName': '${firstNameController.text}',
      'lastName': '${lastNameController.text}',
      'age': '$dropdownValue',
      'hobby': '${hobbyController.text}',
      'nickname': '${nicknameController.text}'
    });

    final response = await client.put(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      DoggoToast.of(context).showToast('Details updated correctly.');
      Navigator.of(context).pop();
    } else if (response.statusCode == 400)
      DoggoToast.of(context).showToast('Incorrect details format.');
    // TODO: log error
    else
      DoggoToast.of(context).showToast('Could not edit user data');
    // TODO: log error
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
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: dropdownValue,
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 16,
                                  isExpanded: true,
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
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: Text(value),
                                      ),
                                    );
                                  }).toList(),
                                ),
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
                          Divider(color: Colors.grey),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: TextField(
                              controller: nicknameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              enabled: false,
                              style: TextStyle(color: Colors.grey),
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

class EditUserDataPage extends StatefulWidget {
  final UserDetailsResponse userData;

  const EditUserDataPage({Key key, this.userData}) : super(key: key);

  @override
  _EditUserDataPageState createState() => _EditUserDataPageState();
}
