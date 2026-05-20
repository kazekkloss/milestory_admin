import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:milestory_admin/features/creator/creator_export.dart';

class RotatableArrowWidget extends StatefulWidget {
  final VoidCallback closeDirecton;
  final String selectedAreaId;
  final int selectedTourPointId;
  final void Function(DragUpdateDetails)? onDragHandle;

  const RotatableArrowWidget({
    super.key,
    required this.closeDirecton,
    required this.selectedAreaId,
    required this.selectedTourPointId,
    this.onDragHandle,
  });

  @override
  State<RotatableArrowWidget> createState() => _RotatableArrowWidgetState();
}

class _RotatableArrowWidgetState extends State<RotatableArrowWidget> {
  double _angle = 0.0;
  bool _transparent = false;

  @override
  void initState() {
    super.initState();
    _loadAngle();
  }

  @override
  void didUpdateWidget(covariant RotatableArrowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedAreaId != widget.selectedAreaId) _loadAngle();
  }

  void _loadAngle() {
    final state = context.read<CreatorBloc>().state;
    final tourPoint = state.tourPoints.firstWhere(
      (tp) => tp.id == widget.selectedTourPointId,
      orElse: () => state.tourPoints.first,
    );
    final area = tourPoint.areas
        .where((a) => a.id == widget.selectedAreaId)
        .cast<Area?>()
        .firstOrNull;
    _angle = ((area?.direction ?? 0.0) * pi / 180);
  }

  double get _angleInDegrees => (_angle * 180 / pi) % 360;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: _transparent
            ? Colors.black.withValues(alpha: 0.25)
            : Colors.black.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(c.radiusLg),
        border: Border.all(
          color: _transparent
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.12),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanUpdate: widget.onDragHandle,
            child: MouseRegion(
              cursor: widget.onDragHandle != null
                  ? SystemMouseCursors.move
                  : SystemMouseCursors.basic,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 6, 8),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.compass, size: 11,
                        color: Colors.white.withValues(alpha: 0.7)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'KIERUNEK',
                        style: ts.sectionLabel.copyWith(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.7),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    _CloseButton(onTap: widget.closeDirecton),
                  ],
                ),
              ),
            ),
          ),
          Container(height: 0.5, color: Colors.white.withValues(alpha: 0.08)),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 6, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Przezroczystość',
                    style: ts.caption.copyWith(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: _transparent,
                    onChanged: (val) => setState(() => _transparent = val),
                    activeThumbColor: c.accent,
                    activeTrackColor: c.accent.withValues(alpha: 0.4),
                    inactiveThumbColor: Colors.white.withValues(alpha: 0.6),
                    inactiveTrackColor: Colors.white.withValues(alpha: 0.15),
                    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Transform.rotate(
                  angle: _angle,
                  child: FaIcon(FontAwesomeIcons.arrowUp, size: 80, color: c.accent),
                ),
                const SizedBox(height: 12),
                Text(
                  '${_angleInDegrees.toStringAsFixed(1)}°',
                  style: ts.cardTitle.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CloseButton extends StatefulWidget {
  final VoidCallback onTap;
  const _CloseButton({required this.onTap});

  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: _hover ? Colors.white.withValues(alpha: 0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(FontAwesomeIcons.xmark, size: 11,
              color: Colors.white.withValues(alpha: 0.8)),
        ),
      ),
    );
  }
}
