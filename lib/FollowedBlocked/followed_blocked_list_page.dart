import 'package:doggo_frontend/Dog/http/dog_data.dart';
import 'package:doggo_frontend/FollowedBlocked/http/dog_lover_data.dart';
import 'package:doggo_frontend/User/http/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oauth2/oauth2.dart';

class _FollowedBlockedListPageState extends State<FollowedBlockedListPage> {
  Client client;

  List<DogLover> _dogLovers = [
    DogLover(
      user: User(firstName: 'Michu', lastName: 'Najbo', age: 23, hobby: 'Dogs'),
      dogs: [
        Dog(
            name: 'Tina',
            breed: 'Jamnik',
            color: 'Black',
            description: 'Likes sniffing',
            vaccinationDate: DateTime.now()),
        Dog(
            name: 'Max',
            breed: 'Labladol',
            color: 'White',
            description: 'Likes pooping',
            vaccinationDate: DateTime.now()),
        Dog(
            name: 'George',
            breed: 'Mops',
            color: 'Brown',
            description: 'Likes eating',
            vaccinationDate: DateTime.now()),
      ],
      status: DogLoverStatus.FOLLOWED,
    ),
    DogLover(
      user:
      User(firstName: 'Adziu', lastName: 'Glapi', age: 23, hobby: 'Soccer'),
      dogs: [
        Dog(
            name: 'Rex',
            breed: 'Owczarek',
            color: 'Black-yellow',
            description: 'Likes barking',
            vaccinationDate: DateTime.now()),
        Dog(
            name: 'Edek',
            breed: 'Chiwaua',
            color: 'Yellow',
            description: 'Likes peeing',
            vaccinationDate: DateTime.now()),
      ],
      status: DogLoverStatus.FOLLOWED,
    ),
    DogLover(
      user: User(
          firstName: 'Solid', lastName: 'Martha', age: 23, hobby: 'Soccer'),
      dogs: [
        Dog(
            name: 'Kora',
            breed: 'Pudel',
            color: 'Silver',
            description: 'Likes being seen',
            vaccinationDate: DateTime.now()),
      ],
      status: DogLoverStatus.BLOCKED,
    ),
  ];

  List<DogLover> _fetchDogLovers() {
    return _dogLovers;
  }

  Row _createTypeDivider(DogLoverStatus type, double screenWidth) {
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
      type == DogLoverStatus.FOLLOWED ?
      Text('FOLLOWED',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
          : Text('BLOCKED',
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

  Card _createFollowedBlockedCard(int userIndex, double screenHeight,
      double screenWidth) {
    return Card(
      child: ExpansionTile(
          title: Text(
            '${_dogLovers[userIndex].user.firstName} ${_dogLovers[userIndex].user.lastName}',
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: screenHeight * 0.035),
          ),
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _dogLovers[userIndex].dogs.length,
              itemBuilder: (context, dogIndex) {
                return Card(
                  child: ListTile(
                    title: Text(
                      _dogLovers[userIndex].dogs[dogIndex].name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: screenHeight * 0.025,
                      ),
                    ),
                    subtitle: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "Breed: ${_dogLovers[userIndex].dogs[dogIndex]
                                  .breed}"),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "Color: ${_dogLovers[userIndex].dogs[dogIndex]
                                  .color}"),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "Description: ${_dogLovers[userIndex]
                                  .dogs[dogIndex].description}"),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "Last vaccination date: ${DateFormat("dd-MM-yyy")
                                  .format(_dogLovers[userIndex].dogs[dogIndex]
                                  .vaccinationDate)}"),
                        )
                      ],
                    ),
                    leading: Icon(
                      Icons.pets,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  elevation: 5,
                );
              },
            )
          ]),
      elevation: 5,
    );
  }

  bool _hasStatusChanged(int userIndex) {
    return _dogLovers[userIndex - 1].status == DogLoverStatus.FOLLOWED &&
        _dogLovers[userIndex].status == DogLoverStatus.BLOCKED;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Followed and Blocked'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orangeAccent,
        splashColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: _dogLovers.length,
        itemBuilder: (context, userIndex) {
          if (userIndex == 0)
            return Column(
              children: [
                _createTypeDivider(DogLoverStatus.FOLLOWED, screenWidth),
                _createFollowedBlockedCard(userIndex, screenHeight, screenWidth)
              ],
            );
          else if (_hasStatusChanged(userIndex))
            return Column(
              children: [
                _createTypeDivider(DogLoverStatus.BLOCKED, screenWidth),
                _createFollowedBlockedCard(userIndex, screenHeight, screenWidth)
              ],
            );
          else
            return _createFollowedBlockedCard(
                userIndex, screenHeight, screenWidth);
        },
      ),
    );
  }
}

class FollowedBlockedListPage extends StatefulWidget {
  @override
  _FollowedBlockedListPageState createState() =>
      _FollowedBlockedListPageState();
}
