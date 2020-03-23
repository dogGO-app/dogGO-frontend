import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:doggo_frontend/UserProfile/dog_data.dart';
import 'package:doggo_frontend/UserProfile/dog_card.dart';
import 'package:http/http.dart' as http;


class DogsList extends StatefulWidget {

  @override
  _DogsListState createState() => _DogsListState();
}

class _DogsListState extends State<DogsList> {
  List<Dog> dogs = List();

  Map data = {};

  Future getDogs() async {
    var url = 'https://doggo-app-server.herokuapp.com/api/dogs';
    var headers = {'Content-Type': 'application/json', 'Accept': '*/*', 'Authorization': 'Bearer ${data['token']}'};

    final response = await http.get(url, headers: headers);
    if(response.statusCode == 200){
      return Dog.fromJson(json.decode(response.body));
    }

  }

  @override
  Widget build(BuildContext context) {
    
    data = ModalRoute.of(context).settings.arguments;
    getDogs();

    return Scaffold(
      appBar: AppBar(
        title: Text('Your dogs'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        children: dogs.map((dog) => DogCard(
          dog: dog,
        )).toList(),
      ),
    );
  }
}
