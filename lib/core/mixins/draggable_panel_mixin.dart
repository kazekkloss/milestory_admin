// lib/core/mixins/draggable_panel_mixin.dart

import 'package:flutter/material.dart';

mixin DraggablePanelMixin<T extends StatefulWidget> on State<T> {
  /// Key attached to the container (Stack) that defines drag boundaries.
  final GlobalKey stackKey = GlobalKey();

  /// Key attached to the panel itself — used to measure its size during clamping.
  final GlobalKey panelKey = GlobalKey();

  /// Panel position: dx = distance from the right edge, dy = from the top.
  Offset panelOffset = const Offset(20, 20);

  /// Whether the panel is visible. Controls rendering in build().
  bool isPanelVisible = false;

  Offset get initialPanelOffset => const Offset(20, 20);

  double get panelFallbackMaxX => 400.0;
  double get panelFallbackMaxY => 400.0;

  void togglePanel(bool visible) {
    setState(() {
      isPanelVisible = visible;
      if (visible) {
        panelOffset = initialPanelOffset;
      }
    });

    if (visible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !isPanelVisible) return;
        setState(() {
          panelOffset = _clampOffset(panelOffset);
        });
      });
    }
  }

  /// Call from the panel handle's `onPanUpdate`.
  void updatePanelPosition(DragUpdateDetails details) {
    final rawOffset = Offset(
      // dx is distance from the RIGHT, so moving right decreases it.
      panelOffset.dx - details.delta.dx,
      panelOffset.dy + details.delta.dy,
    );

    setState(() {
      panelOffset = _clampOffset(rawOffset);
    });
  }

  /// Clamps the offset to container boundaries. Uses actual sizes
  /// if available, otherwise falls back to fallback values.
  Offset _clampOffset(Offset offset) {
    final stackBox = stackKey.currentContext?.findRenderObject() as RenderBox?;
    final panelBox = panelKey.currentContext?.findRenderObject() as RenderBox?;

    if (stackBox != null &&
        stackBox.hasSize &&
        panelBox != null &&
        panelBox.hasSize) {
      return Offset(
        offset.dx.clamp(0.0, stackBox.size.width - panelBox.size.width),
        offset.dy.clamp(0.0, stackBox.size.height - panelBox.size.height),
      );
    }

    return Offset(
      offset.dx.clamp(0.0, panelFallbackMaxX),
      offset.dy.clamp(0.0, panelFallbackMaxY),
    );
  }
}