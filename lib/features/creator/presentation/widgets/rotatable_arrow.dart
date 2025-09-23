import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/core_export.dart';
import '../../creator_export.dart';

class RotatableArrowWidget extends StatefulWidget {
  final VoidCallback closeDirecton;
  final String selectedAreaId;
  final int selectedTourPointId;

  const RotatableArrowWidget({
    super.key,
    required this.closeDirecton,
    required this.selectedAreaId,
    required this.selectedTourPointId,
  });

  @override
  State<RotatableArrowWidget> createState() => _RotatableArrowWidgetState();
}

class _RotatableArrowWidgetState extends State<RotatableArrowWidget> {
  double _angle = 0.0;
  bool transparent = false;

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
    final area = tourPoint.areas.where((a) => a.id == widget.selectedAreaId).cast<Area?>().firstOrNull;
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
      final area = tourPoint.areas.where((a) => a.id == widget.selectedAreaId).cast<Area?>().firstOrNull;
      _setAngleFromDirection(area?.direction);
    }
  }

  double get _angleInDegrees => (_angle * 180 / pi) % 360;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatorBloc, CreatorState>(
      builder: (context, state) {
        return AppContainer(
          width: 170,
          padding: const EdgeInsets.all(0),
          color: transparent ? null : const Color.fromARGB(255, 0, 0, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: transparent,
                      onChanged: (val) {
                        setState(() {
                          transparent = val;
                        });
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.closeDirecton,
                    icon: FaIcon(FontAwesomeIcons.xmark, color: transparent ? Colors.white : Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
              Transform.rotate(
                angle: _angle,
                child: FaIcon(
                  FontAwesomeIcons.arrowUp,
                  size: 100,
                  color: transparent ? Colors.white : Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_angleInDegrees.toStringAsFixed(1)}°',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
