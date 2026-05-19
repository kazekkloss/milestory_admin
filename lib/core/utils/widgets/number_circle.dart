import 'package:flutter/material.dart';

class NumberCircle extends StatelessWidget {
  final int number;
  final Color color;

  const NumberCircle({
    super.key,
    required this.number,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 0.5),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(fontSize: 10, color: color),
            ),
          ),
        ),
      ],
    );
  }
}
