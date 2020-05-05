import 'dart:convert';

import 'package:doggo_frontend/Location/http/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  Location _location;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  CameraPosition _center;
  bool _isLoading = false;

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

    await _showMarkers();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((location) => LocationMarker.fromJson(location))
          .toList();
    } else {
      throw Exception('Failed to load location markers data from API');
    }
  }

  Future<void> _showMarkers() async {
    final locationMarkers = await _fetchLocationMarkers();
    locationMarkers.forEach((locationMarker) {
      final marker = Marker(
        markerId: MarkerId(locationMarker.id),
        position: LatLng(locationMarker.latitude, locationMarker.longitude),
        infoWindow: InfoWindow(
          title: locationMarker.name,
          snippet: locationMarker.description,
        ),
      );
      setState(() {
        _markers.putIfAbsent(marker.markerId, () => marker);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
              ),
            ),
    );
  }
}
