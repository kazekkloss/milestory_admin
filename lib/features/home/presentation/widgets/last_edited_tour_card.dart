import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/core_export.dart';
import '../../../tour/tour_export.dart';

class LastEditedTourCard extends StatelessWidget {
  const LastEditedTourCard({super.key});

  @override
  Widget build(BuildContext context) {
    final tour = context.select<TourBloc, Tour?>((b) {
      final tours = b.state.allTours;
      if (tours.isEmpty) return null;
      return tours.reduce((a, b) {
        final da = a.updatedAt;
        final db = b.updatedAt;
        if (da == null) return b;
        if (db == null) return a;
        return da.isAfter(db) ? a : b;
      });
    });

    if (tour == null) return const SizedBox.shrink();

    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    final dateStr = tour.updatedAt != null
        ? DateFormat('d MMM yyyy', 'pl_PL').format(tour.updatedAt!)
        : '';

    return AppContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('OSTATNIO EDYTOWANA',
              style: ts.sectionLabel.copyWith(fontSize: 11)),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              tour.title.isEmpty ? '—' : tour.title,
              style: ts.cardTitle.copyWith(fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              StatusPill(status: tour.status, size: 20),
              const SizedBox(width: 8),
              Text(
                '${tour.pointLength} ${_pointsLabel(tour.pointLength)}',
                style: ts.caption.copyWith(fontSize: 11),
              ),
            ],
          ),
          if (dateStr.isNotEmpty) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(dateStr, style: ts.caption.copyWith(fontSize: 11)),
            ),
          ],
          const SizedBox(height: 10),
          Container(height: 1, color: c.borderSubtle),
          const SizedBox(height: 6),
          _EditButton(
            onTap: () => context.goNamed(RouteConstants.creator, extra: tour),
          ),
        ],
      ),
    );
  }

  String _pointsLabel(int n) {
    if (n == 1) return 'punkt';
    if (n >= 2 && n <= 4) return 'punkty';
    return 'punktów';
  }
}

class _EditButton extends StatefulWidget {
  final VoidCallback onTap;
  const _EditButton({required this.onTap});

  @override
  State<_EditButton> createState() => _EditButtonState();
}

class _EditButtonState extends State<_EditButton> {
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
                  'Edytuj trasę',
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
