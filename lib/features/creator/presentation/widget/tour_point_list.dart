import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../creator_export.dart';

class TourPointList extends StatefulWidget {
  const TourPointList({super.key});

  @override
  State<TourPointList> createState() => _TourPointListState();
}

class _TourPointListState extends State<TourPointList> {
  bool _hintsVisible = true;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return BlocBuilder<CreatorBloc, CreatorState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: c.bg,
            border: Border(
              left: BorderSide(color: c.borderSubtle, width: 0.5),
            ),
          ),
          width: 340,
          child: state.tourPoints.isEmpty
              ? _buildEmptyState(context)
              : _buildList(context, state),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // Empty state — onboarding
  // ─────────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.bgElevated,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: c.borderSubtle, width: 0.5),
            ),
            child: Icon(
              FontAwesomeIcons.mapPin,
              size: 16,
              color: c.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Brak punktów trasy',
            style: ts.cardTitle.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            'Narysuj obszar na mapie żeby dodać pierwszy punkt.',
            style: ts.caption.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 24),
          _buildStep(
            context,
            number: '1',
            text:
                'Kliknij dowolne miejsce na mapie — zaczniesz rysować obszar punktu',
          ),
          const SizedBox(height: 12),
          _buildStep(
            context,
            number: '2',
            text: 'Zamknij obszar wracając do pierwszego punktu na mapie',
          ),
          const SizedBox(height: 12),
          _buildStep(
            context,
            number: '3',
            text:
                'Punkt pojawi się na tej liście — kliknij go żeby dodać tytuł, opis i audio',
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF041525),
              borderRadius: BorderRadius.circular(c.radiusMd),
              border: Border.all(color: const Color(0xFF0D2A45), width: 0.5),
            ),
            child: Row(
              children: [
                const Icon(
                  FontAwesomeIcons.circleInfo,
                  size: 12,
                  color: Color(0xFF378ADD),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Trasa musi mieć co najmniej jeden punkt z przypisanym obszarem żeby można ją było opublikować.',
                    style: ts.caption.copyWith(
                      fontSize: 11,
                      color: const Color(0xFF85B7EB),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required String number,
    required String text,
  }) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: c.bgElevated,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.borderSubtle, width: 0.5),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: c.textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              text,
              style: ts.caption.copyWith(fontSize: 12, height: 1.45),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Points list
  // ─────────────────────────────────────────────
  Widget _buildList(BuildContext context, CreatorState state) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    final list = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Row(
            children: [
              Text(
                'Punkty trasy',
                style: ts.cardTitle.copyWith(fontSize: 13),
              ),
              const Spacer(),
              Text(
                '${state.tourPoints.length} ${_pointsLabel(state.tourPoints.length)}',
                style: ts.caption.copyWith(fontSize: 11, color: c.textMuted),
              ),
            ],
          ),
        ),
        Container(height: 0.5, color: c.borderSubtle),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: state.tourPoints.length,
            itemBuilder: (context, index) {
              final tourPoint = state.tourPoints[index];
              final isSelected =
                  state.selectedTourPoint?.id == tourPoint.id;
              return _PointTile(
                tourPoint: tourPoint,
                index: index,
                isSelected: isSelected,
              );
            },
          ),
        ),
      ],
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        list,
        Positioned(
          left: 14,
          right: 14,
          bottom: 14,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _hintsVisible ? 1.0 : 0.0,
            child: IgnorePointer(
              ignoring: !_hintsVisible,
              child: HintsPanel(
                onClose: () => setState(() => _hintsVisible = false),
                items: const [
                  HintItem(
                    icon: FontAwesomeIcons.circleInfo,
                    iconColor: Color(0xFF378ADD),
                    iconBg: Color(0xFF041525),
                    title: 'Punkt musi mieć obszar',
                    text:
                        'Obszar to strefa na mapie w której turysta usłyszy nagranie. Jeden punkt może mieć wiele obszarów.',
                  ),
                  HintItem(
                    icon: FontAwesomeIcons.compass,
                    iconColor: Color(0xFF1D9E75),
                    iconBg: Color(0xFF031410),
                    title: 'Kierunek odtwarzania',
                    text:
                        'Możesz ustawić z jakiego kierunku turysta musi podejść do obszaru żeby usłyszeć audio.',
                  ),
                  HintItem(
                    icon: FontAwesomeIcons.circleCheck,
                    iconColor: Color(0xFFEF9F27),
                    iconBg: Color(0xFF2D1E00),
                    title: 'Kropki kompletności',
                    text:
                        'Zielona kropka = uzupełnione. Kolejność: tytuł · opis · audio · zdjęcie (opcjonalne).',
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 14,
          bottom: 14,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _hintsVisible ? 0.0 : 1.0,
            child: IgnorePointer(
              ignoring: _hintsVisible,
              child: IconActionButton(
                iconSize: 20,
                icon: FontAwesomeIcons.lightbulb,
                color: c.accent,
                tooltip: 'Pokaż wskazówki',
                onTap: () => setState(() => _hintsVisible = true),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _pointsLabel(int count) {
    if (count == 1) return 'punkt';
    if (count >= 2 && count <= 4) return 'punkty';
    return 'punktów';
  }
}

// ─────────────────────────────────────────────
// Single point
// ─────────────────────────────────────────────
class _PointTile extends StatefulWidget {
  final TourPoint tourPoint;
  final int index;
  final bool isSelected;

  const _PointTile({
    required this.tourPoint,
    required this.index,
    required this.isSelected,
  });

  @override
  State<_PointTile> createState() => _PointTileState();
}

class _PointTileState extends State<_PointTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    final effectiveTitle = widget.tourPoint.title;
    final hasTitle = effectiveTitle != null && effectiveTitle.isNotEmpty;
    final isSavedInDb = widget.tourPoint.tourId != null;

    final Color bgColor;
    final Color borderColor;
    if (widget.isSelected && isSavedInDb) {
      bgColor = c.accent.withValues(alpha: 0.12);
      borderColor = c.accent.withValues(alpha: 0.5);
    } else if (_hover) {
      bgColor = c.bgInput;
      borderColor = c.borderSubtle;
    } else {
      bgColor = Colors.transparent;
      borderColor = c.borderSubtle;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: GestureDetector(
          onTap: () => context
              .read<CreatorBloc>()
              .add(SelectTourPointEvent(tourPointId: widget.tourPoint.id)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(c.radiusSm),
              border: Border.all(color: borderColor, width: 0.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: c.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Center(
                    child: Text(
                      '${widget.index + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: c.accent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hasTitle
                        ? effectiveTitle
                        : 'Punkt ${widget.index + 1}',
                    style: ts.cardTitle.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: (!hasTitle || !isSavedInDb)
                          ? c.textMuted
                          : (widget.isSelected ? c.accent : c.textPrimary),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                _CompletionDots(tourPoint: widget.tourPoint),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Dots of Completeness: Title · Description · Audio · Photo
// ─────────────────────────────────────────────
class _CompletionDots extends StatelessWidget {
  final TourPoint tourPoint;
  const _CompletionDots({required this.tourPoint});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    final hasTitle = tourPoint.title?.isNotEmpty ?? false;
    final hasDesc = tourPoint.description?.isNotEmpty ?? false;
    final hasAudio = tourPoint.audioFileId != null || tourPoint.audioFileName != null;
    final hasImage = tourPoint.imageUrl != null || tourPoint.image != null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dot(hasTitle, c),
        const SizedBox(width: 3),
        _dot(hasDesc, c),
        const SizedBox(width: 3),
        _dot(hasAudio, c),
        const SizedBox(width: 3),
        _dot(hasImage, c, optional: true),
      ],
    );
  }

  Widget _dot(bool filled, AppColors c, {bool optional = false}) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? const Color(0xFF1D9E75) : c.bgElevated,
        border: filled
            ? null
            : Border.all(
                color: optional
                    ? c.borderSubtle.withValues(alpha: 0.5)
                    : c.borderSubtle,
                width: 0.5,
              ),
      ),
    );
  }
}
