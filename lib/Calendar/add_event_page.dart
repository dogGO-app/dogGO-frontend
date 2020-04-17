import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final descriptionController = TextEditingController();
  final dogNameController = TextEditingController();

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    descriptionController.dispose();
    dogNameController.dispose();
    super.dispose();
  }

  Future showAlertDialogWithMessage(String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(message));
        });
  }

  Future addEventData() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    var url = 'https://doggo-app-server.herokuapp.com/api/userCalendarEvents ';
    var reqBody = jsonEncode({
      'date': '${dateController.text}',
      'time': '${timeController.text}',
      'description': '${descriptionController.text}',
      'dogName': '${dogNameController.text}'
    });
    var headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };

    final pushResponse = await http.post(url, body: reqBody, headers: headers);
    if (pushResponse.statusCode == 200) {
      Navigator.of(context).pop();
    } else {
      showAlertDialogWithMessage('Could not add calendar event!');
      throw Exception('Could not add calendar event');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Add Event To Your Calendar'),
          centerTitle: true,
          backgroundColor: Colors.orangeAccent
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
                            offset: Offset(0, 10)
                          )
                        ]
                      ),
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
                          DateTimeField(
                            format: DateFormat("HH:mm"),
                            onShowPicker: (context, currentValue) async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
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
                                hintStyle: TextStyle(color: Colors.grey)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
