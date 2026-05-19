import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../creator_export.dart';

class StepBackButton extends StatefulWidget {
  const StepBackButton({super.key});

  @override
  State<StepBackButton> createState() => _StepBackButtonState();
}

class _StepBackButtonState extends State<StepBackButton> {
  late CreatorBloc _creatorBloc;
  bool _hovering = false;

  @override
  void initState() {
    _creatorBloc = context.read<CreatorBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return BlocBuilder<CreatorBloc, CreatorState>(
      builder: (context, state) {
        final enabled = state.markers.isNotEmpty;

        return MouseRegion(
          onEnter: (_) => setState(() => _hovering = true),
          onExit: (_) => setState(() => _hovering = false),
          cursor:
              enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: enabled ? 0.85 : 0.5),
              borderRadius: BorderRadius.circular(c.radiusMd),
              border: Border.all(
                color: enabled && _hovering
                    ? c.accent.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.08),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(c.radiusMd),
                onTap: enabled ? () => _creatorBloc.add(BackStepEvent()) : null,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.arrowRotateLeft,
                        size: 13,
                        color: enabled
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Cofnij',
                        style: TextStyle(
                          fontSize: 12,
                          color: enabled
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
