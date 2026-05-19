import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milestory_admin/features/creator/creator_export.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../tour/tour_export.dart';

class CreatorPage extends StatefulWidget {
  final Tour tour;
  const CreatorPage({super.key, required this.tour});

  @override
  State<CreatorPage> createState() => _CreatorPageState();
}

class _CreatorPageState extends State<CreatorPage>
    with DraggablePanelMixin<CreatorPage> {
  late CreatorBloc _creatorBloc;
  bool _isRejectionCardVisible = false;

  @override
  void initState() {
    _creatorBloc = context.read<CreatorBloc>();
    _creatorBloc.add(ResetCreatorEvent());
    _creatorBloc.add(GetTourPointsEvent(tourId: widget.tour.id!));
    _isRejectionCardVisible = widget.tour.status == TourStatus.rejected &&
        (widget.tour.rejectionReason?.isNotEmpty ?? false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return BlocSelector<TourBloc, TourState, (TourStatus, String?)>(
      selector: (tourState) {
        final selected = tourState.selectedTour;
        final t = (selected != null && selected.id == widget.tour.id)
            ? selected
            : widget.tour;
        return (t.status, t.rejectionReason);
      },
      builder: (context, tourData) {
        final currentTourStatus = tourData.$1;
        final rejectionReason = tourData.$2;
        final hasRejectionReason =
            rejectionReason != null && rejectionReason.isNotEmpty;

        return BlocBuilder<CreatorBloc, CreatorState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: c.bg,
              body: Row(
                children: [
                  // ── Left side: topbar + map (with floating buttons) ──
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CreatorTopTab(
                          isExternelId: state.tourPoints.any(
                            (tourPoint) => tourPoint.externalId != null,
                          ),
                          tour: widget.tour,
                          isRejectionCardVisible: _isRejectionCardVisible,
                          onRejectionBadgeTap: hasRejectionReason
                              ? () => setState(() => _isRejectionCardVisible =
                                  !_isRejectionCardVisible)
                              : null,
                        ),
                        Expanded(
                          child: Stack(
                            key: stackKey,
                            children: [
                              MapWidget(
                                tourId: widget.tour.id!,
                                tourStatus: currentTourStatus,
                              ),

                              // Floating: rejection reason card (top left)
                              Positioned(
                                bottom: 40,
                                left: 48,
                                right: 48,
                                child: PointerInterceptor(
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 150),
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0, 0.06),
                                            end: Offset.zero,
                                          ).animate(CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeOut)),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: _isRejectionCardVisible &&
                                            currentTourStatus ==
                                                TourStatus.rejected &&
                                            rejectionReason != null &&
                                            rejectionReason.isNotEmpty
                                        ? RejectedReasonPanel(
                                            key: const ValueKey(
                                                'rejection_card'),
                                            rejectionReason: rejectionReason,
                                            onClose: () => setState(() {
                                              _isRejectionCardVisible = false;
                                            }),
                                          )
                                        : const SizedBox.shrink(
                                            key: ValueKey('empty')),
                                  ),
                                ),
                              ),
                              // Floating: undo last marker (bottom left)
                              Positioned(
                                left: 20,
                                top: 20,
                                child: PointerInterceptor(
                                  child: const StepBackButton(),
                                ),
                              ),

                              // Floating: direction panel (draggable)
                              if (isPanelVisible &&
                                  state.selectedTourPoint != null &&
                                  state.selectedAreaId != null)
                                Positioned(
                                  top: panelOffset.dy,
                                  right: panelOffset.dx,
                                  child: PointerInterceptor(
                                    child: RotatableArrowWidget(
                                      key: panelKey,
                                      selectedAreaId: state.selectedAreaId!,
                                      selectedTourPointId:
                                          state.selectedTourPoint!.id,
                                      closeDirecton: () => togglePanel(false),
                                      onDragHandle: updatePanelPosition,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ── Right side: list of points + editor (slide-in) ──
                  SizedBox(
                    width: 340,
                    child: Stack(
                      children: [
                        const TourPointList(
                          key: ValueKey('tour_point_list'),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 320),
                          reverseDuration: const Duration(milliseconds: 280),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic,
                              )),
                              child: child,
                            );
                          },
                          child: state.selectedTourPoint != null
                              ? TourPointEditor(
                                  key: ValueKey(state.selectedTourPoint!.id),
                                  tourPointId: state.selectedTourPoint!.id,
                                  addDirecton: () => togglePanel(true),
                                  closeDirection: () => togglePanel(false),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
