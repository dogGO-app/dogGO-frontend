import 'dart:convert';

import 'package:doggo_frontend/Custom/doggo_toast.dart';
import 'package:doggo_frontend/FollowedBlocked/http/dog_lover_data.dart';
import 'package:doggo_frontend/OAuth2/oauth2_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oauth2/oauth2.dart';

class _FollowedBlockedListPageState extends State<FollowedBlockedListPage> {
  Client client;
  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};

  Future<List<DogLover>> _followedBlocked;

  // List<DogLover> _followedBlocked = [
  //   DogLover(
  //     user: User(firstName: 'Michu', lastName: 'Najbo', age: 23, hobby: 'Dogs'),
  //     dogs: [
  //       Dog(
  //           name: 'Tina',
  //           breed: 'Jamnik',
  //           color: 'Black',
  //           description: 'Likes sniffing',
  //           vaccinationDate: DateTime.now()),
  //       Dog(
  //           name: 'Max',
  //           breed: 'Labladol',
  //           color: 'White',
  //           description: 'Likes pooping',
  //           vaccinationDate: DateTime.now()),
  //       Dog(
  //           name: 'George',
  //           breed: 'Mops',
  //           color: 'Brown',
  //           description: 'Likes eating',
  //           vaccinationDate: DateTime.now()),
  //     ],
  //     status: DogLoverStatus.FOLLOWED,
  //   ),
  //   DogLover(
  //     user:
  //         User(firstName: 'Adziu', lastName: 'Glapi', age: 23, hobby: 'Soccer'),
  //     dogs: [
  //       Dog(
  //           name: 'Rex',
  //           breed: 'Owczarek',
  //           color: 'Black-yellow',
  //           description: 'Likes barking',
  //           vaccinationDate: DateTime.now()),
  //       Dog(
  //           name: 'Edek',
  //           breed: 'Chiwaua',
  //           color: 'Yellow',
  //           description: 'Likes peeing',
  //           vaccinationDate: DateTime.now()),
  //     ],
  //     status: DogLoverStatus.FOLLOWED,
  //   ),
  //   DogLover(
  //     user: User(
  //         firstName: 'Solid', lastName: 'Martha', age: 23, hobby: 'Soccer'),
  //     dogs: [
  //       Dog(
  //           name: 'Kora',
  //           breed: 'Pudel',
  //           color: 'Silver',
  //           description: 'Likes being seen',
  //           vaccinationDate: DateTime.now()),
  //     ],
  //     status: DogLoverStatus.BLOCKED,
  //   ),
  // ];

  @override
  void initState() {
    setState(() {
      _followedBlocked = _fetchFollowedBlocked();
    });
    super.initState();
  }

  Future<List<DogLover>> _fetchFollowedBlocked() async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);
    final url = 'https://doggo-service.herokuapp.com/api/dog-lover/relationships';

    final response = await client.get(url, headers: headers);
    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      return jsonList.map((e) => DogLover.fromJson(e)).toList();
    } else {
      DoggoToast.of(context).showToast('Could not fetch FOLLOWED/BLOCKED list.');
    }
  }

  Future _removeFollowedBlocked(String nickname) async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);
    final url =
        'https://doggo-service.herokuapp.com/api/dog-lover/relationships/$nickname';

    final response = await client.delete(url, headers: headers);
    switch (response.statusCode) {
      case 200: {
        setState(() {
          _followedBlocked = _fetchFollowedBlocked();
        });
        break;
      }
      case 404: {
        DoggoToast.of(context).showToast('Person with given nickname doesn\'t exist.');
        break;
      }
      default: {
        DoggoToast.of(context).showToast('Could remove person from FOLLOWED or BLOCKED.');
        break;
      }
    }
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
      type == DogLoverStatus.FOLLOWED
          ? Text('FOLLOWED',
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

  Card _createFollowedBlockedCard(
      List<DogLover> followedBlocked, int userIndex, double screenHeight, double screenWidth) {
    return Card(
      child: Dismissible(
        background: Container(color: Colors.redAccent),
        direction: DismissDirection.endToStart,
        key: ValueKey(followedBlocked[userIndex]),
        onDismissed: (direction) {
          _removeFollowedBlocked(followedBlocked[userIndex].user.nickname);
        },
        child: ExpansionTile(
            title: Text(
              '${followedBlocked[userIndex].user.firstName} ${followedBlocked[userIndex].user.lastName}',
              style: TextStyle(
                  fontWeight: FontWeight.w500, fontSize: screenHeight * 0.035),
            ),
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: followedBlocked[userIndex].dogs.length,
                itemBuilder: (context, dogIndex) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        followedBlocked[userIndex].dogs[dogIndex].name,
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
                                "Breed: ${followedBlocked[userIndex].dogs[dogIndex].breed}"),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                "Color: ${followedBlocked[userIndex].dogs[dogIndex].color}"),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                "Description: ${followedBlocked[userIndex].dogs[dogIndex].description}"),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                "Last vaccination date: ${DateFormat("dd-MM-yyy").format(followedBlocked[userIndex].dogs[dogIndex].vaccinationDate)}"),
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
      ),
      elevation: 5,
    );
  }

  bool _hasStatusChanged(List<DogLover> followedBlocked, int userIndex) {
    return followedBlocked[userIndex - 1].status == DogLoverStatus.FOLLOWED &&
        followedBlocked[userIndex].status == DogLoverStatus.BLOCKED;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Followed and Blocked'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/addfollowedblocked');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orangeAccent,
        splashColor: Colors.orange,
      ),
      body: FutureBuilder<List<DogLover>>(
        future: _followedBlocked,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DogLover> followedBlocked = snapshot.data;
            return ListView.builder(
              itemCount: followedBlocked.length,
              itemBuilder: (context, userIndex) {
                if (userIndex == 0)
                  return Column(
                    children: [
                      _createTypeDivider(DogLoverStatus.FOLLOWED, screenWidth),
                      _createFollowedBlockedCard(followedBlocked, userIndex, screenHeight, screenWidth)
                    ],
                  );
                else if (_hasStatusChanged(followedBlocked, userIndex))
                  return Column(
                    children: [
                      _createTypeDivider(DogLoverStatus.BLOCKED, screenWidth),
                      _createFollowedBlockedCard(followedBlocked, userIndex, screenHeight, screenWidth)
                    ],
                  );
                else
                  return _createFollowedBlockedCard(
                     followedBlocked, userIndex, screenHeight, screenWidth);
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.orangeAccent,
            )
          );
        },
      )
    );
  }
}

class FollowedBlockedListPage extends StatefulWidget {
  @override
  _FollowedBlockedListPageState createState() =>
      _FollowedBlockedListPageState();
}
