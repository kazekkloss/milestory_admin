import 'package:flutter/material.dart';
import '../../core_export.dart';

class StatusPill extends StatefulWidget {
  final TourStatus? status;
  final String? label;
  final double size;
  final VoidCallback? onTap;
  final bool isCardVisible;

  final bool? selected;
  final Color? color;

  const StatusPill({
    super.key,
    this.status,
    this.label,
    this.size = 24,
    this.onTap,
    this.isCardVisible = false,
    this.selected,
    this.color,
  }) : assert(
          status != null || label != null,
          'Provide either status or label',
        );

  @override
  State<StatusPill> createState() => _StatusPillState();
}

class _StatusPillState extends State<StatusPill> {
  bool _hovered = false;

  bool get _isFilterMode => widget.selected != null;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final s = widget.size;

    final fontSize = s / 2;
    final iconSize = s / 2.2;
    final dotSize = s / 4;
    final gap = s / 4;
    final hPad = _isFilterMode ? s / 2 : s / 2.4;
    final vPad = _isFilterMode ? s / 4 : s / 4.8;
    final width = s * 4.5;

    final color = widget.color ?? widget.status?.color ?? c.accent;
    final label =
        widget.label ?? TourStatusData.mapStatusEnumToString(widget.status!);
    final selected = widget.selected ?? true;

    final bool showDot = _isFilterMode ? widget.status != null : false;
    final IconData? icon = (_isFilterMode || widget.status == null)
        ? null
        : TourStatusData.mapStatusEnumToIcon(widget.status!).icon;

    final textColor =
        _isFilterMode ? (selected ? color : c.textSecondary) : color;
    final fontWeight = _isFilterMode
        ? (selected ? FontWeight.w500 : FontWeight.w400)
        : FontWeight.w500;
    final bgColor = _isFilterMode
        ? (selected
            ? color.withValues(alpha: 0.20)
            : _hovered
                ? color.withValues(alpha: 0.15)
                : Colors.transparent)
        : (widget.onTap != null && _hovered
            ? color.withValues(alpha: 0.20)
            : color.withValues(alpha: 0.12));
    final borderColor = _isFilterMode
        ? (selected
            ? color
            : _hovered
                ? color.withValues(alpha: 0.5)
                : c.borderSubtle)
        : Colors.transparent;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showDot) ...[
          Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: gap),
        ] else if (icon != null) ...[
          Icon(icon, size: iconSize, color: textColor),
          SizedBox(width: gap),
        ],
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor,
              fontWeight: fontWeight,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );

    Widget pill = Container(
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(s),
      ),
      width: width,
      child: _isFilterMode
          ? AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(s),
                border: Border.all(color: borderColor, width: 0.5),
              ),
              child: content,
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(s),
              ),
              child: content,
            ),
    );

    if (widget.onTap == null) return pill;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(onTap: widget.onTap, child: pill),
    );
  }
}
