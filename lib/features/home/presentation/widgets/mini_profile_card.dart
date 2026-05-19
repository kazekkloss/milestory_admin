import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core_export.dart';
import '../../../guide_user/guide_user_export.dart';
import '../../../tour/tour_export.dart';

class MiniProfileCard extends StatelessWidget {
  const MiniProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return BlocBuilder<GuideUserBloc, GuideUserState>(
      builder: (context, guideState) {
        final user = guideState.guideUser;
        final hasName = user.name.isNotEmpty;

        return BlocBuilder<TourBloc, TourState>(
          builder: (context, tourState) {
            final publishedCount = tourState.allTours
                .where((t) => t.status == TourStatus.published)
                .length;
            final isVisible = publishedCount > 0;

            return AppContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          hasName ? user.name : 'Przewodnik MileStory',
                          style: ts.cardTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 6),
                      StatusPill(
                        size: 20,
                        label: isVisible ? 'Widoczny' : 'Niewidoczny',
                         color: isVisible
                             ? SemanticColors.success
                             : SemanticColors.warning,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(height: 1, color: c.borderSubtle),
                  const SizedBox(height: 6),
                  _ManageProfileButton(
                    onTap: () => context.go('/settings'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _ManageProfileButton extends StatefulWidget {
  final VoidCallback onTap;
  const _ManageProfileButton({required this.onTap});

  @override
  State<_ManageProfileButton> createState() => _ManageProfileButtonState();
}

class _ManageProfileButtonState extends State<_ManageProfileButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered ? c.bgInput : Colors.transparent,
            borderRadius: BorderRadius.circular(c.radiusSm),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Zarządzaj profilem',
                  style: ts.cardTitle.copyWith(fontSize: 13, color: c.accent),
                ),
              ),
              Icon(Icons.chevron_right, size: 16, color: c.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
