import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:milestory_admin/features/tour/tour_export.dart';

import '../../creator_export.dart';

class CreatorTopTab extends StatelessWidget {
  final bool isExternelId;
  final Tour tour;
  final VoidCallback? onRejectionBadgeTap;
  final bool isRejectionCardVisible;

  const CreatorTopTab({
    super.key,
    required this.isExternelId,
    required this.tour,
    this.onRejectionBadgeTap,
    this.isRejectionCardVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return BlocBuilder<TourBloc, TourState>(
      builder: (context, state) {
        final selected = state.selectedTour;
        final currentTour = (selected != null && selected.id == tour.id)
            ? selected
            : tour;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          decoration: BoxDecoration(
            color: c.bg,
            border: Border(
              bottom: BorderSide(color: c.borderSubtle, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: c.bgInput,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        FontAwesomeIcons.mapLocationDot,
                        size: 12,
                        color: c.accent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentTour.title.isEmpty
                                ? 'Bez tytułu'
                                : currentTour.title,
                            style: ts.cardTitle.copyWith(
                              fontSize: 13,
                              color: c.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            'Podgląd punktów trasy',
                            style: ts.caption.copyWith(
                              fontSize: 11,
                              color: c.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (currentTour.status == TourStatus.rejected) ...[
                    const SizedBox(width: 6),
                    IconActionButton(
                      icon: FontAwesomeIcons.circleExclamation,
                      iconSize: 12,
                      color: isRejectionCardVisible
                          ? TourStatus.private.color
                          : TourStatus.rejected.color,
                      tooltip: 'Powód odrzucenia',
                      onTap: onRejectionBadgeTap,
                    ),
                  ],
                  const SizedBox(width: 10),
                  StatusPill(status: currentTour.status),
                  const SizedBox(width: 8),
                  IconActionButton(
                    icon: FontAwesomeIcons.arrowLeft,
                    iconSize: 12,
                    color: c.textSecondary,
                    tooltip: 'Wróć',
                    onTap: () => context.pop(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
