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
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class _UserProfilePageState extends State<UserProfilePage> {
  Client client;
  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};
  Directory _userAvatarDirectory;

  Future<User> _userDetails;
  String _userId;

  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    _initDocumentsDirectory();
    _userDetails = fetchUserDetails();
    super.initState();
  }

  void _initDocumentsDirectory() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    _userAvatarDirectory = Directory('${documentsDirectory.path}/user_avatar');
    if (!_userAvatarDirectory.existsSync()) {
      _userAvatarDirectory = await _userAvatarDirectory.create(recursive: true);
    }
  }

  Future<User> fetchUserDetails() async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);
    final url = 'https://doggo-service.herokuapp.com/api/dog-lover/profiles';

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

  void _sendAvatar() async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);
    final url =
        'https://doggo-service.herokuapp.com/api/dog-lover/profiles/avatar';
    final uri = Uri.parse(url);

    final request = http.MultipartRequest('PUT', uri)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath(
          'avatar', '${_userAvatarDirectory.path}/$_userId.jpg'));

    final response = await client.send(request);
    switch (response.statusCode) {
      case 200:
        {
          break;
        }
      case 400:
        {
          DoggoToast.of(context)
              .showToast('Avatar image is not a correct image.');
          break;
        }
      case 404:
        {
          DoggoToast.of(context).showToast('User not found.');
          break;
        }
      default:
        {
          DoggoToast.of(context).showToast('Couldn\'t send user avatar.');
          break;
        }
    }
  }

  void _fetchAvatar() async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);
    final url =
        'https://doggo-service.herokuapp.com/api/dog-lover/profiles/$_userId/avatar';

    final response = await client.get(url, headers: headers);
    switch (response.statusCode) {
      case 200: {
        File('${_userAvatarDirectory.path}/$_userId.jpg')
            .writeAsBytesSync(response.bodyBytes);
        setState(() {
          imageCache.clear();
          imageCache.clearLiveImages();
          _image = File('${_userAvatarDirectory.path}/$_userId.jpg');
        });
        break;
      }
      case 404: {
        DoggoToast.of(context).showToast('User or user\'s avatar not found.');
        break;
      }
      default: {
        DoggoToast.of(context).showToast('Couldn\'t load user avatar.');
        break;
      }
    }
  }

  void _saveAvatar() async {
    File newImage = await _image.copy(
        '${_userAvatarDirectory.path}/$_userId.jpg');
    setState(() {
      imageCache.clear();
      imageCache.clearLiveImages();
      _image = newImage;
    });
    _sendAvatar();
  }

  void _setAvatar(bool avatarInDatabase) {
    _image = File('${_userAvatarDirectory.path}/$_userId.jpg');
    if (!_image.existsSync() && avatarInDatabase) {
      _fetchAvatar();
    }
  }

  Future _getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future _getImageFromGallery() async {
    final pickedFile =
    await picker.getImage(source: ImageSource.gallery, imageQuality: 90);

    setState(() {
      if (pickedFile != null) {
        imageCache.clear();
        imageCache.clearLiveImages();
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        maxWidth: 500,
        maxHeight: 500,
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
      setState(() {
        imageCache.clear();
        imageCache.clearLiveImages();
        _image = croppedFile;
      });
    }
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
                        _getImageFromGallery().whenComplete(() =>
                            _cropImage().whenComplete(() => _saveAvatar()));
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _getImageFromCamera().whenComplete(
                              () => _cropImage()).whenComplete(() =>
                          _saveAvatar());
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
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

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
                      child: FutureBuilder<User>(
                        future: _userDetails,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            User user = snapshot.data;
                            _userId = user.id;
                            _setAvatar(user.avatarChecksum != null);
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showPicker(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: screenHeight * 0.02),
                                    child: CircleAvatar(
                                      radius: screenHeight * 0.1,
                                      backgroundColor: Colors.grey[200],
                                      child: _image.existsSync()
                                          ? ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(
                                            screenHeight * 0.9),
                                        child: Image.file(
                                          _image,
                                          key: ValueKey(_image.lengthSync()),
                                          width: screenHeight * 0.18,
                                          height: screenHeight * 0.18,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      )
                                          : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                            BorderRadius.circular(
                                                screenHeight * 0.9)),
                                        width: screenHeight * 0.18,
                                        height: screenHeight * 0.18,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                                              .whenComplete(() =>
                                          {
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
                                      vertical: screenHeight * 0.02,
                                      horizontal: screenWidth * 0.02),
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
                                          offset: Offset(0,
                                              3), // changes position of shadow
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
              Center(
                child: MaterialButton(
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamedAndRemoveUntil(
                        '/home', (Route<dynamic> route) => false);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
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

enum ImageState {
  free,
  picked,
  cropped,
}
