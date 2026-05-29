import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:milestory_admin/features/tour/tour_export.dart';

import '../../creator_export.dart';

class CreatorTopTab extends StatelessWidget {
  final bool isExternelId;
  final Tour tour;
  final VoidCallback? onRejectionBadgeTap;
  final bool isRejectionCardVisible;

  const CreatorTopTab({
    super.key,
    required this.isExternelId,
    required this.tour,
    this.onRejectionBadgeTap,
    this.isRejectionCardVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return BlocBuilder<TourBloc, TourState>(
      builder: (context, state) {
        final selected = state.selectedTour;
        final currentTour = (selected != null && selected.id == tour.id)
            ? selected
            : tour;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          decoration: BoxDecoration(
            color: c.bg,
            border: Border(bottom: BorderSide(color: c.borderSubtle, width: 0.5)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: c.bgInput,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(FontAwesomeIcons.mapLocationDot, size: 12, color: c.accent),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentTour.title.isEmpty ? 'Bez tytułu' : currentTour.title,
                            style: ts.cardTitle.copyWith(fontSize: 13, color: c.textPrimary),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            'Podgląd punktów trasy',
                            style: ts.caption.copyWith(fontSize: 11, color: c.textMuted),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (currentTour.status == TourStatus.rejected) ...[
                    IconActionButton(
                      icon: FontAwesomeIcons.circleExclamation,
                      iconSize: 12,
                      color: isRejectionCardVisible
                          ? TourStatus.private.color
                          : TourStatus.rejected.color,
                      tooltip: 'Powód odrzucenia',
                      onTap: onRejectionBadgeTap,
                    ),
                    const SizedBox(width: 6),
                  ],
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTapDown: (d) => _showStatusMenu(context, currentTour, d.globalPosition),
                      child: StatusPill(status: currentTour.status),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

const _statuses = [TourStatus.published, TourStatus.private, TourStatus.rejected];
const _statusLabels = {
  TourStatus.published: 'Publiczna',
  TourStatus.private: 'Prywatna',
  TourStatus.rejected: 'Odrzucona',
};

void _showStatusMenu(BuildContext context, Tour tour, Offset pos) {
  final c = AppColors.of(context);
  final ts = AppTextStyles.of(context);

  showMenu<TourStatus>(
    context: context,
    color: c.bgCard,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(c.radiusMd),
      side: BorderSide(color: c.borderSubtle, width: 0.5),
    ),
    position: RelativeRect.fromLTRB(pos.dx - 160, pos.dy + 8, pos.dx, pos.dy),
    items: _statuses.map((status) {
      final isCurrent = status == tour.status;
      final color = status.color;
      return PopupMenuItem<TourStatus>(
        value: status,
        enabled: !isCurrent,
        padding: EdgeInsets.zero,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          color: isCurrent ? color.withValues(alpha: 0.07) : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrent ? color : color.withValues(alpha: 0.45),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _statusLabels[status]!,
                  style: ts.caption.copyWith(
                    fontSize: 13,
                    color: isCurrent ? color : c.textPrimary,
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (isCurrent) Icon(Icons.check, size: 14, color: color),
            ],
          ),
        ),
      );
    }).toList(),
  ).then((selected) {
    if (selected == null || selected == tour.status) return;
    if (!context.mounted) return;
    final bloc = context.read<TourBloc>();
    if (selected == TourStatus.rejected) {
      _showRejectionDialog(context, tour, bloc);
    } else {
      final label = _statusLabels[selected]!;
      showAppConfirmDialog(
        context: context,
        title: 'Zmiana statusu',
        content: 'Czy chcesz zmienić status trasy na „$label"?',
        confirmText: 'Zmień',
        onConfirm: () => bloc.add(ChangeStatusEvent(
          tourId: tour.id!,
          targetStatus: selected,
          sourceStatus: tour.status,
        )),
      );
    }
  });
}

void _showRejectionDialog(BuildContext context, Tour tour, TourBloc bloc) {
  showDialog<void>(
    context: context,
    builder: (_) => _RejectionDialog(
      onConfirm: (reason) => bloc.add(ChangeStatusEvent(
        tourId: tour.id!,
        targetStatus: TourStatus.rejected,
        sourceStatus: tour.status,
        rejectionReason: reason,
      )),
    ),
  );
}

// ─────────────────────────────────────────────
// Dialog powodu odrzucenia
// ─────────────────────────────────────────────
class _RejectionDialog extends StatefulWidget {
  final ValueChanged<String> onConfirm;
  const _RejectionDialog({required this.onConfirm});

  @override
  State<_RejectionDialog> createState() => _RejectionDialogState();
}

class _RejectionDialogState extends State<_RejectionDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canConfirm => _controller.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    const rejColor = Color(0xFFE24B4A);

    return AlertDialog(
      backgroundColor: c.bgCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(c.radiusMd),
        side: const BorderSide(color: Color(0x66E24B4A), width: 0.5),
      ),
      title: Row(
        children: [
          const Icon(Icons.cancel_outlined, color: rejColor, size: 20),
          const SizedBox(width: 8),
          Text('Odrzuć trasę', style: ts.cardTitle.copyWith(color: rejColor)),
        ],
      ),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Podaj powód odrzucenia. Przewodnik zobaczy tę wiadomość.',
              style: ts.caption.copyWith(fontSize: 13, height: 1.55),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _controller,
              maxLines: 4,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Opisz co należy poprawić...',
                hintStyle: ts.caption.copyWith(color: c.textMuted),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Anuluj', style: ts.caption.copyWith(color: c.textSecondary)),
        ),
        TextButton(
          onPressed: _canConfirm
              ? () {
                  Navigator.of(context).pop();
                  widget.onConfirm(_controller.text.trim());
                }
              : null,
          style: TextButton.styleFrom(
            backgroundColor: _canConfirm ? const Color(0x26E24B4A) : Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(c.radiusSm)),
          ),
          child: Text(
            'Odrzuć',
            style: ts.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: _canConfirm ? rejColor : c.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}
