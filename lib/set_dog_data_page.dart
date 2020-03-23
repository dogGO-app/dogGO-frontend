import 'dart:convert';
import 'package:flutter/material.dart';
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

  Map data = {};

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
    var url = 'https://doggo-app-server.herokuapp.com/api/dogs';
    var reqBody = jsonEncode({
      'name': '${nameController.text}',
      'breed': '${breedController.text}',
      'color': '${colorController.text}',
      'description': '${descriptionController.text}',
      'lastVaccinationDate': '${vaccinationDateController.text}'
    });
    var headers = {'Content-Type': 'application/json', 'Accept': '*/*', 'Authorization': 'Bearer ${data['token']}'};
    final response = await http.post(url, body: reqBody, headers: headers);
    if (response.statusCode == 200) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/userprofile', (Route<dynamic> route) => false,
          arguments: {'token': data['token']});
    }
    else {
      showAlertDialogWithMessage('Error!');
    }
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context).settings.arguments;

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
                          Text('Click below to select vaccination date', style: TextStyle(color: Colors.grey)),
                          DateTimeField(
                            controller: vaccinationDateController,
                            format: DateFormat("yyyy-MM-dd"),
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
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
