import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/core_export.dart';
import '../../../tour/tour_export.dart';

class NotificationsCard extends StatelessWidget {
  const NotificationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ts = AppTextStyles.of(context);

    return BlocBuilder<TourBloc, TourState>(
      builder: (context, state) {
        final pending = (state.allTours
            .where((t) => t.status == TourStatus.pendingReview)
            .toList()
          ..sort((a, b) {
            final da = a.updatedAt;
            final db = b.updatedAt;
            if (da == null && db == null) return 0;
            if (da == null) return 1;
            if (db == null) return -1;
            return db.compareTo(da);
          }));

        return AppContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('DO WERYFIKACJI',
                      style: ts.sectionLabel.copyWith(fontSize: 11)),
                  if (pending.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    NumberCircle(
                      number: pending.length,
                      color: SemanticColors.warning,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 14),
              if (pending.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('Brak tras oczekujących na weryfikację.',
                      style: ts.caption),
                )
              else
                ...pending.map((t) => _PendingItem(tour: t)),
            ],
          ),
        );
      },
    );
  }
}

class _PendingItem extends StatefulWidget {
  final Tour tour;
  const _PendingItem({required this.tour});

  @override
  State<_PendingItem> createState() => _PendingItemState();
}

class _PendingItemState extends State<_PendingItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    final color = SemanticColors.warning;

    final date = widget.tour.updatedAt != null
        ? DateFormat('d MMM yyyy, HH:mm', 'pl_PL').format(widget.tour.updatedAt!)
        : '—';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.goNamed(
          RouteConstants.creator,
          extra: widget.tour,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered
                ? color.withValues(alpha: 0.18)
                : color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered ? color : color.withValues(alpha: 0.35),
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.access_time_outlined, size: 15, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tour.title.isEmpty ? 'Bez tytułu' : widget.tour.title,
                      style: ts.cardTitle.copyWith(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date,
                      style: ts.caption.copyWith(fontSize: 11, color: c.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, size: 14, color: color.withValues(alpha: 0.6)),
            ],
          ),
        ),
      ),
    );
  }
}
