import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core_export.dart';
import '../../../tour/tour_export.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final isMobile = SizeConfig.isNarrow(context);

    return BlocBuilder<TourBloc, TourState>(
      builder: (context, state) {
        final tours = state.allTours;
        final total = state.stats?.totalTours ?? tours.length;
        final publicCount =
            tours.where((t) => t.status == TourStatus.published).length;
        final verifyCount = tours
            .where((t) => t.status == TourStatus.pendingReview)
            .length;
        final audioPoints = tours.fold<int>(0, (sum, t) => sum + t.pointLength);

        final tiles = [
          _M('Wszystkie', total.toString(), 'łącznie', c.textPrimary),
          _M('Publiczne', publicCount.toString(), 'dostępne',
              const Color(0xFF1D9E75)),
          _M('Weryfikacja', verifyCount.toString(), 'oczekują',
              const Color(0xFFEF9F27)),
          _M('Punkty audio', audioPoints.toString(), 'łącznie', c.accent),
        ];

        return AppContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("STATYSTYKI TRAS",
                  style: AppTextStyles.of(context)
                      .sectionLabel
                      .copyWith(fontSize: 11)),
              const SizedBox(height: 16),
              isMobile ? _wrapLayout(context, tiles) : _rowLayout(tiles),
            ],
          ),
        );
      },
    );
  }

  Widget _rowLayout(List<_M> tiles) {
    return Row(
      children: [
        for (int i = 0; i < tiles.length; i++) ...[
          Expanded(child: _MetricTile(data: tiles[i])),
          if (i < tiles.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }

  Widget _wrapLayout(BuildContext context, List<_M> tiles) {
    return LayoutBuilder(
      builder: (_, box) {
        final w = (box.maxWidth - 10) / 2;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: tiles
              .map((t) => SizedBox(width: w, child: _MetricTile(data: t)))
              .toList(),
        );
      },
    );
  }
}

class _M {
  final String label, value, sub;
  final Color color;
  const _M(this.label, this.value, this.sub, this.color);
}

class _MetricTile extends StatelessWidget {
  final _M data;
  const _MetricTile({required this.data});

  @override
  Widget build(BuildContext context) {
    final ts = AppTextStyles.of(context);

    return HoverCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.label, style: ts.caption.copyWith(fontSize: 11)),
          const SizedBox(height: 6),
          Text(
            data.value,
            style: TextStyle(
              fontFamily: AppColors.fontBody,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: data.color,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.sub,
            style: ts.caption.copyWith(
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
