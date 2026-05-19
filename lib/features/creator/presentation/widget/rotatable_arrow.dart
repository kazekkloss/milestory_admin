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
  Offset _initialFocalPoint = Offset.zero;
  bool _transparent = false;

  void _setAngleFromDirection(double? direction) {
    _angle = (direction ?? 0.0) * pi / 180;
  }

  @override
  void initState() {
    super.initState();
    final state = context.read<CreatorBloc>().state;
    final tourPoint = state.tourPoints.firstWhere(
      (tp) => tp.id == widget.selectedTourPointId,
      orElse: () => state.tourPoints.first,
    );
    final area = tourPoint.areas
        .where((a) => a.id == widget.selectedAreaId)
        .cast<Area?>()
        .firstOrNull;
    _setAngleFromDirection(area?.direction);
  }

  @override
  void didUpdateWidget(covariant RotatableArrowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedAreaId != widget.selectedAreaId) {
      final state = context.read<CreatorBloc>().state;
      final tourPoint = state.tourPoints.firstWhere(
        (tp) => tp.id == widget.selectedTourPointId,
        orElse: () => state.tourPoints.first,
      );
      final area = tourPoint.areas
          .where((a) => a.id == widget.selectedAreaId)
          .cast<Area?>()
          .firstOrNull;
      _setAngleFromDirection(area?.direction);
    }
  }

  void _onPanStart(DragStartDetails details) {
    _initialFocalPoint = details.localPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final Offset currentFocalPoint = details.localPosition;
    final double dx = currentFocalPoint.dx - _initialFocalPoint.dx;
    final double dy = currentFocalPoint.dy - _initialFocalPoint.dy;
    setState(() {
      _angle = atan2(dy, dx) - pi / 2;
      if (_angle < 0) _angle += 2 * pi;
    });
  }

  double get _angleInDegrees => (_angle * 180 / pi) % 360;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    final bgColor = _transparent
        ? Colors.black.withValues(alpha: 0.25)
        : Colors.black.withValues(alpha: 0.88);
    final borderColor = _transparent
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.12);

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(c.radiusLg),
        border: Border.all(color: borderColor, width: 0.5),
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
                    Icon(
                      FontAwesomeIcons.compass,
                      size: 11,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
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
                    _HeaderIconButton(
                      icon: FontAwesomeIcons.xmark,
                      onTap: widget.closeDirecton,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 0.5,
            color: Colors.white.withValues(alpha: 0.08),
          ),
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: Colors.transparent,
              child: Column(
                children: [
                  Transform.rotate(
                    angle: _angle,
                    child: FaIcon(
                      FontAwesomeIcons.arrowUp,
                      size: 80,
                      color: c.accent,
                    ),
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
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
            child: Column(
              children: [
                Row(
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
                        inactiveTrackColor:
                            Colors.white.withValues(alpha: 0.15),
                        trackOutlineColor:
                            WidgetStateProperty.all(Colors.transparent),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _PanelButton(
                        label: 'Zapisz',
                        icon: FontAwesomeIcons.check,
                        color: const Color(0xFF1D9E75),
                        onTap: () {
                          context.read<CreatorBloc>().add(
                                DirectionEvent(direction: _angleInDegrees),
                              );
                          widget.closeDirecton();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _PanelButton(
                        label: 'Usuń',
                        icon: FontAwesomeIcons.xmark,
                        color: const Color(0xFFE24B4A),
                        onTap: () {
                          context
                              .read<CreatorBloc>()
                              .add(DirectionEvent(direction: null));
                          widget.closeDirecton();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// A small icon button in the panel header
// ─────────────────────────────────────────────
class _HeaderIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderIconButton({required this.icon, required this.onTap});

  @override
  State<_HeaderIconButton> createState() => _HeaderIconButtonState();
}

class _HeaderIconButtonState extends State<_HeaderIconButton> {
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
            color: _hover
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            widget.icon,
            size: 11,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Action button in panel (Save / Delete)
// ─────────────────────────────────────────────
class _PanelButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _PanelButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_PanelButton> createState() => _PanelButtonState();
}

class _PanelButtonState extends State<_PanelButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: 30,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: _hover ? 0.22 : 0.14),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: widget.color.withValues(alpha: _hover ? 0.6 : 0.35),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(widget.icon, size: 10, color: widget.color),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 11,
                  color: widget.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
