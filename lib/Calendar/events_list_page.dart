import 'dart:convert';

import 'package:doggo_frontend/Calendar/add_event_page.dart';
import 'package:doggo_frontend/Calendar/edit_event_page.dart';
import 'package:doggo_frontend/Calendar/http/event_data.dart';
import 'package:doggo_frontend/Custom/extensions.dart';
import 'package:doggo_frontend/OAuth2/oauth2_client.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oauth2/oauth2.dart';

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  Client client;
  final url = 'https://doggo-service.herokuapp.com/api/dog-lover/user-calendar-events';
  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};

  Future<List<Event>> _events;

  @override
  void initState() {
    setState(() {
      _events = _fetchEvents();
    });
    super.initState();
  }

  Future<List<Event>> _fetchEvents() async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);

    final response = await client.get(url, headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      return jsonResponse.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception('Failed to load events from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your calendar'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn2",
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => AddEventPage(),
                ),
              )
              .whenComplete(() => {
                    setState(() {
                      _events = _fetchEvents();
                    })
                  });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orangeAccent,
        splashColor: Colors.orange,
      ),
      body: FutureBuilder<List<Event>>(
        future: _events,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Event> events = snapshot.data;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      "${DateFormat("dd-MM-yyyy").format(events[index].eventDate)}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24.0,
                      ),
                    ),
                    subtitle: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child:
                              Text("Time: ${events[index].eventTime.parse()}"),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child:
                              Text("Description: ${events[index].description}"),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Dog name: ${events[index].dogName}"),
                        ),
                      ],
                    ),
                    leading: Icon(
                      Icons.calendar_today,
                      color: Colors.orangeAccent,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (context) => EditEventPage(
                                  eventData: events[index],
                                ),
                              ),
                            )
                            .whenComplete(() => {
                                  setState(() {
                                    _events = _fetchEvents();
                                  })
                                });
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ),
                  elevation: 5,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.orangeAccent,
            ),
          );
        },
      ),
    );
  }
}
