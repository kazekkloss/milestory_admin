import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class HoverCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double liftAmount;
  final double glowBlur;

  const HoverCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(30),
    this.liftAmount = 4,
    this.glowBlur = 48,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovering ? -widget.liftAmount : 0, 0),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: _hovering ? c.bgCardHover : c.bgCard,
          borderRadius: BorderRadius.circular(c.radiusLg),
          border: Border.all(color: _hovering ? c.accent : c.accentBorder),
          boxShadow: _hovering
              ? [BoxShadow(
                  color: c.accent.withValues(alpha: 0.08),
                  blurRadius: widget.glowBlur,
                  offset: Offset(0, widget.liftAmount * 4))]
              : [],
        ),
        child: widget.child,
      ),
    );
  }
}
