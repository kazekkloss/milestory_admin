import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  const AppContainer({super.key, required this.child, this.margin, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          //color: const Color.fromARGB(255, 49, 49, 49),
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          border: Border.all(color: Theme.of(context).primaryColor, width: 1)),
      child: child,
    );
  }
}
