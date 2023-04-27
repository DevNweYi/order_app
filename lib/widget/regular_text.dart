import 'package:flutter/material.dart';

class RegularText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final TextOverflow textOverflow;
  final TextAlign textAlign;
  final FontWeight fontWeight;

  const RegularText(
      {super.key,
      required this.text,
      this.color = Colors.black,
      this.size = 18,
      this.textOverflow = TextOverflow.ellipsis,
      this.textAlign = TextAlign.left,
      this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: size,
          overflow: textOverflow,
          fontWeight: fontWeight),
      textAlign: textAlign,
    );
  }
}
