import 'package:doggo_frontend/dog/http/dog_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DogCard extends StatelessWidget {
  final Dog dog;
  DogCard({this.dog});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/editdogdata');
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'DOG NAME: ',
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    dog.name,
                    style: TextStyle(
                      letterSpacing: 0.5,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'DOG BREED: ',
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    dog.breed,
                    style: TextStyle(
                      letterSpacing: 0.5,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'DOG COLOR: ',
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    dog.color,
                    style: TextStyle(
                      letterSpacing: 0.5,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'DOG DESCRIPTION: ',
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    dog.description,
                    style: TextStyle(
                      letterSpacing: 0.5,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'LAST VACCINATION DATE: ',
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    dog.vaccinationDate.toString().substring(0, 10),
                    style: TextStyle(
                      letterSpacing: 0.5,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
