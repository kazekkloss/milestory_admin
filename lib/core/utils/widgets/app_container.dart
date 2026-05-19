import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class AppContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool roundTopLeft;
  final bool roundTopRight;
  final bool roundBottomLeft;
  final bool roundBottomRight;
  final bool borderTop;
  final bool borderBottom;
  final bool borderLeft;
  final bool borderRight;

  const AppContainer({
    super.key,
    required this.child,
    this.margin,
    this.height,
    this.width,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.roundTopLeft = true,
    this.roundTopRight = true,
    this.roundBottomLeft = true,
    this.roundBottomRight = true,
    this.borderTop = true,
    this.borderBottom = true,
    this.borderLeft = true,
    this.borderRight = true,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final r = Radius.circular(c.radiusLg);

    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
          color: color ?? c.bgCard,
          borderRadius: BorderRadius.only(
            topLeft: roundTopLeft ? r : Radius.zero,
            topRight: roundTopRight ? r : Radius.zero,
            bottomLeft: roundBottomLeft ? r : Radius.zero,
            bottomRight: roundBottomRight ? r : Radius.zero,
          ),
          border: Border(
            top: borderTop ? BorderSide(color: c.accentBorder) : BorderSide.none,
            bottom: borderBottom ? BorderSide(color: c.accentBorder) : BorderSide.none,
            left: borderLeft ? BorderSide(color: c.accentBorder) : BorderSide.none,
            right: borderRight ? BorderSide(color: c.accentBorder) : BorderSide.none,
          ),
        ),
      child: child,
    );
  }
}



