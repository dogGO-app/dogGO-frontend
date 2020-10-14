import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class RegistrationVerifyState extends State<RegistrationVerifyPage> {
  TextEditingController textEditingController = TextEditingController()
    ..text = "";
  StreamController<ErrorAnimationType> errorController;
  var hasError = false;
  var filled = false;
  var currentText = '';

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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Verify registration')),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.1, horizontal: screenWidth * 0.025),
          child: Column(
            children: <Widget>[
              IconShadowWidget(
                Icon(
                  Icons.vpn_key,
                  color: Colors.amber,
                  size: 128,
                ),
                shadowColor: Colors.orangeAccent,
                showShadow: false,
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
                      activeColor: hasError ? Colors.red : Colors.orangeAccent,
                      inactiveColor: Colors.black,
                      selectedColor: Colors.deepOrange,
                    ),
                    backgroundColor: Colors.white38,
                    keyboardType: TextInputType.number,
                    animationDuration: Duration(milliseconds: 300),
                    controller: textEditingController,
                    errorAnimationController: errorController,
                    enableActiveFill: false,
                    beforeTextPaste: (text) {
                      return true;
                    },
                    onChanged: (value) {
                      filled = false;
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
                        filled = true;
                      // TODO: call API (check if verified, if true - and navigate to SetUserDataPage)
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
                      style: TextStyle(color: Colors.black54, fontSize: screenWidth * 0.035),
                      children: [
                        TextSpan(
                            text: " RESEND",
                            recognizer: TapGestureRecognizer()..onTap = () {
                              // TODO: call API (resend verification code)
                            },
                            style: TextStyle(
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.035))
                      ]),
                ),
              ),
              Padding(
                // TODO: switch to error message after API integration
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.05,
                    horizontal: screenWidth * 0.02),
                child: Center(
                  child: Visibility(
                    child: Text(
                      "Gratulacje typie, udało ci się poprawnie wypełnić kod weryfikacyjny!",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    visible: filled,
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
