import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core_export.dart';
import '../../tour_export.dart';

class TopTab extends StatelessWidget {
  final UserToursArgs? userArgs;
  const TopTab({super.key, this.userArgs});

  @override
  Widget build(BuildContext context) {
    final ts = AppTextStyles.of(context);
    final narrow = SizeConfig.isNarrow(context);

    return BlocBuilder<TourBloc, TourState>(
      builder: (context, state) {
        final total = state.stats?.totalTours ?? state.tours.length;
        final verifyCount = state.allTours
            .where((t) => t.status == TourStatus.pendingReview)
            .length;
        final isUserView = userArgs != null;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            narrow ? 20 : 28,
            narrow ? 20 : 28,
            narrow ? 20 : 28,
            0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isUserView) ...[
                IconActionButton(
                  icon: Icons.arrow_back,
                  iconSize: 16,
                  color: AppColors.of(context).textSecondary,
                  tooltip: 'Wróć',
                  onTap: () => context.pop(),
                ),
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 14,
                      runSpacing: 8,
                      children: [
                        Text(
                          isUserView ? 'Trasy użytkownika' : 'Panel zarządzania trasami',
                          style: ts.sectionTitle.copyWith(fontSize: 22),
                        ),
                        if (!isUserView && verifyCount > 0)
                          _VerifyBadge(count: verifyCount),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isUserView ? userArgs!.displayName : 'Twórz, edytuj i publikuj swoje trasy audio.',
                      style: ts.caption,
                    ),
                  ],
                ),
              ),
              if (!narrow) _TotalCounter(total: total),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// All route counter (right, wide only)
// ─────────────────────────────────────────────
class _TotalCounter extends StatelessWidget {
  final int total;
  const _TotalCounter({required this.total});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.circular(c.radiusMd),
        border: Border.all(color: c.borderSubtle, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Wszystkich tras', style: ts.caption),
          const SizedBox(width: 12),
          Text(
            total.toString(),
            style: TextStyle(
              fontFamily: AppColors.fontBody,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: c.textPrimary,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Badge "N w weryfikacji"
// ─────────────────────────────────────────────
class _VerifyBadge extends StatelessWidget {
  final int count;
  const _VerifyBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final ts = AppTextStyles.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1200),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFEF9F27).withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        '$count ${count == 1 ? 'trasa w weryfikacji' : 'trasy w weryfikacji'}',
        style: ts.caption.copyWith(
          color: const Color(0xFFEF9F27),
          fontSize: 11,
        ),
      ),
    );
  }
}
