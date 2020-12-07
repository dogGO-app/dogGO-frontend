import 'dart:convert';

import 'package:doggo_frontend/Custom/doggo_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doggo_frontend/OAuth2/oauth2_client.dart';
import 'package:oauth2/oauth2.dart';
import 'package:doggo_frontend/Dog/http/dog_data.dart';


class ChooseDogDialog extends StatefulWidget {
  @override
  _ChooseDogDialogState createState() => _ChooseDogDialogState();
}

class _ChooseDogDialogState extends State<ChooseDogDialog> {
  Client client;
  final url = 'https://doggo-service.herokuapp.com/api/dog-lover/dogs';
  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};
  Future<List<Dog>> _dogs;
  List<Dog> _selectedDogs = [];

  @override
  void initState() {
    setState(() {
      _dogs = _fetchDogs();
    });
    super.initState();
  }

  Future<List<Dog>> _fetchDogs() async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);

    final response = await client.get(url, headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((dog) => Dog.fromJson(dog)).toList();
    } else {
      DoggoToast.of(context).showToast('Failed to load dogs.');
      throw Exception('Failed to load dogs from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double buttonWidth = screenWidth * 0.08;
    double buttonHeight = screenHeight * 0.02;

    return SimpleDialog(
        title: Text('Choose your buddies:'),
        children: [
          FutureBuilder<List<Dog>>(
            future: _dogs,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Dog> dogs = snapshot.data;
                return Container(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: dogs.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            value: _selectedDogs.contains(dogs[index]),
                            controlAffinity: ListTileControlAffinity.trailing,
                            title: Text(
                              dogs[index].name,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18
                              ),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  dogs[index].breed
                                ),
                                Text(
                                  dogs[index].color
                                )
                              ],
                            ),
                            checkColor: Colors.white,
                            activeColor: Colors.orange,
                            secondary: Icon(
                                Icons.pets,
                                color: Colors.orangeAccent
                            ),
                            onChanged: (bool value) {
                              if (value) {
                                if(!_selectedDogs.contains(dogs[index])){
                                  setState(() {
                                    _selectedDogs.add(dogs[index]);
                                  });
                                }
                              } else {
                                if(_selectedDogs.contains(dogs[index])){
                                  setState(() {
                                    _selectedDogs.remove(dogs[index]);
                                  });
                                }
                              }
                            },
                          );
                        }
                      ),
                      Divider(),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)
                        ),
                        color: Colors.orangeAccent,
                        padding: EdgeInsets.symmetric(
                          vertical: buttonHeight,
                          horizontal: buttonWidth
                        ),
                        child: Text(
                          "Let's go!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                          ),
                        ),
                        onPressed: () {
                          if(_selectedDogs.isEmpty){
                            DoggoToast.of(context)
                                .showToast('Select at least ONE dog');
                          } else {
                            Navigator.pop(context, _selectedDogs);
                          }
                        },
                      )
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
                    horizontal: screenWidth*0.1,
                    vertical: screenHeight*0.1
                  ),
                  child: Text(
                    "Failed to load your dogs.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                ),
              );
            }
          ),
        ],
    );
  }
}
