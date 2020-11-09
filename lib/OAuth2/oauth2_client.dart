import 'dart:io';
import 'package:doggo_frontend/Custom/doggo_toast.dart';
import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:path_provider/path_provider.dart';

class OAuth2Client {
  final authorizationEndpoint = Uri.parse(
      'https://doggo-auth-service.herokuapp.com/keycloak/realms/master/protocol/openid-connect/token');

  final credentialsGrantIdentifier = 'doggo';
  final passwordGrantIdentifier = 'doggo_services';
  final credentialsGrantSecret = 'de8d431e-9bd7-4683-929f-2a55bb77f027';
  final passwordGrantSecret = 'b11a8ae3-d625-457d-aeed-86f5ef2b4906';

  File credentialsFile;
  
  Future<bool> _credentialFileExists() async {
    Directory directory = await getApplicationDocumentsDirectory();
    credentialsFile = File('${directory.path}/credentials.json');
    return await credentialsFile.exists();
  }

  Future<oauth2.Client> getClientCredentialsGrant() async {
    bool fileExists = await _credentialFileExists();

    var client = await oauth2.clientCredentialsGrant(
        authorizationEndpoint, credentialsGrantIdentifier, credentialsGrantSecret);

    if (fileExists)
      await credentialsFile.writeAsString(client.credentials.toJson());
    else
      throw Exception("Couldn't save credentials. File doesn't exist.");

    return client;
  }

  Future<oauth2.Client> getResourceOwnerPasswordGrant(String email,
      String password) async {
    bool fileExists = await _credentialFileExists();

    var client = await oauth2.resourceOwnerPasswordGrant(
        authorizationEndpoint, email, password,
        identifier: passwordGrantIdentifier, secret: passwordGrantSecret);

    if (fileExists)
      await credentialsFile.writeAsString(client.credentials.toJson());
    else
      throw Exception("Couldn't save credentials. File doesn't exist.");

    return client;
  }

  Future<oauth2.Client> loadCredentialsFromFile(BuildContext context) async {
    Directory directory = await getApplicationDocumentsDirectory();
    credentialsFile = File('${directory.path}/credentials.json');
    bool fileExists = await credentialsFile.exists();

    if (fileExists) {
      var credentials =
      oauth2.Credentials.fromJson(await credentialsFile.readAsString());
      if (credentials.isExpired && credentials.canRefresh)
        credentials = await credentials.refresh(identifier: passwordGrantIdentifier, secret: passwordGrantSecret);
      else {
        DoggoToast.of(context).showToast("Credentials have expired.");
        Navigator.of(context).popUntil(ModalRoute.withName('/home'));
      }
      return oauth2.Client(credentials,
          identifier: passwordGrantIdentifier, secret: passwordGrantSecret);
    }
    Navigator.of(context).popUntil(ModalRoute.withName('/home'));
    throw Exception("Credentials file doesn't exist.");
  }
}
