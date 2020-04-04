import 'dart:convert';
import 'package:doggo_frontend/Dog/http/dog_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:http/http.dart' as http;

class SetDogDataPage extends StatefulWidget {
  @override
  _SetDogDataPageState createState() => _SetDogDataPageState();
}

class _SetDogDataPageState extends State<SetDogDataPage> {
  final nameController = TextEditingController();
  final breedController = TextEditingController();
  final colorController = TextEditingController();
  final descriptionController = TextEditingController();
  final vaccinationDateController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    breedController.dispose();
    colorController.dispose();
    descriptionController.dispose();
    vaccinationDateController.dispose();
    super.dispose();
  }

  Future showAlertDialogWithMessage(String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(message));
        });
  }

  Future setDogData() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    var url = 'https://doggo-app-server.herokuapp.com/api/dogs';
    var reqBody = jsonEncode({
      'name': '${nameController.text}',
      'breed': '${breedController.text}',
      'color': '${colorController.text}',
      'description': '${descriptionController.text}',
      'lastVaccinationDate': '${vaccinationDateController.text}'
    });
    var headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };

    final getResponse = await http.get(url, headers: headers);
    if (getResponse.statusCode == 200) {
      List jsonResponse = jsonDecode(getResponse.body);
      bool hasDogs =
          jsonResponse.map((dog) => Dog.fromJson(dog)).toList().isNotEmpty;
      final pushResponse =
          await http.post(url, body: reqBody, headers: headers);
      if (pushResponse.statusCode == 200) {
        if (hasDogs)
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/dogsinfo', (Route<dynamic> route) => false);
        else
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/userprofile', (Route<dynamic> route) => false);
      } else {
        showAlertDialogWithMessage('Could not set dog data!');
        throw Exception('Could not set dog data');
      }
    } else {
      showAlertDialogWithMessage('Could not get dog data!');
      throw Exception('Could not get dog data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Dog\'s Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 10),
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
                              controller: nameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Name",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          Divider(color: Colors.grey),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: TextField(
                              controller: breedController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Breed",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          Divider(color: Colors.grey),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: TextField(
                              controller: colorController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Color",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          Divider(color: Colors.grey),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: TextField(
                              controller: descriptionController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Description",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          Divider(color: Colors.grey),
                          Text('Click below to select vaccination date',
                              style: TextStyle(color: Colors.grey)),
                          DateTimeField(
                            controller: vaccinationDateController,
                            format: DateFormat("yyyy-MM-dd"),
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime.now());
                            },
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
                          setDogData();
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
}
