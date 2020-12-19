import 'dart:convert';
import 'package:doggo_frontend/Custom/doggo_toast.dart';
import 'package:doggo_frontend/Location/http/recomended_location_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doggo_frontend/OAuth2/oauth2_client.dart';
import 'package:oauth2/oauth2.dart';
import 'package:doggo_frontend/Dog/http/dog_data.dart';

import 'choose_dogs_dialog_widget.dart';

class RecommendedLocationsDialog extends StatefulWidget {
  final double long;
  final double lat;

  const RecommendedLocationsDialog({Key key, this.long, this.lat})
      : super(key: key);

  @override
  _RecommendedLocationsDialogState createState() =>
      _RecommendedLocationsDialogState();
}

class _RecommendedLocationsDialogState
    extends State<RecommendedLocationsDialog> {
  Client client;
  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};
  Future<List<RecommendedLocation>> _recommendedLocations;
  List<Dog> _selectedDogs;
  List<dynamic> _markerAndDogs = [];

  @override
  void initState() {
    setState(() {
      _recommendedLocations = _fetchRecommendedLocations();
    });
    super.initState();
  }

  Future<List<RecommendedLocation>> _fetchRecommendedLocations() async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);
    final authority = 'doggo-service.herokuapp.com';
    final path = '/api/dog-lover/location-recommendations';
    final queryParameters = {
      'dogLoverLongitude': '${widget.long}',
      'dogLoverLatitude': '${widget.lat}'
    };

    final url = Uri.https(authority, path, queryParameters);
    final response = await client.get(url, headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse
          .map((recLocation) => RecommendedLocation.fromJson(recLocation))
          .toList();
    } else {
      DoggoToast.of(context).showToast('ERROR: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SimpleDialog(
      title: Text("Recommended Locations", style: TextStyle(fontSize: 18)),
      children: [
        SingleChildScrollView(
          child: FutureBuilder<List<RecommendedLocation>>(
              future: _recommendedLocations,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<RecommendedLocation> locations = snapshot.data;
                  return Container(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: locations.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      Icons.location_pin,
                                      color: Colors.orangeAccent,
                                    ),
                                    title: Text(
                                      locations[index].marker.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                        locations[index].marker.description),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                          'Distance: ${locations[index].marker.distanceInMeters}m'
                                      ),
                                      FlatButton(
                                        onPressed: () async {
                                          _selectedDogs = await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return ChooseDogDialog();
                                              });
                                          _markerAndDogs.add(locations[index].marker);
                                          _markerAndDogs.add(_selectedDogs);
                                          Navigator.of(context).pop(_markerAndDogs);
                                        },
                                        color: Colors.orangeAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0)
                                        ),
                                        child: Text(
                                          'Navigate',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ExpansionTile(
                                    title: Text(
                                      "\tPeople In ${locations[index].marker.name}",
                                    ),
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: locations[index].usersanddogs.length,
                                        itemBuilder: (context, index2) {
                                          return ExpansionTile(
                                            leading: Icon(
                                              Icons.account_circle,
                                              color: Colors.orangeAccent,
                                            ),
                                            title: Text(
                                              locations[index].usersanddogs[index2].nickname,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15
                                              ),
                                            ),
                                            subtitle: Text(
                                              locations[index].usersanddogs[index2].name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14
                                              ),
                                            ),
                                            children: [
                                              ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: locations[index].usersanddogs[index2].dogs.length,
                                                itemBuilder: (context, index3) {
                                                  return ListTile(
                                                    contentPadding: EdgeInsets.symmetric(
                                                      vertical: screenHeight*0.005,
                                                      horizontal: screenWidth*0.15
                                                    ),
                                                    leading: Icon(
                                                      Icons.pets,
                                                      color: Colors.orangeAccent,
                                                    ),
                                                    title: Text(
                                                        locations[index].usersanddogs[index2].dogs[index3].name,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 14
                                                        ),
                                                    ),
                                                    subtitle: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          locations[index].usersanddogs[index2].dogs[index3].breed,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w300,
                                                              fontSize: 12
                                                          ),
                                                        ),
                                                        Text(
                                                          locations[index].usersanddogs[index2].dogs[index3].color,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w300,
                                                              fontSize: 12
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              )
                                            ],
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.orange,
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.hasError}");
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.orangeAccent,
                    ),
                  );
                }
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1,
                        vertical: screenHeight * 0.1),
                    child: Text(
                      "Failed to load recommended locations.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
