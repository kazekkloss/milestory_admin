import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core_export.dart';
import '../../../tour/tour_export.dart';
import '../../home_export.dart';

class OnboardingChecklistCard extends StatelessWidget {
  const OnboardingChecklistCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return BlocBuilder<TourBloc, TourState>(
      builder: (context, tourState) {
        final tours = tourState.allTours;

        // TODO: dostosuj poniższe sprawdzenia do swojego modelu Tour i TourStatusData
        final hasAccount = true;
        final hasAnyRoute = tours.isNotEmpty;
        final hasAudioPoints = tours.any((t) => t.pointLength > 0);
        final hasInVerification = tours.any((t) =>
            t.status == TourStatus.pendingReview ||
            t.status == TourStatus.published ||
            t.status == TourStatus.private);
        final hasPublished = tours.any((t) => t.status == TourStatus.published);

        final steps = <_OnboardingStep>[
          _OnboardingStep(
            label: 'Załóż konto przewodnika',
            done: hasAccount,
            route: null,
          ),
          _OnboardingStep(
            label: 'Stwórz pierwszą trasę',
            done: hasAnyRoute,
            route: '/dashboard',
          ),
          _OnboardingStep(
            label: 'Dodaj punkty audio',
            done: hasAudioPoints,
            route: '/dashboard',
          ),
          _OnboardingStep(
            label: 'Wyślij trasę do weryfikacji',
            done: hasInVerification,
            route: '/dashboard',
          ),
          _OnboardingStep(
            label: 'Pierwsza publikacja',
            done: hasPublished,
            route: '/dashboard',
          ),
        ];

        final completedCount = steps.where((s) => s.done).length;
        final allDone = completedCount == steps.length;

        if (allDone) return const InspirationCard();

        final nextStep = steps.firstWhere((s) => !s.done);

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('PIERWSZE KROKI',
                      style: ts.sectionLabel.copyWith(fontSize: 11)),
                  Text(
                    '$completedCount / ${steps.length}',
                    style: ts.caption.copyWith(fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: completedCount / steps.length,
                  minHeight: 4,
                  backgroundColor: c.borderSubtle,
                  valueColor:
                      const AlwaysStoppedAnimation(SemanticColors.success),
                ),
              ),
              const SizedBox(height: 16),
              ...steps.map((step) => _StepRow(step: step)),
              const SizedBox(height: 8),
              Container(height: 1, color: c.borderSubtle),
              const SizedBox(height: 6),
              if (nextStep.route != null)
                _NextStepButton(
                  label: nextStep.label,
                  onTap: () => context.go(nextStep.route!),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _NextStepButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NextStepButton({required this.label, required this.onTap});

  @override
  State<_NextStepButton> createState() => _NextStepButtonState();
}

class _NextStepButtonState extends State<_NextStepButton> {
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
                  widget.label,
                  style: ts.cardTitle.copyWith(fontSize: 13, color: c.accent),
                  overflow: TextOverflow.ellipsis,
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

class _OnboardingStep {
  final String label;
  final bool done;
  final String? route;

  _OnboardingStep({
    required this.label,
    required this.done,
    required this.route,
  });
}

class _StepRow extends StatelessWidget {
  final _OnboardingStep step;
  const _StepRow({required this.step});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          if (step.done)
            Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: SemanticColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 11, color: Colors.black),
            )
          else
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: c.borderSubtle, width: 1.5),
              ),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              step.label,
              style: step.done
                  ? ts.caption.copyWith(
                      color: c.textMuted,
                      decoration: TextDecoration.lineThrough,
                    )
                  : ts.caption.copyWith(color: c.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
