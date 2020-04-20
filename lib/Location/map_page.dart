import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  @override
  void initState() {
    super.initState();
    _location = new Location();
    _getLocation();
  }

  _getLocation() async {
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
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text('Map'),
        centerTitle: true,
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : Container(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: _center,
                myLocationEnabled: true,
              ),
            ),
    );
  }
}
