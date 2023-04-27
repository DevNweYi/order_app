import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final TextOverflow textOverflow;
  final TextAlign? textAlign;

  const SmallText(
      {super.key,
      required this.text,
      this.color = Colors.black45,
      this.size = 14,
      this.textOverflow = TextOverflow.visible,
      this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        overflow: textOverflow,
      ),
      textAlign: textAlign,
    );
  }
}
