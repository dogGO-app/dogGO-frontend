import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class SetDogDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Your Details'),
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
                          nameField,
                          Divider(color: Colors.grey),
                          breed,
                          Divider(color: Colors.grey),
                          color,
                          Divider(color: Colors.grey),
                          description,
                          Divider(color: Colors.grey),
                          Text('Click below to select vaccination date', style: TextStyle(color: Colors.grey)),
                          DateTimeField(
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
                        onPressed: () {},
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

  final nameField = Container(
    padding: EdgeInsets.all(8),
    child: TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Name",
        hintStyle: TextStyle(color: Colors.grey),
      ),
    ),
  );

  final breed = Container(
    padding: EdgeInsets.all(8),
    child: TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Breed",
        hintStyle: TextStyle(color: Colors.grey),
      ),
    ),
  );

  final color = Container(
    padding: EdgeInsets.all(8),
    child: TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Color",
        hintStyle: TextStyle(color: Colors.grey),
      ),
    ),
  );

  final description = Container(
    padding: EdgeInsets.all(8),
    child: TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Description",
        hintStyle: TextStyle(color: Colors.grey),
      ),
    ),
  );
}
