import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final TextOverflow textOverflow;
  final FontWeight fontWeight;

  const TitleText(
      {super.key,
      required this.text,
      this.color = Colors.black,
      this.size = 20,
      this.textOverflow = TextOverflow.ellipsis,
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
    );
  }
}
