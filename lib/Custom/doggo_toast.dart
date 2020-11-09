import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class DoggoToast {
  BuildContext context;

  DoggoToast(BuildContext context) {
    this.context = context;
  }

  static DoggoToast of(BuildContext context) {
    return DoggoToast(context);
  }

  void showToast(String msg) {
    Toast.show(msg, context,
        duration: 3,
        backgroundColor: Colors.orange,
        border: Border.all(color: Colors.black, width: 3.0));
  }
}
