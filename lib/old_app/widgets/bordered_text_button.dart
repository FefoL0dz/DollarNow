import 'package:flutter/material.dart';

class BorderedTextButton extends StatelessWidget {
  final Function function;
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final double borderWidth;
  final Color borderColor;
  final double fontSize;
  final double borderRadius;
  //final bool withLinearGradient;

  const BorderedTextButton({
    required this.text,
    required this.textColor,
    required this.fontSize,
    this.backgroundColor = Colors.black,
    required this.borderWidth,
    required this.borderColor,
    required this.borderRadius,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: _buttonBoxDecoration(),
      child: Text(
        text,
        style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: fontSize),
      ),
    );
  }

  BoxDecoration _buttonBoxDecoration() {
    return BoxDecoration(
        border: Border.all(
          width: borderWidth,
          color: borderColor,
        ),
        // gradient: LinearGradient(
        //     colors: [
        //       backgroundColor[400],
        //       backgroundColor[600],
        //     ]),
        borderRadius: BorderRadius.circular(borderRadius),
        color: backgroundColor);
  }
}
