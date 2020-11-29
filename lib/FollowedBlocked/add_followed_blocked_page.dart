import 'package:doggo_frontend/Custom/doggo_toast.dart';
import 'package:doggo_frontend/OAuth2/oauth2_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart';

class AddFollowedBlockedPageState extends State<AddFollowedBlockedPage> {
  Client client;

  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};

  final nicknameController = TextEditingController();

  String dropdownValue;
  List<String> dropdownMenuItems = List<String>.of(['FOLLOW', 'BLOCK']);

  @override
  void dispose() {
    nicknameController.dispose();
    super.dispose();
  }

  Future _addFollowedBlocked() async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);
    final authority = 'doggo-service.herokuapp.com';
    final path = '/api/dog-lover/relationships/${nicknameController.text}';
    final queryParameters = {'status': '${dropdownValue}S'};
    final url = Uri.https(authority, path, queryParameters);

    final response = await client.post(url, headers: headers);
    switch (response.statusCode) {
      case 201:
        {
          DoggoToast.of(context)
              .showToast('Person added to $dropdownValue successfully.');
          Navigator.of(context).pop();
          break;
        }
      case 404:
        {
          DoggoToast.of(context)
              .showToast('Person with given nickname doesn\'t exist.');
          break;
        }
      case 409:
        {
          DoggoToast.of(context).showToast(
              'Person with given nickname is already $dropdownValue.');
          break;
        }
      default:
        {
          DoggoToast.of(context)
              .showToast('Could add person to FOLLOWED or BLOCKED.');
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Follow or Block'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: screenHeight * 0.2),
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
                              controller: nicknameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Nickname",
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
                                  hint: Text("Action"),
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
                                        padding: EdgeInsets.only(left: 7),
                                        child: Text(value),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.2,
                    ),
                    Container(
                      height: screenHeight * 0.15,
                      child: MaterialButton(
                        onPressed: () {
                          _addFollowedBlocked();
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
                              "Submit",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.1,
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
}

class AddFollowedBlockedPage extends StatefulWidget {
  @override
  AddFollowedBlockedPageState createState() => AddFollowedBlockedPageState();
}
