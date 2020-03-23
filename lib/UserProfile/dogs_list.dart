import 'package:flutter/material.dart';
import 'package:doggo_frontend/UserProfile/dog_data.dart';
import 'package:doggo_frontend/UserProfile/dog_card.dart';

class DogsList extends StatelessWidget {

  final List<Dog> dogs = [
    Dog(name: 'Burek', breed: 'Husky', color: 'biały', description: 'piesek', vaccinationDate: DateTime.utc(2020,01,01)),
    Dog(name: 'Azor', breed: 'Jakikolwiek', color: 'czarny', description: 'piesek drugi', vaccinationDate: DateTime.utc(2019,12,12)),
  ];

  @override
  Widget build(BuildContext context) {
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
