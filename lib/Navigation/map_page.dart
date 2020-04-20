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
  LocationData currentLocation;
  Location location;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  CameraPosition _center;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    location = new Location();
    _getLocation();
  }

  _getLocation() async {
    setState(() {
      isLoading = true;
    });
    initialize();
    currentLocation = await location.getLocation();
    if (currentLocation == null) {
      return;
    }
    _center = CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: _cameraZoom,
    );

    setState(() {
      isLoading = false;
    });

    print("Current location: $currentLocation");
  }

  Future<void> initialize() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
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
      body: isLoading
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
