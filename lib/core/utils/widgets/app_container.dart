import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  const AppContainer({super.key, required this.child, this.margin, this.height, this.width, this.padding = const EdgeInsets.all(20), this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          border: Border.all(color: Theme.of(context).primaryColor, width: 1)),
      child: child,
    );
  }
}
