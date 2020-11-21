import 'dart:io';
import 'package:doggo_frontend/Custom/doggo_toast.dart';
import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart';
import 'package:path_provider/path_provider.dart';

class OAuth2Client {
  final _authorizationEndpoint = Uri.parse(
      'https://doggo-auth-service.herokuapp.com/keycloak/realms/master/protocol/openid-connect/token');

  final _credentialsGrantIdentifier = 'doggo';
  final _passwordGrantIdentifier = 'doggo_services';
  final _credentialsGrantSecret = 'de8d431e-9bd7-4683-929f-2a55bb77f027';
  final _passwordGrantSecret = 'b11a8ae3-d625-457d-aeed-86f5ef2b4906';

  File _credentialsFile;

  void _getCredentialsFile() async {
    Directory directory = await getApplicationDocumentsDirectory();
    _credentialsFile = File('${directory.path}/credentials.json');
    if (!await _credentialsFile.exists())
      _credentialsFile.create();
  }

  Future<Client> getClientCredentialsGrant() async {
    var client = await clientCredentialsGrant(_authorizationEndpoint,
        _credentialsGrantIdentifier, _credentialsGrantSecret);

    await _getCredentialsFile();
    await _credentialsFile.writeAsString(client.credentials.toJson());

    return client;
  }

  Future<Client> getResourceOwnerPasswordGrant(
      String email, String password) async {
    var client = await resourceOwnerPasswordGrant(
        _authorizationEndpoint, email, password,
        identifier: _passwordGrantIdentifier, secret: _passwordGrantSecret);

    await _getCredentialsFile();
    await _credentialsFile.writeAsString(client.credentials.toJson());

    return client;
  }

  Future<Client> loadCredentialsFromFile(BuildContext context) async {
    await _getCredentialsFile();

    var credentials =
        Credentials.fromJson(await _credentialsFile.readAsString());
    if (credentials.isExpired && credentials.canRefresh)
      credentials = await credentials.refresh(
          identifier: _passwordGrantIdentifier, secret: _passwordGrantSecret);
    else if (credentials.isExpired && !credentials.canRefresh) {
      DoggoToast.of(context).showToast("Credentials have expired.");
      Navigator.of(context).popUntil((route) => false);
    }
    return Client(credentials,
        identifier: _passwordGrantIdentifier, secret: _passwordGrantSecret);
  }
}
