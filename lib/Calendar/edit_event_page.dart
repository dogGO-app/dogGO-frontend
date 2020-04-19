import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:http/http.dart' as http;
import 'package:doggo_frontend/Dog/http/dog_data.dart';
import 'dart:convert';

class EditEventPage extends StatefulWidget {
  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  String selectedDog;
  List<dynamic> _dogs = List();

  void _fetchDogs() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    final url = 'https://doggo-app-server.herokuapp.com/api/dogs';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      var temp = jsonResponse.map((dog) => Dog.fromJson(dog)).toList();
      setState(() {
        _dogs = temp;
      });
    } else {
      throw Exception('Failed to load dogs from API');
    }
  }

  Future showAlertDialogWithMessage(String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(message));
        });
  }

  Future editEventData() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final id = await storage.read(key: 'eventId');

    var url = 'https://doggo-app-server.herokuapp.com/api/userCalendarEvents';
    var reqBody = jsonEncode({
      'id': '$id',
      'date': '${dateController.text}',
      'time': '${timeController.text}',
      'description': '${descriptionController.text}',
      'dogName': '$selectedDog'
    });
    var headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };

    final pushResponse = await http.put(url, body: reqBody, headers: headers);
    if (pushResponse.statusCode == 200) {
      Navigator.of(context).pop();
    } else {
      showAlertDialogWithMessage('Could not edit calendar event!');
      throw Exception('Could not edit calendar event');
    }
  }

  @override
  void initState() {
    _fetchDogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title: Text('Edit Event In Your Calendar'),
          centerTitle: true,
          backgroundColor: Colors.orangeAccent),
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
                          Text('Click below to select event date',
                              style: TextStyle(color: Colors.grey)),
                          DateTimeField(
                            controller: dateController,
                            format: DateFormat("yyyy-MM-dd"),
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2025));
                            },
                          ),
                          Divider(color: Colors.grey),
                          Text('Click below to select event time',
                              style: TextStyle(color: Colors.grey)),
                          DateTimeField(
                            controller: timeController,
                            format: DateFormat("HH:mm"),
                            onShowPicker: (context, currentValue) async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    currentValue ?? DateTime.now()),
                              );
                              return DateTimeField.convert(time);
                            },
                          ),
                          Divider(color: Colors.grey),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: TextField(
                              controller: descriptionController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Description",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                          ),
                          Divider(color: Colors.grey),
                          DropdownButton(
                            hint: Text("Select your dog"),
                            value: selectedDog,
                            items: _dogs.map((doggo) {
                              return DropdownMenuItem(
                                child: Text(doggo.name),
                                value: doggo.name,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedDog = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      height: 50.0,
                      child: MaterialButton(
                        onPressed: () {
                          if(dateController.text == ""){
                            showAlertDialogWithMessage('Date and time has to be filled!');
                            throw Exception('Date and time are empty');
                          } else {
                            editEventData();
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
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
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 300.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Edit Event",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
