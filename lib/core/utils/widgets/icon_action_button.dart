import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconActionButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final bool loading;
  final VoidCallback? onTap;
  final double? iconSize;
  final double? size;
  final double? radius;
  const IconActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.tooltip,
    this.loading = false,
    this.iconSize = 15,
    this.size = 30,
    this.radius = 10,
    required this.onTap,
  });

  @override
  State<IconActionButton> createState() => _IconActionButtonState();
}

class _IconActionButtonState extends State<IconActionButton> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.loading ? null : widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: _hover
                  ? widget.color.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(widget.radius!),
              border: Border.all(
                color: _hover
                    ? widget.color.withValues(alpha: 0.4)
                    : Colors.transparent,
                width: 0.5,
              ),
            ),
            child: Center(
              child: widget.loading
                  ? const SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(strokeWidth: 1.5),
                    )
                  : FaIcon(widget.icon,
                      size: widget.iconSize, color: widget.color),
            ),
          ),
        ),
      ),
    );
  }
}
