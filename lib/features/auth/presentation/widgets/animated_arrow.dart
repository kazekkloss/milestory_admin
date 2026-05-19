import 'package:flutter/material.dart';
import '../../../../core/core_export.dart';

class AnimatedArrow extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onTap;

  const AnimatedArrow({
    super.key,
    required this.animation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedBuilder(
          animation: animation,
          builder: (_, __) => Transform.translate(
            offset: Offset(0, animation.value),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 40,
              color: c.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
