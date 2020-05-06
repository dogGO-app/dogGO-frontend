import 'dart:convert';

import 'package:doggo_frontend/Location/http/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

typedef AddMarkerToMapCallback = void Function(LocationMarker locationMarker);

class AddLocationBottomSheetWidget extends StatefulWidget {
  final LatLng latLng;
  final AddMarkerToMapCallback addMarkerToMapCallback;

  const AddLocationBottomSheetWidget(
      {Key key, @required this.latLng, @required this.addMarkerToMapCallback})
      : super(key: key);

  @override
  _AddLocationBottomSheetWidgetState createState() =>
      _AddLocationBottomSheetWidgetState();
}

class _AddLocationBottomSheetWidgetState
    extends State<AddLocationBottomSheetWidget> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future _saveMarker(LocationMarker locationMarker) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    final url = 'https://doggo-app-server.herokuapp.com/api/mapMarkers';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };

    final requestBody = jsonEncode({
      'id': locationMarker.id,
      'name': locationMarker.name,
      'description': locationMarker.description,
      'latitude': locationMarker.latitude,
      'longitude': locationMarker.longitude,
    });

    final response = await http.post(url, headers: headers, body: requestBody);
    switch (response.statusCode) {
      case 200:
        {
          Navigator.of(context).pop();
          return widget.addMarkerToMapCallback(locationMarker);
        }
      case 400:
        {
          _showAlertDialogWithMessage(
            'The place you want to add is too close to already existing one!',
          );
          throw Exception(
            'The place to add is too close to already existing one!',
          );
        }
      default:
        {
          _showAlertDialogWithMessage(
            "You have to provide a name for new location!",
          );
          throw Exception("Couldn't save location marker on server!");
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('New location'),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Name",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: "Description",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            RaisedButton(
              child: const Text('Add location'),
              onPressed: () {
                final locationMarker = LocationMarker(
                  id: Uuid().v4(),
                  name: nameController.text,
                  description: descriptionController.text,
                  latitude: widget.latLng.latitude,
                  longitude: widget.latLng.longitude,
                );
                _saveMarker(locationMarker);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future _showAlertDialogWithMessage(String message) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
        );
      },
    );
  }
}
