import 'dart:convert';
import 'dart:ui';

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
            "You have to provide a name for new location!",
          );
          throw Exception("Location marker name cannot be empty!");
        }
      case 409:
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
          throw Exception("Couldn't save location marker on server!");
        }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Name',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: descriptionController,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Description',
                    ),
                  ),
                ),
                MaterialButton(
                  color: Colors.orangeAccent,
                  child: Text(
                    'Add new location',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    final locationMarker = LocationMarker(
                      id: Uuid().v4(),
                      name: nameController.text,
                      description: descriptionController.text,
                      latitude: widget.latLng.latitude,
                      longitude: widget.latLng.longitude,
                    );
                    await _saveMarker(locationMarker);
                  },
                )
              ],
            ),
          )
        ],
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
