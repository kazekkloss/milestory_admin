import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:milestory_admin/features/auth/presentation/auth_bloc/auth_bloc.dart';

import '../../../../core/core_export.dart';
import '../../tour_export.dart';
import 'contextual_hints.dart';

class TourList extends StatefulWidget {
  final TourStatus? initialStatus;

  const TourList({super.key, this.initialStatus});

  static TourStatus? lastSelectedStatus;

  @override
  State<TourList> createState() => _TourListState();
}

class _TourListState extends State<TourList> {
  late TourBloc _tourBloc;
  late AuthState _authState;
  int _currentPage = 1;
  TourStatus? _selectedStatus;
  bool _hintsVisible = true;

  static const _filterOptions = <TourStatus?>[
    null,
    TourStatus.draft,
    TourStatus.pendingReview,
    TourStatus.published,
    TourStatus.rejected,
    TourStatus.private,
  ];

  static const _filterLabels = <TourStatus?, String>{
    null: 'Wszystkie',
    TourStatus.draft: 'Szkic',
    TourStatus.pendingReview: 'Weryfikacja',
    TourStatus.published: 'Publiczne',
    TourStatus.rejected: 'Odrzucone',
    TourStatus.private: 'Prywatne',
  };

  @override
  void initState() {
    super.initState();
    _authState = context.read<AuthBloc>().state;
    _tourBloc = context.read<TourBloc>();

    _selectedStatus = widget.initialStatus;
    TourList.lastSelectedStatus = _selectedStatus;

    _tourBloc.add(GetToursEvent(
      userId: _authState.user.guideUserId ?? '',
      tourStatus: _selectedStatus,
    ));
  }

  void _applyFilter(TourStatus? status) {
    setState(() {
      _selectedStatus = status;
      _currentPage = 1;
      TourList.lastSelectedStatus = status;
    });
    _tourBloc.add(SelectTourEvent(tourId: null));
    _tourBloc.add(GetToursEvent(
      page: _currentPage,
      tourStatus: status,
      userId: _authState.user.guideUserId ?? '',
    ));
  }

  void _loadMore() {
    setState(() => _currentPage++);
    _tourBloc.add(GetToursEvent(
      page: _currentPage,
      tourStatus: _selectedStatus,
      isLoadMore: true,
      userId: _authState.user.guideUserId ?? '',
    ));
  }

  Widget _buildScrollArea({
    required Widget content,
    required bool narrow,
    required double pad,
  }) {
    final switcher = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.topCenter,
        children: [...previous, if (current != null) current],
      ),
      child: KeyedSubtree(
        key: ValueKey(_selectedStatus),
        child: content,
      ),
    );

    if (narrow) {
      return Padding(
        padding: EdgeInsets.fromLTRB(pad, 0, pad, pad),
        child: switcher,
      );
    }
    return Expanded(child: switcher);
  }

  @override
  Widget build(BuildContext context) {
    final narrow = SizeConfig.isNarrow(context);
    final c = AppColors.of(context);

    return BlocBuilder<TourBloc, TourState>(
      builder: (context, tourState) {
        final hasRejectionReason =
            tourState.selectedTour?.rejectionReason?.isNotEmpty ?? false;
        final effectiveHintsVisible =
            !hasRejectionReason || _hintsVisible;
        final innerPad = narrow ? 16.0 : 20.0;

        final content = tourState.getToursLoading && tourState.tours.isEmpty
            ? const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              )
            : _TourScrollView(
                state: tourState,
                onLoadMore: _loadMore,
                shrinkWrap: narrow,
              );

        return Padding(
          padding: EdgeInsets.fromLTRB(
            narrow ? 16 : 28,
            24,
            narrow ? 16 : 28,
            narrow ? 16 : 20,
          ),
          child: AppContainer(
            padding: const EdgeInsets.only(bottom: 20),
            child: Stack(
              fit: narrow ? StackFit.loose : StackFit.expand,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.fromLTRB(innerPad, innerPad, innerPad, 14),
                      child: _FilterBar(
                        options: _filterOptions,
                        labels: _filterLabels,
                        selected: _selectedStatus,
                        onSelect: _applyFilter,
                        onRefresh: () => _applyFilter(_selectedStatus),
                      ),
                    ),
                    _buildScrollArea(
                      content: content,
                      narrow: narrow,
                      pad: innerPad,
                    ),
                    if (narrow)
                      Padding(
                        padding: EdgeInsets.fromLTRB(innerPad, 8, innerPad, 0),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: effectiveHintsVisible
                              ? _HintsOverlay(
                                  key: const ValueKey('hints'),
                                  selectedStatus: _selectedStatus,
                                  rejectionReason:
                                      tourState.selectedTour?.rejectionReason,
                                  isVisible: effectiveHintsVisible,
                                  onClose: () =>
                                      setState(() => _hintsVisible = false),
                                )
                              : Align(
                                  key: const ValueKey('bulb'),
                                  alignment: Alignment.centerLeft,
                                  child: IconActionButton(
                                    iconSize: 20,
                                    icon: FontAwesomeIcons.lightbulb,
                                    color: c.accent,
                                    tooltip: 'Pokaż wskazówki',
                                    onTap: () =>
                                        setState(() => _hintsVisible = true),
                                  ),
                                ),
                        ),
                      ),
                  ],
                ),
                if (!narrow) ...[
                  Positioned(
                    left: innerPad,
                    right: innerPad,
                    bottom: 0,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: effectiveHintsVisible ? 1.0 : 0.0,
                      child: IgnorePointer(
                        ignoring: !effectiveHintsVisible,
                        child: _HintsOverlay(
                          selectedStatus: _selectedStatus,
                          rejectionReason:
                              tourState.selectedTour?.rejectionReason,
                          isVisible: effectiveHintsVisible,
                          onClose: () =>
                              setState(() => _hintsVisible = false),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: innerPad,
                    bottom: 0,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: effectiveHintsVisible ? 0.0 : 1.0,
                      child: IgnorePointer(
                        ignoring: effectiveHintsVisible,
                        child: IconActionButton(
                          iconSize: 20,
                          icon: FontAwesomeIcons.lightbulb,
                          color: c.accent,
                          tooltip: "Pokaż wskazówki",
                          onTap: () => setState(() => _hintsVisible = true),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter bar
// ─────────────────────────────────────────────────────────────────────────────
class _FilterBar extends StatelessWidget {
  final List<TourStatus?> options;
  final Map<TourStatus?, String> labels;
  final TourStatus? selected;
  final ValueChanged<TourStatus?> onSelect;
  final VoidCallback onRefresh;

  const _FilterBar({
    required this.options,
    required this.labels,
    required this.selected,
    required this.onSelect,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final status in options) ...[
                  StatusPill(
                    status: status,
                    label: labels[status],
                    selected: selected == status,
                    onTap: () => onSelect(status),
                  ),
                  const SizedBox(width: 6),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconActionButton(
          icon: FontAwesomeIcons.arrowRotateRight,
          color: c.textSecondary,
          tooltip: "Odśwież",
          onTap: onRefresh,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyList extends StatelessWidget {
  const _EmptyList();

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: c.bgElevated,
              borderRadius: BorderRadius.circular(c.radiusMd),
              border: Border.all(color: c.borderSubtle, width: 0.5),
            ),
            child:
                Icon(FontAwesomeIcons.route, size: 20, color: c.textSecondary),
          ),
          const SizedBox(height: 14),
          Text('Brak tras', style: ts.cardTitle.copyWith(fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            SizeConfig.isNarrow(context)
                ? 'Dodaj pierwszą trasę w edytorze poniżej.'
                : 'Dodaj pierwszą trasę w edytorze po prawej.',
            style: ts.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tour scroll view
// ─────────────────────────────────────────────────────────────────────────────
class _TourScrollView extends StatelessWidget {
  final TourState state;
  final VoidCallback onLoadMore;
  final bool shrinkWrap;

  const _TourScrollView({
    required this.state,
    required this.onLoadMore,
    this.shrinkWrap = false,
  });

  int _crossAxisCount(double width) {
    if (width < 700) return 1;
    if (width < 1100) return 2;
    return 3;
  }

  List<List<Tour>> _chunkTours(List<Tour> tours, int cross) {
    final rows = <List<Tour>>[];
    for (int i = 0; i < tours.length; i += cross) {
      rows.add(tours.sublist(i, (i + cross).clamp(0, tours.length)));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final tours = state.tours;
    if (tours.isEmpty) return const _EmptyList();

    return LayoutBuilder(
      builder: (_, box) {
        final cross = _crossAxisCount(box.maxWidth);
        final rows = _chunkTours(tours, cross);
        final canLoadMore = tours.length % 20 == 0;
        final sidePad = shrinkWrap ? 0.0 : 20.0;

        return SingleChildScrollView(
          physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
          child: Padding(
            padding: EdgeInsets.fromLTRB(sidePad, 0, sidePad, sidePad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < rows.length; i++) ...[
                  _TourRow(
                    tours: rows[i],
                    cross: cross,
                    selectedId: state.selectedTour?.id,
                  ),
                  if (i < rows.length - 1) const SizedBox(height: 8),
                ],
                if (canLoadMore) ...[
                  const SizedBox(height: 12),
                  _LoadMoreButton(onTap: onLoadMore),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tour row
// ─────────────────────────────────────────────────────────────────────────────
class _TourRow extends StatelessWidget {
  final List<Tour> tours;
  final int cross;
  final String? selectedId;

  const _TourRow({
    required this.tours,
    required this.cross,
    required this.selectedId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          for (int i = 0; i < cross; i++) ...[
            Expanded(
              child: i < tours.length
                  ? TourTab(tour: tours[i], selected: tours[i].id == selectedId)
                  : const SizedBox.shrink(),
            ),
            if (i < cross - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Load more
// ─────────────────────────────────────────────────────────────────────────────
class _LoadMoreButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LoadMoreButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 40,
        width: 150,
        child: GlowButton(
          onPressed: onTap,
          text: 'Załaduj więcej',
          isLoading: false,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TourTab
// ─────────────────────────────────────────────────────────────────────────────
class TourTab extends StatefulWidget {
  final Tour tour;
  final bool selected;

  const TourTab({super.key, required this.tour, required this.selected});

  @override
  State<TourTab> createState() => _TourTabState();
}

class _TourTabState extends State<TourTab> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    final formattedDate = widget.tour.createdAt != null
        ? DateFormat('d MMM yyyy', 'pl_PL').format(widget.tour.createdAt!)
        : '—';

    final Color bgColor;
    if (widget.selected) {
      bgColor = c.bgInput;
    } else if (_hovering) {
      bgColor = Color.lerp(c.bgCard, c.bgInput, 0.6)!;
    } else {
      bgColor = c.bgCard;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context
            .read<TourBloc>()
            .add(SelectTourEvent(tourId: widget.tour.id!)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(c.radiusSm),
            border: Border.all(
              color: widget.selected ? c.accent : c.accentBorder,
              width: widget.selected ? 1.0 : 0.5,
            ),
          ),
          child: Row(
            children: [
              _TourThumbnail(
                imageUrl: widget.tour.imageUrl,
                imageBytes: widget.tour.image,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tour.title.isEmpty
                          ? 'Bez tytułu'
                          : widget.tour.title,
                      style: ts.cardTitle.copyWith(
                        fontSize: 13,
                        fontWeight:
                            widget.selected ? FontWeight.w600 : FontWeight.w500,
                        color: (widget.selected || _hovering)
                            ? c.accent
                            : c.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Flexible(
                      child: Text(
                        '$formattedDate · ${widget.tour.pointLength} ${_pointsLabel(widget.tour.pointLength)}',
                        style: ts.caption.copyWith(
                          fontSize: 11,
                          color:
                              widget.selected ? c.textSecondary : c.textMuted,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              StatusPill(status: widget.tour.status, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

String _pointsLabel(int count) {
  if (count == 1) return 'punkt';
  if (count >= 2 && count <= 4) return 'punkty';
  return 'punktów';
}

// ─────────────────────────────────────────────────────────────────────────────
// Thumbnail
// ─────────────────────────────────────────────────────────────────────────────
class _TourThumbnail extends StatelessWidget {
  final String? imageUrl;
  final dynamic imageBytes;

  const _TourThumbnail({required this.imageUrl, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    const size = 58.0;
    const radius = 9.0;

    if (imageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.memory(
          imageBytes!,
          width: size,
          height: size,
          fit: BoxFit.fitHeight,
        ),
      );
    }

    return ImageNetwork(
      imageUrl: imageUrl,
      width: size,
      height: size,
      borderRadius: radius,
      fit: BoxFit.fitHeight,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hints overlay
// ─────────────────────────────────────────────────────────────────────────────
class _HintsOverlay extends StatelessWidget {
  final TourStatus? selectedStatus;
  final bool isVisible;
  final String? rejectionReason;
  final VoidCallback onClose;

  const _HintsOverlay({
    super.key,
    required this.selectedStatus,
    required this.isVisible,
    required this.onClose,
    this.rejectionReason,
  });

  static Widget _transition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: _transition,
      child: rejectionReason != null
          ? RejectedReasonPanel(
              onClose: onClose,
              key: const ValueKey('r'),
              rejectionReason: rejectionReason!)
          : ContextualHints(
              onClose: onClose,
              key: ValueKey(selectedStatus),
              selectedStatus: selectedStatus),
    );
  }
}
