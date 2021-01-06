import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String buttonText;
  final Color fillColor;
  final Color textColor;
  final Color borderColor;
  final Function onPressed;

  RoundedButton(
      {this.buttonText = 'Empty text',
      this.fillColor = Colors.white30,
      this.textColor = Colors.black,
      this.borderColor = Colors.blueGrey,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        color: fillColor,
        onPressed: () {
          onPressed();
        },
        child: Container(
          child: Text(
            buttonText,
            style: TextStyle(color: textColor),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: borderColor),
        ));
  }
}
