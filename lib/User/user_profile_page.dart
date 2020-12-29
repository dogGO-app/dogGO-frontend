import 'dart:convert';
import 'dart:io';

import 'package:doggo_frontend/Custom/doggo_toast.dart';
import 'package:doggo_frontend/OAuth2/oauth2_client.dart';
import 'package:doggo_frontend/User/edit_user_profile_page.dart';
import 'package:doggo_frontend/User/http/user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class _UserProfilePageState extends State<UserProfilePage> {
  Client client;
  final url = 'https://doggo-service.herokuapp.com/api/dog-lover/profiles';
  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};

  Future<User> _userDetails;

  AppState state;
  File _image;
  File _tempImage;
  final picker = ImagePicker();

  @override
  void initState() {
    _userDetails = fetchUserDetails();
    state = AppState.free;
    super.initState();
  }

  Future<User> fetchUserDetails() async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);

    final response = await client.get(url, headers: headers);
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 400)
      DoggoToast.of(context).showToast('Incorrect details format.');
    // TODO: log error
    else {
      DoggoToast.of(context).showToast('Could not fetch user details!');
      throw Exception("Could not fetch user details!");
    }
  }

  Future _getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        state = AppState.picked;
      } else {
        print('No image selected.');
      }
    });
  }

  Future _getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        state = AppState.picked;
      } else {
        print('No image selected.');
      }
    });
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        cropStyle: CropStyle.circle,
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    _tempImage = _image;
    _image = null;
    setState(() {
      state = AppState.free;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _getImageFromGallery().whenComplete(() => _cropImage());
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _getImageFromCamera().whenComplete(() => _cropImage());
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text('Your dogGO Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.05,
                    horizontal: screenWidth * 0.03),
                child: Column(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (state == AppState.cropped) {
                            _clearImage();
                          }
                          _showPicker(context);
                          if (_image == null) {
                            _image = _tempImage;
                            _tempImage = null;
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.grey[200],
                            child: _image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.file(
                                      _image,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: FutureBuilder<User>(
                        future: _userDetails,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            User user = snapshot.data;
                            return Column(
                              children: [
                                Center(
                                  child: Text(
                                    '@${user.nickname}',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Spacer(),
                                      Center(
                                        child: Text(
                                          '${user.firstName} ${user.lastName}',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FutureBuilder(
                                                    future: _userDetails,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return EditUserDataPage(
                                                          userData:
                                                              snapshot.data,
                                                        );
                                                      } else if (snapshot
                                                          .hasError) {
                                                        throw Exception(
                                                          "Couldn't acquire user data!",
                                                        );
                                                      } else {
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              )
                                              .whenComplete(() => {
                                                    setState(() {
                                                      _userDetails =
                                                          fetchUserDetails();
                                                    })
                                                  });
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.03,
                                    horizontal: screenWidth * 0.02
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.02),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(
                                              0, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            'You have',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orangeAccent,
                                                fontSize: 18),
                                          ),
                                          Icon(
                                            Icons.thumb_up_alt_outlined,
                                            color: Colors.orangeAccent,
                                            size: 48,
                                          ),
                                          Text(
                                            '${user.likes}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orangeAccent,
                                                fontSize: 48),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          } else {
                            return CircularProgressIndicator(
                                backgroundColor: Colors.orangeAccent);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              Center(
                child: MaterialButton(
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamedAndRemoveUntil(
                            '/home', (Route<dynamic> route) => false);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orangeAccent,
                            Color.fromRGBO(200, 100, 20, .4)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Logout",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

enum AppState {
  free,
  picked,
  cropped,
}
