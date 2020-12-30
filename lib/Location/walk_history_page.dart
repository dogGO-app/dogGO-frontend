import 'dart:convert';
import 'package:doggo_frontend/Custom/doggo_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:doggo_frontend/OAuth2/oauth2_client.dart';
import 'package:oauth2/oauth2.dart';
import 'package:doggo_frontend/Location/http/walk_history_data.dart';

class WalkHistoryPage extends StatefulWidget {
  @override
  _WalkHistoryPageState createState() => _WalkHistoryPageState();
}

class _WalkHistoryPageState extends State<WalkHistoryPage> {
  Client client;
  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};
  final authority = 'doggo-service.herokuapp.com';
  Future<List<Walk>> _walks;

  @override
  void initState() {
    setState(() {
      _walks = _fetchWalksHistory();
    });
    super.initState();
  }

  Future<List<Walk>> _fetchWalksHistory() async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);
    final url =
        'https://doggo-service.herokuapp.com/api/dog-lover/walks/history';
    final response = await client.get(url, headers: headers);
    print(response.statusCode);
    if(response.statusCode == 200){
      List jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      print(jsonResponse);
      return jsonResponse.map((walk) => Walk.fromJson(walk)).toList();
    }
    else {
      DoggoToast.of(context).showToast('Failed to load walks history');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        title: Text('Walks History'),
      ),
      body: FutureBuilder<List<Walk>>(
        future: _walks,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            List<Walk> walksHistory = snapshot.data;
            return ListView.builder(
              itemCount: walksHistory.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      "${walksHistory[index].marker.name}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18
                      ),
                    ),
                    subtitle: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Location description: " + walksHistory[index].marker.description,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                wordSpacing: 2.0
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Date and hour: " +
                              walksHistory[index].walkDateTime.toString().substring(0, 16),
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              wordSpacing: 2.0
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Dogs: " +
                                walksHistory[index].dogsNames.toString().substring(1, walksHistory[index].dogsNames.toString().length-1),
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                wordSpacing: 2.0
                            ),
                          ),
                        ),

                      ],
                    ),
                    leading: Icon(
                      Icons.directions_walk,
                      color: Colors.orangeAccent,
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError){
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
