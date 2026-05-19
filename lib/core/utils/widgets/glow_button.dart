import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class GlowButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final double width;
  final double height;
  final Color? color;

  const GlowButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.width = 140,
    this.height = 32,
    this.color,
  });

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton>
    with SingleTickerProviderStateMixin {
  bool _hovering = false;
  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  late final AnimationController _shimmer;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  void _setHovering(bool value) {
    if (_hovering == value) return;
    setState(() => _hovering = value);

    if (value && _enabled) {
      _shimmer.repeat();
    } else {
      _shimmer.stop();
      _shimmer.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final glowActive = _hovering && _enabled;
    final color = widget.color ?? c.accent;

    return MouseRegion(
      onEnter: (_) => _setHovering(true),
      onExit: (_) => _setHovering(false),
      cursor:
          _enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, glowActive ? -2 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          boxShadow: glowActive
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.35),
                    blurRadius: 28,
                    spreadRadius: 1,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(c.radiusSm),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ElevatedButton(
                    onPressed: widget.isLoading ? null : widget.onPressed,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((s) {
                        if (widget.isLoading) return color;
                        if (s.contains(WidgetState.disabled)) {
                          return c.bgElevated;
                        }
                        return color;
                      }),
                      foregroundColor: WidgetStateProperty.resolveWith((s) {
                        if (widget.isLoading) return c.bg;
                        if (s.contains(WidgetState.disabled)) {
                          return c.textMuted;
                        }
                        return c.bg;
                      }),
                      overlayColor:
                          WidgetStateProperty.all(Colors.transparent),
                      side: WidgetStateProperty.resolveWith((s) {
                        if (widget.isLoading) return BorderSide.none;
                        if (s.contains(WidgetState.disabled)) {
                          return BorderSide(color: c.borderSubtle, width: 1);
                        }
                        return BorderSide.none;
                      }),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(c.radiusSm),
                        ),
                      ),
                      elevation: WidgetStateProperty.all(0),
                    ),
                    child: widget.isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: c.bg,
                            ),
                          )
                        : Text(
                            widget.text,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: _enabled ? c.bg : c.textMuted,
                                ),
                          ),
                  ),
                ),

                // ── Subtelny shimmer ──
                if (glowActive)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: AnimatedBuilder(
                        animation: _shimmer,
                        builder: (context, _) {
                          final t = _shimmer.value * 2.5 - 0.75;
                          return ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (rect) {
                              return LinearGradient(
                                begin: Alignment(t - 0.4, -0.3),
                                end: Alignment(t + 0.4, 0.3),
                                colors: [
                                  Colors.white.withValues(alpha: 0.0),
                                  Colors.white.withValues(alpha: 0.18),
                                  Colors.white.withValues(alpha: 0.0),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ).createShader(rect);
                            },
                            child: Container(color: Colors.white),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}