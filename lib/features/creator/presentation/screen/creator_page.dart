import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../../core/core_export.dart';
import '../../creator_export.dart';

class CreatorPage extends StatefulWidget {
  final Tour tour;
  const CreatorPage({super.key, required this.tour});

  @override
  State<CreatorPage> createState() => _CreatorPageState();
}

class _CreatorPageState extends State<CreatorPage> {
  bool _showDirectionWidget = false;
  Offset _arrowPosition = const Offset(20, 90);
  late CreatorBloc _creatorBloc;

  @override
  void initState() {
    _creatorBloc = context.read<CreatorBloc>();
    _creatorBloc.add(GetTourPointsEvent(tourId: widget.tour.id!));
    super.initState();
  }

  void _toggleDirectionWidget(bool isVisible) {
    setState(() {
      _showDirectionWidget = isVisible;
      if (isVisible) {
        _arrowPosition = const Offset(20, 90);
      }
    });
  }

  void _updateArrowPosition(DragUpdateDetails details) {
    setState(() {
      _arrowPosition += details.delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalErrorListener<CreatorBloc, CreatorState>(
      child: BlocBuilder<CreatorBloc, CreatorState>(
        builder: (context, state) {
          return Scaffold(
            body: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [TopTab(tour: widget.tour), MapWidget(tourId: widget.tour.id!)]),
                      if (_showDirectionWidget)
                        Positioned(
                          top: _arrowPosition.dy,
                          left: _arrowPosition.dx,
                          child: GestureDetector(
                            onPanUpdate: _updateArrowPosition,
                            child: PointerInterceptor(
                              child: RotatableArrowWidget(
                                selectedAreaId: state.selectedAreaId!,
                                selectedTourPointId: state.selectedTourPoint!.id,
                                closeDirecton: () => _toggleDirectionWidget(false),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                state.selectedTourPoint != null
                    ? TourPointEditor(
                      tourId: widget.tour.id!,
                      key: ValueKey(state.selectedTourPoint!.id),
                      tourPointId: state.selectedTourPoint!.id,
                      addDirecton: () => _toggleDirectionWidget(true),
                    )
                    : const TourPointList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
