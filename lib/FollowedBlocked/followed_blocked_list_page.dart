import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:doggo_frontend/Custom/doggo_toast.dart';
import 'package:doggo_frontend/FollowedBlocked/add_followed_blocked_page.dart';
import 'package:doggo_frontend/FollowedBlocked/http/dog_lover_data.dart';
import 'package:doggo_frontend/OAuth2/oauth2_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart';

class _FollowedBlockedListPageState extends State<FollowedBlockedListPage> {
  Client client;
  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};

  Future<List<DogLover>> _followedBlocked;

  @override
  void initState() {
    setState(() {
      _followedBlocked = _fetchFollowedBlocked();
    });
    super.initState();
  }

  Future<List<DogLover>> _fetchFollowedBlocked() async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);
    final url =
        'https://doggo-service.herokuapp.com/api/dog-lover/relationships';

    final response = await client.get(url, headers: headers);
    if (response.statusCode == 200) {
      List jsonList = jsonDecode(utf8.decode(response.bodyBytes));
      List<DogLover> followedBlocked =
          jsonList.map((e) => DogLover.fromFollowedBlockedJson(e)).toList();
      followedBlocked.sort((a, b) => a.status.index.compareTo(b.status.index));
      return followedBlocked;
    } else {
      DoggoToast.of(context)
          .showToast('Could not fetch FOLLOWED/BLOCKED list.');
      return Future.error('Could not fetch FOLLOWED/BLOCKED list.');
    }
  }

  Future _removeFollowedBlocked(String nickname) async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);
    final url =
        'https://doggo-service.herokuapp.com/api/dog-lover/relationships/$nickname';

    final response = await client.delete(url, headers: headers);
    switch (response.statusCode) {
      case 200:
        {
          setState(() {
            _followedBlocked = _fetchFollowedBlocked();
          });
          break;
        }
      case 404:
        {
          DoggoToast.of(context)
              .showToast('Person with given nickname doesn\'t exist.');
          break;
        }
      default:
        {
          DoggoToast.of(context)
              .showToast('Couldn\'t remove person from FOLLOWED or BLOCKED.');
          break;
        }
    }
  }

  Row _createTypeDivider(RelationStatus type, double screenWidth) {
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
      type == RelationStatus.FOLLOWED
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

  Card _createFollowedBlockedCard(List<DogLover> followedBlocked, int userIndex,
      double screenHeight, double screenWidth) {

    followedBlocked.sort((a, b) => a.status.index.compareTo(b.status.index));
    followedBlocked.forEach((element) => element.dogs.sort((a, b) => a.name.compareTo(b.name)));

    return Card(
      child: Dismissible(
        background: Stack(
          children: [
            Container(color: Colors.redAccent),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.05),
                child: Icon(
                  Icons.delete,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
        direction: DismissDirection.endToStart,
        key: ValueKey(followedBlocked[userIndex]),
        onDismissed: (direction) {
          _removeFollowedBlocked(followedBlocked[userIndex].user.nickname);
          followedBlocked.removeAt(userIndex);
        },
        child: ExpansionTile(
          title: Text(
            followedBlocked[userIndex].user.nickname,
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
                      ],
                    ),
                    leading: FutureBuilder<Uint8List>(
                      future: _fetchDogAvatar(
                          followedBlocked[userIndex].dogs[dogIndex].id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Uint8List bytes = snapshot.data;
                          return CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.memory(
                                  bytes,
                                  key: ValueKey(bytes.lengthInBytes),
                                  width: screenHeight * 0.18,
                                  height: screenHeight * 0.18,
                                  fit: BoxFit.fitHeight,
                                ),
                              ));
                        } else {
                          return Icon(Icons.pets, color: Colors.orangeAccent);
                        }
                      },
                    ),
                  ),
                  elevation: 5,
                );
              },
            )
          ],
          leading: FutureBuilder<Uint8List>(
            future: _fetchUserAvatar(followedBlocked[userIndex].user.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Uint8List bytes = snapshot.data;
                return CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.memory(
                        bytes,
                        key: ValueKey(bytes.lengthInBytes),
                        width: screenHeight * 0.18,
                        height: screenHeight * 0.18,
                        fit: BoxFit.fitHeight,
                      ),
                    ));
              } else {
                return Icon(Icons.account_circle, color: Colors.orangeAccent);
              }
            },
          ),
        ),
      ),
      elevation: 5,
    );
  }

  bool _isFollowedSection(List<DogLover> followedBlocked, int userIndex) {
    return userIndex == 0 &&
        followedBlocked[userIndex].status == RelationStatus.FOLLOWED;
  }

  bool _isBlockedSection(List<DogLover> followedBlocked, int userIndex) {
    return userIndex == 0 &&
            followedBlocked[userIndex].status == RelationStatus.BLOCKED ||
        (followedBlocked[userIndex - 1].status == RelationStatus.FOLLOWED &&
            followedBlocked[userIndex].status == RelationStatus.BLOCKED);
  }

  Future<Uint8List> _fetchUserAvatar(String id) async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);
    final url =
        'https://doggo-service.herokuapp.com/api/dog-lover/profiles/$id/avatar';

    final response = await client.get(url, headers: headers);
    switch (response.statusCode) {
      case 200:
        {
          return response.bodyBytes;
        }
      case 404:
        {
          break;
        }
      default:
        {
          DoggoToast.of(context)
              .showToast('Couldn\'t load user (id: $id) avatar.');
          break;
        }
    }
  }

  Future<Uint8List> _fetchDogAvatar(String id) async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);
    final url =
        'https://doggo-service.herokuapp.com/api/dog-lover/dogs/$id/avatar';

    final response = await client.get(url, headers: headers);
    switch (response.statusCode) {
      case 200:
        {
          return response.bodyBytes;
        }
      case 404:
        {
          break;
        }
      default:
        {
          DoggoToast.of(context).showToast('Couldn\'t load dog avatar.');
          break;
        }
    }
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
          heroTag: "btn3",
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => AddFollowedBlockedPage()))
                .whenComplete(() => {
                      setState(() {
                        _followedBlocked = _fetchFollowedBlocked();
                      })
                    });
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
              if (followedBlocked.isNotEmpty) {
                return ListView.builder(
                  itemCount: followedBlocked.length,
                  itemBuilder: (context, userIndex) {
                    if (_isFollowedSection(followedBlocked, userIndex))
                      return Column(
                        children: [
                          _createTypeDivider(
                              RelationStatus.FOLLOWED, screenWidth),
                          _createFollowedBlockedCard(followedBlocked, userIndex,
                              screenHeight, screenWidth)
                        ],
                      );
                    else if (_isBlockedSection(followedBlocked, userIndex))
                      return Column(
                        children: [
                          _createTypeDivider(
                              RelationStatus.BLOCKED, screenWidth),
                          _createFollowedBlockedCard(followedBlocked, userIndex,
                              screenHeight, screenWidth)
                        ],
                      );
                    else
                      return _createFollowedBlockedCard(followedBlocked,
                          userIndex, screenHeight, screenWidth);
                  },
                );
              }
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
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
              child: Text('You don\'t follow nor block anyone yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight * 0.04)),
            ));
          },
        ));
  }
}

class FollowedBlockedListPage extends StatefulWidget {
  @override
  _FollowedBlockedListPageState createState() =>
      _FollowedBlockedListPageState();
}
