import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_export.dart';
import '../../tour_export.dart';

class TourPreviewCard extends StatelessWidget {
  const TourPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TourBloc, TourState>(
      buildWhen: (prev, curr) => prev.selectedTour != curr.selectedTour,
      builder: (context, state) {
        final tour = state.selectedTour;
        final isEmpty = tour == null || tour == Tour.empty;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isEmpty
              ? const SizedBox.shrink(key: ValueKey('empty'))
              : _Preview(key: ValueKey(tour.id), tour: tour),
        );
      },
    );
  }
}

class _Preview extends StatelessWidget {
  final Tour tour;
  const _Preview({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    final modeLabel = TransportModeData.mapRouteEnumToString(tour.transportMode);
    final modeIcon = TransportModeData.mapRouteEnumToIcon(tour.transportMode);

    Widget? imageWidget;
    if (tour.image != null) {
      imageWidget = Image.memory(
        tour.image!,
        height: 140,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (tour.imageUrl != null && tour.imageUrl!.isNotEmpty) {
      imageWidget = Image.network(
        tour.imageUrl!,
        height: 140,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.bgCard,
        border: Border.all(color: c.borderSubtle),
        borderRadius: BorderRadius.circular(c.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.map_outlined, size: 14, color: c.accent),
              const SizedBox(width: 6),
              Text('PODGLĄD TRASY', style: ts.sectionLabel),
            ],
          ),
          const SizedBox(height: 14),
          if (imageWidget != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(c.radiusSm),
              child: imageWidget,
            ),
            const SizedBox(height: 14),
          ],
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              tour.title.isEmpty ? 'Bez tytułu' : tour.title,
              style: ts.cardTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: c.accent.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(c.radiusSm),
              border: Border.all(color: c.accent.withValues(alpha: 0.14)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconTheme(
                  data: IconThemeData(size: 13, color: c.textSecondary),
                  child: modeIcon,
                ),
                const SizedBox(width: 5),
                Text(
                  modeLabel,
                  style: ts.caption.copyWith(fontSize: 11, color: c.textSecondary),
                ),
              ],
            ),
          ),
          if (tour.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                tour.description,
                style: ts.caption.copyWith(color: c.textSecondary, height: 1.55),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
