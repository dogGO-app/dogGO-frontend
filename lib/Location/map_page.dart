import 'dart:async';
import 'dart:convert';

import 'package:doggo_frontend/Custom/doggo_toast.dart';
import 'package:doggo_frontend/Dog/http/dog_data.dart';
import 'package:doggo_frontend/Location/add_location_bottom_sheet_widget.dart';
import 'package:doggo_frontend/Location/choose_dogs_dialog_widget.dart';
import 'package:doggo_frontend/Location/http/location.dart';
import 'package:doggo_frontend/Location/people_in_location_page.dart';
import 'package:doggo_frontend/OAuth2/oauth2_client.dart';
import 'package:doggo_frontend/User/http/user_data.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:oauth2/oauth2.dart';
import 'package:doggo_frontend/Location/recommended_locations_dialog_widget.dart';
import 'fdto/UserLiked.dart';
import 'http/useranddogs.dart';

const double _cameraZoom = 16;

class _MapPageState extends State<MapPage> {
  Client client;
  final url = 'https://doggo-service.herokuapp.com/api/dog-lover/map-markers';
  final walkUrl = 'https://doggo-service.herokuapp.com/api/dog-lover/walks';
  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};

  GoogleMapController mapController;
  LocationData _currentLocation;
  LocationData _previousLocation;
  Location _location;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  CameraPosition _center;
  bool _isLoading = false;
  bool _isNavigating = false;
  bool _nearLocation = false;
  bool _flushbarAtLocationAppeared = false;
  bool _leavingLocation = false;
  String _currentLocationName = "";
  String _currentLocationId = "";
  LatLng _destination;
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  List<Dog> _selectedDogs;
  List<dynamic> _recommended;
  String _walkId;
  String _uid;
  var _walkStatus;
  List<UserLiked> _usersLiked = [];

  Timer _walkTimer;

  String googleApiKey = "AIzaSyAOEF4ZeRSes_MnWz1XCMu5tay_ob5KdUU";

  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    _location = new Location();
    _getLocation();

    _location.onLocationChanged.listen((LocationData currentLocation) {
      _previousLocation = _currentLocation;
      _currentLocation = currentLocation;

      if (_isNavigating &&
          ((_previousLocation.latitude - _currentLocation.latitude).abs() >
                  0.00002 ||
              (_previousLocation.longitude - _currentLocation.longitude).abs() >
                  0.00002) &&
          _destination != null) {
        double latDistance =
            (_destination.latitude - _currentLocation.latitude).abs();
        double lngDistance =
            (_destination.longitude - _currentLocation.longitude).abs();

        _animateCameraToLocation(
            LatLng(_currentLocation.latitude, _currentLocation.longitude));

        if (latDistance < 0.0004 || lngDistance < 0.0004) {
          _atLocation();
        } else if ((latDistance >= 0.0004 || lngDistance >= 0.0004) &&
            _nearLocation) {
          _awayFromLocation();
        } else {
          _clearPolylines();
          _setPolylines(_destination);
        }
      }
    });

    _walkTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if ((_walkStatus == WalkStatus.ONGOING || _walkStatus == WalkStatus.ARRIVED_AT_DESTINATION) && _walkId != null) {
        _refreshWalk();
      }
    });
  }

  void _getLocation() async {
    setState(() {
      _isLoading = true;
    });
    initialize();
    _currentLocation = await _location.getLocation();
    if (_currentLocation == null) {
      return;
    }
    _center = CameraPosition(
      target: LatLng(_currentLocation.latitude, _currentLocation.longitude),
      zoom: _cameraZoom,
    );

    setState(() {
      _isLoading = false;
    });

    mapController.moveCamera(CameraUpdate.newLatLng(
        LatLng(_currentLocation.latitude, _currentLocation.longitude)));
  }

  Future<void> initialize() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    await _showMarkersOnMap();
  }

  Future<List<LocationMarker>> _fetchLocationMarkers() async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);

    final response = await client.get(url, headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse
          .map((location) => LocationMarker.fromJson(location))
          .toList();
    } else {
      DoggoToast.of(context).showToast('Failed to load location markers data.');
      throw Exception('Failed to load location markers data from API');
    }
  }

  Future _fetchUserId() async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);
    String profileUrl =
        'https://doggo-service.herokuapp.com/api/dog-lover/profiles';
    final response = await client.get(profileUrl, headers: headers);
    if (response.statusCode == 200) {
      User currentUser = User.fromJsonWalkVersion(jsonDecode(utf8.decode((response.bodyBytes))));
      _uid = currentUser.id;
    } else {
      DoggoToast.of(context).showToast('Couldn\'t fetch current user data');
    }
  }

  Future<void> _showMarkersOnMap() async {
    final locationMarkers = await _fetchLocationMarkers();
    locationMarkers.forEach((locationMarker) {
      final marker = Marker(
        markerId: MarkerId(locationMarker.id),
        position: LatLng(locationMarker.latitude, locationMarker.longitude),
        onTap: () {
          _currentLocationName = locationMarker.name;
          _currentLocationId = locationMarker.id;
          showModalBottomSheet(
              context: context,
              barrierColor: Colors.black12,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return Container(
                  height: 200,
                  margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 175,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: Colors.black12,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                locationMarker.name ?? "",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(locationMarker.description ?? ""),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            MaterialButton(
                              onPressed: () async {
                                _selectedDogs = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ChooseDogDialog();
                                    });
                                _startWalk();
                                _navigationOn();
                                _clearPolylines();
                                _setPolylines(LatLng(locationMarker.latitude,
                                    locationMarker.longitude));
                                Navigator.of(context).pop();
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
                                  constraints: BoxConstraints(
                                      maxWidth: 300.0, minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Navigate",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              });
        },
      );
      setState(() {
        _markers.putIfAbsent(marker.markerId, () => marker);
      });
    });
  }

  void addMarkerToMap(LocationMarker locationMarker) {
    final markerId = MarkerId(locationMarker.id);
    final latLng = LatLng(locationMarker.latitude, locationMarker.longitude);
    final marker = Marker(
      markerId: markerId,
      position: latLng,
      onTap: () {
        showModalBottomSheet(
            context: context,
            barrierColor: Colors.black12,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return Container(
                height: 200,
                margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 175,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.black12,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              locationMarker.name ?? "",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(locationMarker.description ?? ""),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MaterialButton(
                            onPressed: () {
                              _navigationOn();
                              _clearPolylines();
                              _setPolylines(LatLng(locationMarker.latitude,
                                  locationMarker.longitude));
                              Navigator.of(context).pop();
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
                                constraints: BoxConstraints(
                                    maxWidth: 300.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Navigate",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            });
      },
    );

    setState(() {
      _markers.putIfAbsent(markerId, () => marker);
    });
  }

  _setPolylines(LatLng destination) async {
    _destination = destination;

    PolylineResult result = await polylinePoints?.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(_currentLocation.latitude, _currentLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Colors.orangeAccent,
          points: _polylineCoordinates);
      _polylines.add(polyline);
    });
  }

  Future _startWalk() async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);
    var dogNames = [];
    for (final el in _selectedDogs) {
      dogNames.add(el.name);
    }
    var body = jsonEncode({
      'id': '$_uid',
      'dogNames': dogNames,
      'mapMarker': '$_currentLocationId',
      'walkStatus': 'ONGOING'
    });
    final response = await client.post(walkUrl, headers: headers, body: body);
    switch (response.statusCode) {
      case 201:
        {
          var decodedJson = jsonDecode(utf8.decode(response.bodyBytes));;
          _walkId = decodedJson['id'];
          _walkStatus = WalkStatus.ONGOING;
          _usersLiked = [];
          break;
        }
      case 404:
        {
          DoggoToast.of(context)
              .showToast('User, dog or map marker doesn\'t exist');
          break;
        }
      case 409:
        {
          DoggoToast.of(context).showToast('You are already on a walk');
          break;
        }
    }
  }

  Future _changeWalkStatus(WalkStatus currentStatus) async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);
    String _currentWalkUrl = walkUrl + '/$_walkId';
    _walkStatus = currentStatus;
    String _status = currentStatus.toString();
    String _trimStatus = _status.substring(_status.indexOf('.') + 1);
    _currentWalkUrl += '?walkStatus=$_trimStatus';

    final response = await client.put(_currentWalkUrl, headers: headers);
    switch (response.statusCode) {
      case 200:
        {
          break;
        }
      case 403:
        {
          DoggoToast.of(context).showToast('New walk status is forbidden');
          break;
        }
      case 404:
        {
          DoggoToast.of(context).showToast('User or walk doesn\'t exist');
          break;
        }
      default:
        {
          DoggoToast.of(context).showToast('ERROR: ${response.statusCode}');
        }
    }
  }

  void _animateCameraToLocation(LatLng location) {
    mapController.animateCamera(CameraUpdate.newLatLng(location));
  }

  void _clearPolylines() {
    setState(() {
      _polylineCoordinates.clear();
      _polylines.clear();
    });
  }

  void _navigationOn() {
    _isNavigating = true;
    _animateCameraToLocation(
        LatLng(_currentLocation.latitude, _currentLocation.longitude));
  }

  void _navigationOff() {
    _isNavigating = false;
    _destination = null;
    _walkId = null;
    _changeWalkStatus(WalkStatus.CANCELED);
    _clearPolylines();
  }

  void _atLocation() async {
    _nearLocation = true;
    _clearPolylines();
    Timer(Duration(seconds: 3), () {
      _flushbarAtLocationAppeared = true;
    });
    if (_walkStatus == WalkStatus.ONGOING) {
      _changeWalkStatus(WalkStatus.ARRIVED_AT_DESTINATION);
    }
  }

  void _awayFromLocation() {
    setState(() {
      _isNavigating = false;
      _nearLocation = false;
      _destination = null;
      _flushbarAtLocationAppeared = false;
      _leavingLocation = true;
      _usersLiked = [];
      _walkId = null;
      if (_walkStatus == WalkStatus.ARRIVED_AT_DESTINATION) {
        _changeWalkStatus(WalkStatus.LEFT_DESTINATION);
      }
      _callTimer();
    });
  }

  void _callTimer() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        _leavingLocation = false;
      });
    });
  }

  void _refreshWalk() async {
    client ??= await OAuth2Client().loadCredentialsFromFile(context);
    final url = 'https://doggo-service.herokuapp.com/api/dog-lover/walks/active';

    final response = await client.put(url, headers: headers);
    switch (response.statusCode) {
      case 200: {
        break;
      }
      case 404: {
        DoggoToast.of(context).showToast('Active walk not found.');
        break;
      }
    }
  }

  void _navigateAndSetUsersLiked(BuildContext context) async {
    _usersLiked = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PeopleAndDogsInLocationPage(
          markerId: _currentLocationId,
          usersLiked: _usersLiked,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text('Map'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: _center,
                  myLocationEnabled: true,
                  markers: Set<Marker>.of(_markers.values),
                  polylines: _polylines,
                  onLongPress: (latLng) async {
                    await mapController.animateCamera(
                      CameraUpdate.newLatLngZoom(latLng, _cameraZoom),
                    );
                    return showModalBottomSheet(
                      context: context,
                      barrierColor: Colors.black12,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return AddLocationBottomSheetWidget(
                          latLng: latLng,
                          addMarkerToMapCallback: addMarkerToMap,
                        );
                      },
                    );
                  },
                ),
                !_isNavigating
                    ? Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01,
                            vertical: screenHeight * 0.01),
                        child: FloatingActionButton(
                            backgroundColor: Colors.orangeAccent,
                            child: Icon(Icons.location_pin),
                            onPressed: () async {
                              _recommended = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return RecommendedLocationsDialog(
                                      long: _currentLocation.longitude,
                                      lat: _currentLocation.latitude,
                                    );
                                  });
                              _currentLocationId = _recommended[0].id;
                              _currentLocationName = _recommended[0].name;
                              _selectedDogs = _recommended[1];
                              _startWalk();
                              _navigationOn();
                              _clearPolylines();
                              _setPolylines(LatLng(
                                _recommended[0].latitude,
                                _recommended[0].longitude
                              ));
                            }),
                      )
                    : Container(),
                _isNavigating && !_nearLocation
                    ? MaterialButton(
                        onPressed: () {
                          _navigationOff();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 65),
                        child: Ink(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.orangeAccent,
                                    blurRadius: 20,
                                    offset: Offset(0, 4)),
                              ],
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orangeAccent,
                                  Color.fromRGBO(200, 100, 20, .85)
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 200.0, maxHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "End Navigation",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    : Text(""),
                _nearLocation && !_flushbarAtLocationAppeared
                    ? Flushbar(
                        message: 'You arrived to the ' + _currentLocationName,
                        backgroundColor: Colors.orangeAccent,
                      )
                    : Text(''),
                _nearLocation
                    ? Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01,
                            vertical: screenHeight * 0.01),
                        child: FloatingActionButton(
                            backgroundColor: Colors.orangeAccent,
                            child: Icon(Icons.account_circle),
                            onPressed: () {
                              _navigateAndSetUsersLiked(context);
                            }),
                      )
                    : Container(),
                _leavingLocation
                    ? Flushbar(
                        message: 'You are leaving the ' + _currentLocationName,
                        backgroundColor: Colors.orangeAccent,
                        duration: Duration(seconds: 2),
                      )
                    : Text('')
              ],
            ),
    );
  }
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}
