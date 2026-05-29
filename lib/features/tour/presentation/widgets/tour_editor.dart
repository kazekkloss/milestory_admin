import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../audio/audio_export.dart';
import '../../../creator/creator_export.dart';
import '../../tour_export.dart';

class TourEditor extends StatefulWidget {
  const TourEditor({super.key});

  @override
  State<TourEditor> createState() => _TourEditorState();
}

class _TourEditorState extends State<TourEditor> {
  late TourBloc _tourBloc;

  @override
  void initState() {
    super.initState();
    _tourBloc = context.read<TourBloc>();
  }

  @override
  void dispose() {
    _tourBloc.add(SelectTourEvent(tourId: null));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return BlocListener<TourBloc, TourState>(
      listenWhen: (previous, current) =>
          previous.selectedTour != current.selectedTour &&
          current.selectedTour != null &&
          current.selectedTour != Tour.empty,
      listener: (context, state) {
        final tourId = state.selectedTour?.id;
        if (tourId != null && tourId.isNotEmpty) {
          context.read<CreatorBloc>().add(GetTourPointsEvent(tourId: tourId));
        }
      },
      child: BlocBuilder<TourBloc, TourState>(
        buildWhen: (previous, current) =>
            previous.selectedTour != current.selectedTour,
        builder: (context, state) {
          final tour = state.selectedTour;
          final isEmpty = tour == null || tour == Tour.empty;

          if (isEmpty) {
            return AppContainer(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FontAwesomeIcons.route, size: 24, color: c.textMuted),
                    const SizedBox(height: 12),
                    Text(
                      'Wybierz trasę z listy',
                      style: AppTextStyles.of(context).caption,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return AppContainer(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: c.borderSubtle, width: 0.5),
                    ),
                  ),
                  child: SizedBox(
                    height: 48,
                    child: Align(
                      alignment: Alignment.center,
                      child: _ActionBar(selectedTour: tour),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: _TourInfoView(tour: tour),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Read-only tour info
// ─────────────────────────────────────────────
class _TourInfoView extends StatelessWidget {
  final Tour tour;
  const _TourInfoView({required this.tour});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    final modeLabel = TransportModeData.mapRouteEnumToString(tour.transportMode);
    final modeIcon = TransportModeData.mapRouteEnumToIcon(tour.transportMode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tour.imageUrl != null && tour.imageUrl!.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(c.radiusSm),
            child: Image.network(
              tour.imageUrl!,
              width: double.infinity,
              height: 140,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (tour.audioFileId != null && tour.audioFileId!.isNotEmpty ||
            tour.audioFile != null) ...[
          SectionCard(
            label: 'AUDIO',
            child: GlobalAudioPlayer(
              audioFileId: tour.audioFileId,
              audioBytes: tour.audioFile,
            ),
          ),
          const SizedBox(height: 16),
        ],
        SectionCard(
          label: 'DANE TRASY',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tour.title.isEmpty ? 'Bez tytułu' : tour.title,
                style: ts.cardTitle.copyWith(fontSize: 15),
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
                Text(
                  tour.description,
                  style: ts.caption.copyWith(color: c.textSecondary, height: 1.55),
                ),
              ],
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Owner ID: ${tour.authorId}',
                      style: ts.caption.copyWith(
                        fontSize: 10,
                        color: c.textMuted,
                        fontFamily: 'monospace',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconActionButton(
                    icon: FontAwesomeIcons.copy,
                    iconSize: 11,
                    color: c.textMuted,
                    tooltip: 'Kopiuj ID',
                    onTap: () => Clipboard.setData(
                      ClipboardData(text: tour.authorId),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Action bar
// ─────────────────────────────────────────────
class _ActionBar extends StatelessWidget {
  final Tour selectedTour;
  const _ActionBar({required this.selectedTour});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 32,
          child: OutlinedButton.icon(
            onPressed: () => context.goNamed(
              RouteConstants.creator,
              extra: selectedTour,
            ),
            icon: const Icon(FontAwesomeIcons.mapLocationDot, size: 11),
            label: const Text('Podgląd mapy'),
          ),
        ),
        StatusPill(status: selectedTour.status, size: 22),
        IconActionButton(
          icon: FontAwesomeIcons.xmark,
          color: c.textSecondary,
          tooltip: 'Zamknij',
          onTap: () => context
              .read<TourBloc>()
              .add(SelectTourEvent(tourId: selectedTour.id!)),
        ),
      ],
    );
  }
}
