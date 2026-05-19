import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/core_export.dart';
import '../../../tour/tour_export.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SZYBKIE AKCJE',
              style: AppTextStyles.of(context)
                  .sectionLabel
                  .copyWith(fontSize: 11)),
          const SizedBox(height: 16),
          BlocBuilder<TourBloc, TourState>(
            builder: (context, state) {
              final blocked = state.hasActiveSlot;
              final blocking = state.blockingTour;
              return _ActionRow(
                icon: FontAwesomeIcons.plus,
                iconBg: const Color(0xFF0C2A4A),
                iconColor: const Color(0xFF378ADD),
                title: 'Nowa trasa',
                subtitle: blocked && blocking != null
                    ? slotBlockedSubtitle(blocking.status, blocking.title)
                    : 'przejdź do kreatora tras',
                onTap: blocked && blocking != null
                    ? () => showSlotOccupiedDialog(
                          context,
                          TourStatusData.mapStatusEnumToApiString(
                              blocking.status),
                        )
                    : () => context.goNamed(RouteConstants.dashboard),
              );
            },
          ),
          const SizedBox(height: 6),
          BlocBuilder<TourBloc, TourState>(
            builder: (context, state) {
              final n = state.tours
                  .where((t) => t.status == TourStatus.published)
                  .length;
              return _ActionRow(
                icon: FontAwesomeIcons.earthEurope,
                iconBg: const Color(0xFF062A1E),
                iconColor: const Color(0xFF1D9E75),
                title: 'Moje trasy publiczne',
                subtitle: '$n dostępnych dla turystów',
                onTap: () => context.goNamed(RouteConstants.dashboard,
                    queryParameters: {'status': TourStatusData.mapStatusEnumToApiString(TourStatus.published)}),
              );
            },
          ),
          const SizedBox(height: 6),
          BlocBuilder<TourBloc, TourState>(
            builder: (context, state) {
              final v = state.tours
                  .where((t) => t.status == TourStatus.pendingReview)
                  .length;
              return _ActionRow(
                icon: FontAwesomeIcons.clockRotateLeft,
                iconBg: const Color(0xFF2D1E00),
                iconColor: const Color(0xFFEF9F27),
                title: 'Trasy w weryfikacji',
                subtitle: v > 0
                    ? '$v ${v == 1 ? 'czeka' : 'czekają'} na akceptację'
                    : 'brak oczekujących',
                onTap: () => context.goNamed(RouteConstants.dashboard,
                    queryParameters: {'status': TourStatusData.mapStatusEnumToApiString(TourStatus.pendingReview)}),
                badge: v > 0 ? v : null,
              );
            },
          ),
        ],
      ),
    );
  }

}

class _ActionRow extends StatefulWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title, subtitle;
  final VoidCallback onTap;
  final int? badge;

  const _ActionRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badge,
  });

  @override
  State<_ActionRow> createState() => _ActionRowState();
}

class _ActionRowState extends State<_ActionRow> {
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
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: widget.iconBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(widget.icon, size: 14, color: widget.iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: ts.cardTitle.copyWith(fontSize: 13)),
                    const SizedBox(height: 1),
                    Text(widget.subtitle,
                        style: ts.caption.copyWith(fontSize: 11)),
                  ],
                ),
              ),
              if (widget.badge != null)
                NumberCircle(number: widget.badge!, color: widget.iconColor)
              else
                Icon(Icons.chevron_right, size: 16, color: c.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
