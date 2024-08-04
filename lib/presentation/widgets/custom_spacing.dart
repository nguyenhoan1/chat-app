import 'package:flutter/material.dart';

class VerticalSpacing extends StatelessWidget {
  const VerticalSpacing({super.key, this.height = 16});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class HorizontalSpacing extends StatelessWidget {
  const HorizontalSpacing({super.key, this.width = 16});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
