import 'dart:async';
import 'dart:convert';

import 'package:doggo_frontend/OAuth2/oauth2_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'Custom/doggo_toast.dart';

class RegistrationVerifyState extends State<RegistrationVerifyPage> {
  Client client;
  TextEditingController textEditingController = TextEditingController()
    ..text = "";
  StreamController<ErrorAnimationType> errorController;
  var hasError = false;
  var currentText = '';

  final activateUrl = 'https://doggo-service.herokuapp.com/api/auth/users/activate';

  final authority = 'doggo-service.herokuapp.com';
  final mailPath = '/api/auth/users/send-activation-mail';

  final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  Future verifyUser(String email, String activationCode) async {
    client ??= await OAuth2Client().getClientCredentialsGrant();
    var body = jsonEncode({
      'email': '$email',
      'activationCode': '$activationCode'
    });

    final response = await client.put(activateUrl, headers: headers, body: body);
    if (response.statusCode == 200) {
      Navigator.of(context).pushNamedAndRemoveUntil('/adduserdata', (route) => false);
    } else {
      DoggoToast.of(context).showToast('Failed to activate user - wrong activation code.');
      throw Exception('Failed to activate user.\nCode: ${response.statusCode}');
    }
  }

  Future _sendVerificationEmail(String email) async {
    var mailQueryParameters = {'userEmail': '$email'};
    var mailUri = Uri.https(authority, mailPath, mailQueryParameters);

    final mailResponse = await client.post(mailUri, headers: headers);
    if (mailResponse.statusCode == 200)
      DoggoToast.of(context).showToast('Mail sent again to your mailbox.');
    else {
      DoggoToast.of(context).showToast('Activation email could not be sent!');
      throw Exception('Activation email could not be sent!\nCode: ${mailResponse.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final String email = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(title: Text('Verify registration')),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.1, horizontal: screenWidth * 0.025),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.vpn_key,
                color: Colors.amber,
                size: 128,
              ),
              Text(
                'Please pass 6-digit verification code sent to your email:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
              Form(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.2,
                      screenHeight * 0.1,
                      screenWidth * 0.2,
                      screenHeight * 0.01),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      fieldHeight: screenHeight * 0.05,
                      fieldWidth: screenWidth * 0.04,
                      activeColor: hasError ? Colors.red : Colors.green,
                      inactiveColor: Colors.black,
                      selectedColor: Colors.deepOrange,
                    ),
                    backgroundColor: Colors.white38,
                    keyboardType: TextInputType.number,
                    animationDuration: Duration(milliseconds: 300),
                    controller: textEditingController,
                    errorAnimationController: errorController,
                    enableActiveFill: false,
                    showCursor: false,
                    beforeTextPaste: (text) {
                      return true;
                    },
                    onChanged: (value) {
                      hasError = false;
                      if (double.tryParse(value) == null) {
                        hasError = true;
                      }
                      setState(() {
                        currentText = value;
                      });
                    },
                    onCompleted: (value) {
                      if (double.tryParse(value) == null) {
                        hasError = true;
                        errorController.add(ErrorAnimationType.shake);
                      } else
                      verifyUser(email, value);
                      setState(() {
                        currentText = value;
                      });
                    },
                  ),
                ),
              ),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "Didn't receive the code? ",
                      style: TextStyle(
                          color: Colors.black54, fontSize: screenWidth * 0.035),
                      children: [
                        TextSpan(
                            text: " RESEND",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _sendVerificationEmail(email);
                              },
                            style: TextStyle(
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.035))
                      ]),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.05,
                    horizontal: screenWidth * 0.02),
                child: Center(
                  child: Visibility(
                    child: Text(
                      "Verification code must consist of numeric characters only.",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: screenWidth * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    visible: hasError,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RegistrationVerifyPage extends StatefulWidget {
  @override
  RegistrationVerifyState createState() => RegistrationVerifyState();
}
