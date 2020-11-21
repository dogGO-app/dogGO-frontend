import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:doggo_frontend/Custom/doggo_toast.dart';
import 'package:doggo_frontend/Dog/http/dog_data.dart';
import 'package:doggo_frontend/OAuth2/oauth2_client.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oauth2/oauth2.dart';

class _EditDogDataPageState extends State<EditDogDataPage> {
  Client client;
  final url = 'https://doggo-service.herokuapp.com/api/dog-lover/dogs';
  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};

  final nameController = TextEditingController();
  final breedController = TextEditingController();
  final colorController = TextEditingController();
  final descriptionController = TextEditingController();
  final vaccinationDateController = TextEditingController();

  @override
  void initState() {
    if (widget.dogData != null) {
      nameController.text = widget.dogData.name;
      breedController.text = widget.dogData.breed;
      colorController.text = widget.dogData.color;
      descriptionController.text = widget.dogData.description;
      vaccinationDateController.text =
          DateFormat('yyyy-MM-dd').format(widget.dogData.vaccinationDate);
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    breedController.dispose();
    colorController.dispose();
    descriptionController.dispose();
    vaccinationDateController.dispose();
    super.dispose();
  }

  Future editDogData() async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);
    final body = jsonEncode({
      'name': '${nameController.text}',
      'breed': '${breedController.text}',
      'color': '${colorController.text}',
      'description': '${descriptionController.text}',
      'lastVaccinationDate': '${vaccinationDateController.text}'
    });

    final response = await client.put(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      DoggoToast.of(context).showToast('Dog details updated correctly.');
      Navigator.of(context).pop();
    } else {
      DoggoToast.of(context).showToast('Could not set dog data.');
      throw Exception('Could not set dog data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Dog\'s Details'),
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
                          if (vaccinationDateController.text == "") {
                            DoggoToast.of(context).showToast('Last vaccination date has to be filled.');
                            throw Exception(
                                'Last vaccination date has to be filled!');
                          } else
                            editDogData();
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

class EditDogDataPage extends StatefulWidget {
  final Dog dogData;

  const EditDogDataPage({Key key, this.dogData}) : super(key: key);

  @override
  _EditDogDataPageState createState() => _EditDogDataPageState();
}