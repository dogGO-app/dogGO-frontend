import 'dart:convert';

import 'package:doggo_frontend/Location/add_location_bottom_sheet_widget.dart';
import 'package:doggo_frontend/Location/http/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

const double _cameraZoom = 16;

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;
  LocationData _currentLocation;
  LocationData _previousLocation;
  Location _location;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  CameraPosition _center;
  bool _isLoading = false;
  bool _isNavigating = false;
  LatLng _destination;
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  String googleApiKey = "AIzaSyAOEF4ZeRSes_MnWz1XCMu5tay_ob5KdUU";

  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    _location = new Location();
    _getLocation();
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
    print("Current location: $_currentLocation");
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
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    final url = 'https://doggo-app-server.herokuapp.com/api/mapMarkers';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse
          .map((location) => LocationMarker.fromJson(location))
          .toList();
    } else {
      throw Exception('Failed to load location markers data from API');
    }
  }

  Future<void> _showMarkersOnMap() async {
    final locationMarkers = await _fetchLocationMarkers();
    locationMarkers.forEach((locationMarker) {
      final marker = Marker(
        markerId: MarkerId(locationMarker.id),
        position: LatLng(locationMarker.latitude, locationMarker.longitude),
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
                                locationMarker.name,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Text(locationMarker.description),
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
                              locationMarker.name,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(locationMarker.description),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MaterialButton(
                            onPressed: () {
                              _navigationOn();
                              _clearPolylines();
                              _setPolylines(LatLng(
                                  locationMarker.latitude, locationMarker.longitude));
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

    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
        googleApiKey,
        _currentLocation.latitude,
        _currentLocation.longitude,
        destination.latitude,
        destination.longitude);

    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
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
    _clearPolylines();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    _location.onLocationChanged.listen((LocationData currentLocation) {
      _previousLocation = _currentLocation;
      _currentLocation = currentLocation;

      if (_isNavigating && _previousLocation != _currentLocation) {
        double latDistance =
            (_destination.latitude - _currentLocation.latitude).abs();
        double lngDistance =
            (_destination.longitude - _currentLocation.longitude).abs();

        _animateCameraToLocation(
            LatLng(_currentLocation.latitude, _currentLocation.longitude));

        if (latDistance < 0.005 || lngDistance < 0.005) {
          _navigationOff();
        } else {
          _clearPolylines();
          _setPolylines(_destination);
        }
      }
    });

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
          : Container(
              child: GoogleMap(
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
            ),
    );
  }
}
