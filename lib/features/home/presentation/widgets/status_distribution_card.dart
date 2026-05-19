import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_export.dart';
import '../../../tour/tour_export.dart';

class StatusDistributionCard extends StatelessWidget {
  const StatusDistributionCard({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<TourBloc, TourState>(
      builder: (context, state) {
        final tours = state.allTours;
        final total = tours.isEmpty ? 1 : tours.length;

        final rows = [
          _Row(
              'Publiczne',
              tours.where((t) => t.status == TourStatus.published).length,
              total,
              const Color(0xFF1D9E75)),
          _Row(
              'Prywatne',
              tours.where((t) => t.status == TourStatus.private).length,
              total,
              const Color(0xFF888780)),
          _Row(
              'Weryfikacja',
              tours.where((t) => t.status == TourStatus.pendingReview).length,
              total,
              const Color(0xFFEF9F27)),
          _Row(
              'Szkice',
              tours.where((t) => t.status == TourStatus.draft).length,
              total,
              const Color(0xFF378ADD)),
          _Row(
              'Odrzucone',
              tours.where((t) => t.status == TourStatus.rejected).length,
              total,
              const Color(0xFFE05252)),
        ];

        return AppContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ROZKŁAD STATUSÓW',
                  style: AppTextStyles.of(context)
                      .sectionLabel
                      .copyWith(fontSize: 11)),
              const SizedBox(height: 16),
              for (int i = 0; i < rows.length; i++)
                _StatusRow(data: rows[i], isLast: i == rows.length - 1),
            ],
          ),
        );
      },
    );
  }
}

class _Row {
  final String label;
  final int count, total;
  final Color color;
  const _Row(this.label, this.count, this.total, this.color);
}

class _StatusRow extends StatelessWidget {
  final _Row data;
  final bool isLast;
  const _StatusRow({required this.data, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    final fraction = data.total > 0 ? data.count / data.total : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                    color: c.borderSubtle.withValues(alpha: 0.3), width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration:
                BoxDecoration(color: data.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(data.label, style: ts.caption.copyWith(fontSize: 12)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: fraction.clamp(0.0, 1.0),
                backgroundColor: c.bgElevated,
                valueColor: AlwaysStoppedAnimation<Color>(data.color),
                minHeight: 4,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 22,
            child: Text(
              data.count.toString(),
              style: ts.caption.copyWith(
                color: c.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
