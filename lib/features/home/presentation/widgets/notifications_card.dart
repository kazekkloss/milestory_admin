import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core_export.dart';
import '../../../tour/tour_export.dart';

class NotificationsCard extends StatelessWidget {
  const NotificationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TourBloc, TourState>(
      builder: (context, state) {
        final notifs = _build(state.allTours);

        return AppContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('POWIADOMIENIA',
                      style: AppTextStyles.of(context)
                          .sectionLabel
                          .copyWith(fontSize: 11)),
                  if (notifs.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    NumberCircle(
                      number: notifs.length,
                      color: notifs.first.tour.status.color,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 14),
              if (notifs.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('Brak nowych powiadomień.',
                      style: AppTextStyles.of(context).caption),
                )
              else
                ...notifs.map((n) => _Item(n: n)),
            ],
          ),
        );
      },
    );
  }

  List<_N> _build(List<Tour> tours) {
    final r = <_N>[];
    for (final t in tours.where((t) => t.status == TourStatus.pendingReview)) {
      r.add(_N(
          'Trasa ',
          ' jest w trakcie weryfikacji. Jeśli się powiedzie zostanie ona upubliczniona.',
          t));
    }
    for (final t in tours.where((t) => t.status == TourStatus.rejected)) {
      r.add(
          _N('Trasa ', ' została odrzucona. Sprawdź powód i popraw trasę.', t));
    }
    r.sort((a, b) {
      final da = a.tour.updatedAt;
      final db = b.tour.updatedAt;
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      return db.compareTo(da);
    });
    return r;
  }
}

class _N {
  final String prefix;
  final String suffix;
  final Tour tour;
  const _N(this.prefix, this.suffix, this.tour);
}

class _Item extends StatefulWidget {
  final _N n;

  const _Item({required this.n});

  @override
  State<_Item> createState() => _ItemState();
}

class _ItemState extends State<_Item> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.n.tour.status.color;

    final c = AppColors.of(context);
    final narrow = SizeConfig.isNarrow(context);

    final icon = switch (widget.n.tour.status) {
      TourStatus.pendingReview => Icons.access_time_outlined,
      TourStatus.rejected => Icons.error_outline,
      _ => Icons.info_outline,
    };

    final baseStyle = AppTextStyles.of(context).caption.copyWith(
          color: AppColors.of(context).textSecondary,
          fontSize: 12,
        );

    return MouseRegion(
      cursor: narrow ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: !narrow
            ? () => context.goNamed(
                  RouteConstants.creator,
                  extra: widget.n.tour,
                )
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered
                ? color.withValues(alpha: 0.20)
                : color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered ? color : color.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: baseStyle,
                    children: [
                      TextSpan(text: widget.n.prefix),
                      TextSpan(
                        text: widget.n.tour.title,
                        style: TextStyle(
                          color: c.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: widget.n.suffix),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right,
                  size: 14, color: color.withValues(alpha: 0.6)),
            ],
          ),
        ),
      ),
    );
  }
}
