import 'package:flutter/material.dart';

class HeartsWidget extends StatelessWidget {
  const HeartsWidget({required this.hearts, super.key});

  final int hearts;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < hearts ? Icons.favorite : Icons.favorite_border,
          color: Colors.redAccent,
          size: 20,
        );
      }),
    );
  }
}
