import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class AnimatedAppContainer extends StatefulWidget {
  final Widget child;

  const AnimatedAppContainer({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedAppContainer> createState() =>
      _AnimatedGradientContainerState();
}

class _AnimatedGradientContainerState extends State<AnimatedAppContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double angle = _controller.value * 2 * math.pi;
        final begin = Alignment(
          math.cos(angle),
          math.sin(angle),
        );
        final end = Alignment(
          -math.cos(angle),
          -math.sin(angle),
        );

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: [
                c.accent.withAlpha(20),
                c.bg,
              ],
              stops: const [0.0, 1.0],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}