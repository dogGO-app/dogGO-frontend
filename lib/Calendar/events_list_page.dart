import 'dart:async';
import 'dart:convert';

import 'package:doggo_frontend/Calendar/add_event_page.dart';
import 'package:doggo_frontend/Calendar/edit_event_page.dart';
import 'package:doggo_frontend/Calendar/http/event_data.dart';
import 'package:doggo_frontend/OAuth2/oauth2_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oauth2/oauth2.dart';

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  Client client;
  final url =
      'https://doggo-service.herokuapp.com/api/dog-lover/user-calendar-events';
  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};

  Timer _timer;
  Future<List<List<Event>>> _events;

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _events = _fetchEvents();
      });
    });
    setState(() {
      _events = _fetchEvents();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<List<List<Event>>> _fetchEvents() async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);

    final response = await client.get(url, headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

      List<Event> events =
          jsonResponse.map((event) => Event.fromJson(event)).toList();
      List<Event> pastEvents = events
          .where((element) => element.eventDateTime.isBefore(DateTime.now())).toList();
      List<Event> futureEvents =
          events.toSet().difference(pastEvents.toSet()).toList().toList();

      pastEvents.sort((a, b) => b.eventDateTime.compareTo(a.eventDateTime));
      futureEvents.sort((a, b) => a.eventDateTime.compareTo(b.eventDateTime));

      return [futureEvents, pastEvents];
    } else {
      throw Exception('Failed to load events from API');
    }
  }

  Row _createTypeDivider(EventType type, double screenWidth) {
    return Row(children: <Widget>[
      Expanded(
        child: new Container(
            margin: EdgeInsets.only(
                left: screenWidth * 0.05, right: screenWidth * 0.1),
            child: Divider(
              color: Colors.black,
              height: 52,
            )),
      ),
      Text('${describeEnum(type)} EVENTS',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      Expanded(
        child: new Container(
            margin: EdgeInsets.only(
                left: screenWidth * 0.05, right: screenWidth * 0.1),
            child: Divider(
              color: Colors.black,
              height: 52,
            )),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Calendar'),
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
      body: SingleChildScrollView(
        child: FutureBuilder<List<List<Event>>>(
          future: _events,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<List<Event>> events = snapshot.data;
              return Column(
                children: [
                  _createTypeDivider(EventType.FUTURE, screenWidth),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: events[0].length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(
                            "${DateFormat("dd-MM-yyyy").format(events[0][index].eventDateTime)}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24.0,
                            ),
                          ),
                          subtitle: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    "Time: ${TimeOfDay.fromDateTime(events[0][index].eventDateTime).format(context)}"),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child:
                                Text("Description: ${events[0][index].description}"),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Dog name: ${events[0][index].dogName}"),
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
                                    eventData: events[0][index],
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
                  ),
                  _createTypeDivider(EventType.PAST, screenWidth),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: events[1].length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(
                            "${DateFormat("dd-MM-yyyy").format(events[1][index].eventDateTime)}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24.0,
                            ),
                          ),
                          subtitle: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    "Time: ${TimeOfDay.fromDateTime(events[1][index].eventDateTime).format(context)}"),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child:
                                Text("Description: ${events[1][index].description}"),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Dog name: ${events[1][index].dogName}"),
                              ),
                            ],
                          ),
                          leading: Icon(
                            Icons.calendar_today,
                            color: Colors.orangeAccent,
                          ),
                        ),
                        elevation: 5,
                      );
                    },
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.orangeAccent,
                ),
              );
            }
            return Center(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text('You don\'t any events planned yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight * 0.04)),
            ));
          },
        ),
      ),
    );
  }
}
