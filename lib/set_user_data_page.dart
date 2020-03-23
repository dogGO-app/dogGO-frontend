import 'package:flutter/material.dart';

class SetUserDataState extends State<SetUserDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Your Details'),
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
                          firstNameTextField,
                          Divider(color: Colors.grey),
                          lastNameTextField,
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
                                items: dropdownMenuItems
                                  .map((String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                })
                                  .toList(),
                              )),
                          Divider(color: Colors.grey),
                          hobbyTextField,
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
                          Navigator.of(context).pushNamedAndRemoveUntil('/adddogdata',
                                  (Route<dynamic> route) => false);
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

  String dropdownValue;

  List<String> dropdownMenuItems = List<String>.generate(99, (i) => (i + 1).toString());

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

class SetUserDataPage extends StatefulWidget {
  @override
  SetUserDataState createState() => SetUserDataState();
}
