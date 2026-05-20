import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../audio/audio_export.dart';
import '../../creator_export.dart';

class TourPointEditor extends StatelessWidget {
  final int tourPointId;
  final VoidCallback addDirecton;
  final VoidCallback closeDirection;

  const TourPointEditor({
    super.key,
    required this.tourPointId,
    required this.addDirecton,
    required this.closeDirection,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return BlocBuilder<CreatorBloc, CreatorState>(
      builder: (context, state) {
        final currentTourPoint = state.tourPoints.firstWhereOrNull(
          (tp) => tp.id == tourPointId,
        );
        if (currentTourPoint == null) return const SizedBox.shrink();

        final pointIndex =
            state.tourPoints.indexWhere((tp) => tp.id == tourPointId) + 1;

        return Container(
          decoration: BoxDecoration(
            color: c.bg,
            border: Border(
              left: BorderSide(color: c.borderSubtle, width: 0.5),
            ),
          ),
          child: Column(
            children: [
              _EditorHeader(
                index: pointIndex,
                title: currentTourPoint.title ?? '',
                onClose: () {
                  closeDirection();
                  context.read<CreatorBloc>().add(
                        SelectTourPointEvent(tourPointId: tourPointId),
                      );
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionCard(
                        label: 'DANE PUNKTU',
                        child: _InfoView(tourPoint: currentTourPoint),
                      ),
                      const SizedBox(height: 16),
                      _SectionCard(
                        label: 'ZDJĘCIE',
                        child: _PhotoView(tourPoint: currentTourPoint),
                      ),
                      if (currentTourPoint.audioFileId != null ||
                          currentTourPoint.audioFile != null) ...[
                        const SizedBox(height: 16),
                        _SectionCard(
                          label: 'AUDIO',
                          child: GlobalAudioPlayer(
                            audioFileId: currentTourPoint.audioFileId,
                            audioBytes: currentTourPoint.audioFile,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      _SectionCard(
                        label: 'OBSZARY',
                        trailingCount: currentTourPoint.areas.length,
                        child: _AreasSection(
                          currentTourPoint: currentTourPoint,
                          selectedAreaId: state.selectedAreaId,
                          onSelectArea: (areaId) {
                            closeDirection();
                            context
                                .read<CreatorBloc>()
                                .add(SelectAreaEvent(areaId: areaId));
                          },
                          onRemoveArea: (areaId) => context
                              .read<CreatorBloc>()
                              .add(RemoveAreaEvent(areaId: areaId)),
                          onOpenDirection: (areaId) {
                            if (state.selectedAreaId != areaId) {
                              context
                                  .read<CreatorBloc>()
                                  .add(SelectAreaEvent(areaId: areaId));
                              Future.delayed(
                                  const Duration(milliseconds: 50), addDirecton);
                            } else {
                              addDirecton();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Info — static text display
// ─────────────────────────────────────────────
class _InfoView extends StatelessWidget {
  final TourPoint tourPoint;
  const _InfoView({required this.tourPoint});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    final title = tourPoint.title?.isNotEmpty == true ? tourPoint.title! : null;
    final desc = tourPoint.description?.isNotEmpty == true ? tourPoint.description! : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(title, style: ts.cardTitle.copyWith(fontSize: 14))
        else
          Text('Brak tytułu', style: ts.caption.copyWith(color: c.textMuted)),
        if (desc != null) ...[
          const SizedBox(height: 10),
          Text(
            desc,
            style: ts.caption.copyWith(color: c.textSecondary, height: 1.55),
          ),
        ] else ...[
          const SizedBox(height: 6),
          Text('Brak opisu', style: ts.caption.copyWith(color: c.textMuted)),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Photo view
// ─────────────────────────────────────────────
class _PhotoView extends StatelessWidget {
  final TourPoint tourPoint;
  const _PhotoView({required this.tourPoint});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    const h = 140.0;

    if (tourPoint.image != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(c.radiusSm),
        child: Image.memory(
          tourPoint.image!,
          width: double.infinity,
          height: h,
          fit: BoxFit.cover,
        ),
      );
    }

    if (tourPoint.imageUrl != null && tourPoint.imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(c.radiusSm),
        child: Image.network(
          tourPoint.imageUrl!,
          width: double.infinity,
          height: h,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(c, ts, h),
        ),
      );
    }

    return _placeholder(c, ts, h);
  }

  Widget _placeholder(AppColors c, AppTextStyles ts, double h) {
    return Container(
      width: double.infinity,
      height: h,
      decoration: BoxDecoration(
        color: c.bgElevated,
        borderRadius: BorderRadius.circular(c.radiusSm),
        border: Border.all(color: c.borderSubtle, width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 28, color: c.textMuted),
          const SizedBox(height: 8),
          Text('Brak zdjęcia', style: ts.caption.copyWith(color: c.textMuted, fontSize: 11)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Editor Header
// ─────────────────────────────────────────────
class _EditorHeader extends StatelessWidget {
  final int index;
  final String title;
  final VoidCallback onClose;

  const _EditorHeader({
    required this.index,
    required this.title,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: c.borderSubtle, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: c.accent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: c.accent,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title.isEmpty ? 'Punkt $index' : title,
              style: ts.cardTitle.copyWith(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          IconActionButton(
            icon: FontAwesomeIcons.xmark,
            color: c.textSecondary,
            tooltip: 'Zamknij',
            onTap: onClose,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Section card
// ─────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String label;
  final Widget child;
  final int? trailingCount;
  const _SectionCard({
    required this.label,
    required this.child,
    this.trailingCount,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return AppContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label, style: ts.sectionLabel.copyWith(fontSize: 11)),
              ),
              if (trailingCount != null)
                Text(
                  '$trailingCount',
                  style: ts.caption.copyWith(fontSize: 11, color: c.textMuted),
                ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Areas Section
// ─────────────────────────────────────────────
class _AreasSection extends StatelessWidget {
  final TourPoint currentTourPoint;
  final String? selectedAreaId;
  final ValueChanged<String> onSelectArea;
  final ValueChanged<String> onRemoveArea;
  final ValueChanged<String> onOpenDirection;

  const _AreasSection({
    required this.currentTourPoint,
    required this.selectedAreaId,
    required this.onSelectArea,
    required this.onRemoveArea,
    required this.onOpenDirection,
  });

  @override
  Widget build(BuildContext context) {
    final ts = AppTextStyles.of(context);
    final canRemove = currentTourPoint.areas.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (currentTourPoint.areas.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Brak obszarów. Kliknij „Dodaj obszar" i narysuj strefę na mapie.',
              style: ts.caption.copyWith(fontSize: 12),
            ),
          )
        else
          Column(
            children: [
              for (int i = 0; i < currentTourPoint.areas.length; i++) ...[
                _AreaRow(
                  area: currentTourPoint.areas[i],
                  index: i + 1,
                  isSelected: selectedAreaId == currentTourPoint.areas[i].id,
                  canRemove: canRemove,
                  onTap: () => onSelectArea(currentTourPoint.areas[i].id),
                  onRemove: () => onRemoveArea(currentTourPoint.areas[i].id),
                  onOpenDirection: () =>
                      onOpenDirection(currentTourPoint.areas[i].id),
                ),
                if (i < currentTourPoint.areas.length - 1)
                  const SizedBox(height: 6),
              ],
            ],
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Single Area Row
// ─────────────────────────────────────────────
class _AreaRow extends StatefulWidget {
  final Area area;
  final int index;
  final bool isSelected;
  final bool canRemove;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onOpenDirection;

  const _AreaRow({
    required this.area,
    required this.index,
    required this.isSelected,
    required this.canRemove,
    required this.onTap,
    required this.onRemove,
    required this.onOpenDirection,
  });

  @override
  State<_AreaRow> createState() => _AreaRowState();
}

class _AreaRowState extends State<_AreaRow> {
  static const _animDuration = Duration(milliseconds: 120);
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    final Color bgColor;
    final Color borderColor;
    final Color fgColor;

    if (widget.isSelected) {
      bgColor = c.accent.withValues(alpha: 0.12);
      borderColor = c.accent.withValues(alpha: 0.5);
      fgColor = c.accent;
    } else if (_hover) {
      bgColor = c.textPrimary.withValues(alpha: 0.04);
      borderColor = c.borderSubtle;
      fgColor = c.textPrimary;
    } else {
      bgColor = c.textPrimary.withValues(alpha: 0.0);
      borderColor = c.borderSubtle;
      fgColor = c.textSecondary;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: _animDuration,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(c.radiusSm),
            border: Border.all(color: borderColor, width: 0.5),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: _animDuration,
                  style: ts.caption.copyWith(
                    fontSize: 12,
                    color: fgColor,
                    fontWeight: widget.isSelected
                        ? FontWeight.w500
                        : FontWeight.w400,
                  ),
                  child: Text('Obszar ${widget.index}'),
                ),
              ),
              if (widget.area.direction != null) ...[
                const SizedBox(width: 8),
                _DirectionPill(
                  direction: widget.area.direction!,
                  onTap: widget.onOpenDirection,
                ),
              ],
              const SizedBox(width: 8),
              _DeleteAreaButton(
                enabled: widget.isSelected && widget.canRemove,
                onTap: widget.onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Direction Pill
// ─────────────────────────────────────────────
class _DirectionPill extends StatefulWidget {
  final double direction;
  final VoidCallback onTap;

  const _DirectionPill({required this.direction, required this.onTap});

  @override
  State<_DirectionPill> createState() => _DirectionPillState();
}

class _DirectionPillState extends State<_DirectionPill> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final ts = AppTextStyles.of(context);
    const greenColor = Color(0xFF1D9E75);
    final bg = greenColor.withValues(alpha: _hover ? 0.22 : 0.14);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(FontAwesomeIcons.compass, size: 10, color: greenColor),
              const SizedBox(width: 5),
              Text(
                '${widget.direction.toStringAsFixed(0)}°',
                style: ts.caption.copyWith(
                  fontSize: 11,
                  color: greenColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Delete area button
// ─────────────────────────────────────────────
class _DeleteAreaButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool enabled;
  const _DeleteAreaButton({required this.onTap, this.enabled = true});

  @override
  State<_DeleteAreaButton> createState() => _DeleteAreaButtonState();
}

class _DeleteAreaButtonState extends State<_DeleteAreaButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final hoverable = widget.enabled;

    return MouseRegion(
      cursor: hoverable ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) {
        if (hoverable) setState(() => _hover = true);
      },
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: hoverable ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: _hover
                ? SemanticColors.danger.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.trashCan,
              size: 10,
              color: hoverable
                  ? SemanticColors.danger
                  : SemanticColors.danger.withValues(alpha: 0.25),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Add Area Button
// ─────────────────────────────────────────────
class _AddAreaButton extends StatefulWidget {
  final bool active;
  final VoidCallback onTap;
  const _AddAreaButton({required this.active, required this.onTap});

  @override
  State<_AddAreaButton> createState() => _AddAreaButtonState();
}

class _AddAreaButtonState extends State<_AddAreaButton> {
  static const _animDuration = Duration(milliseconds: 120);
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    final Color fg;
    final Color bg;
    final Color border;
    if (widget.active) {
      fg = c.accent;
      bg = c.accent.withValues(alpha: 0.14);
      border = c.accent.withValues(alpha: 0.5);
    } else if (_hover) {
      fg = c.textPrimary;
      bg = c.textPrimary.withValues(alpha: 0.04);
      border = c.borderSubtle;
    } else {
      fg = c.textSecondary;
      bg = c.textPrimary.withValues(alpha: 0.0);
      border = c.borderSubtle;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: _animDuration,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(c.radiusSm),
            border: Border.all(color: border, width: 0.5),
          ),
          child: TweenAnimationBuilder<Color?>(
            duration: _animDuration,
            tween: ColorTween(end: fg),
            builder: (context, color, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.plus, size: 10, color: color),
                  const SizedBox(width: 8),
                  Text(
                    widget.active ? 'Rysowanie obszaru...' : 'Dodaj obszar',
                    style: ts.caption.copyWith(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
