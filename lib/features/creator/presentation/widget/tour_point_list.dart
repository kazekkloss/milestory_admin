import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../creator_export.dart';

class TourPointList extends StatelessWidget {
  const TourPointList({super.key});

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
              ? _buildEmptyState(context, c)
              : _buildList(context, state, c),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, AppColors c) {
    final ts = AppTextStyles.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: c.bgElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: c.borderSubtle, width: 0.5),
              ),
              child: Icon(FontAwesomeIcons.mapPin, size: 16, color: c.textSecondary),
            ),
            const SizedBox(height: 16),
            Text('Brak punktów trasy', style: ts.cardTitle.copyWith(fontSize: 14)),
            const SizedBox(height: 6),
            Text(
              'Ta trasa nie ma jeszcze żadnych punktów.',
              style: ts.caption.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, CreatorState state, AppColors c) {
    final ts = AppTextStyles.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Row(
            children: [
              Text('Punkty trasy', style: ts.cardTitle.copyWith(fontSize: 13)),
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
              final isSelected = state.selectedTourPoint?.id == tourPoint.id;
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
                    hasTitle ? effectiveTitle : 'Punkt ${widget.index + 1}',
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
