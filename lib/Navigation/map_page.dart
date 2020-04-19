import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

const double CAMERA_ZOOM = 16;
const LatLng SOURCE_LOCATION = LatLng(52.401774, 16.951087);

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

  @override
  void initState() {
    super.initState();
    location = new Location();

    location.onLocationChanged.listen((event) {
      currentLocation = event;
    });

    setInitialLocation();
  }

  void setInitialLocation() async {
//    _serviceEnabled = await location.serviceEnabled();
//    if (!_serviceEnabled) {
//      _serviceEnabled = await location.requestService();
//      if (!_serviceEnabled) {
//        return;
//      }
//    }
//
//    _permissionGranted = await location.hasPermission();
//    if (_permissionGranted == PermissionStatus.denied) {
//      _permissionGranted = await location.requestPermission();
//      if (_permissionGranted != PermissionStatus.granted) {
//        return;
//      }
//    }

    currentLocation = await location.getLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  CameraPosition initialCameraPosition() {
    LatLng target;
    if (currentLocation != null)
      target = LatLng(currentLocation.latitude, currentLocation.longitude);
    else
      target = SOURCE_LOCATION;
    return CameraPosition(target: target, zoom: CAMERA_ZOOM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text('Map'),
        centerTitle: true,
      ),
      body: GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: initialCameraPosition(),
      myLocationEnabled: true,
      ),
    );
  }
}
