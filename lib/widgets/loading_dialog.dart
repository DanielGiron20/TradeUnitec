import 'package:flutter/material.dart';

class LoadingDialog {
  void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            alignment: Alignment.center,
            height: 100,
            width: 100,
            child: const CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  void hide(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
