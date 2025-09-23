import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:milestory_crm/features/creator/creator_export.dart';

import '../../../../core/core_export.dart';
import '../../../tour_management/tour_managenent_export.dart';

class TopTab extends StatefulWidget {
  final Tour tour;
  const TopTab({super.key, required this.tour});

  @override
  State<TopTab> createState() => _TopTabState();
}

class _TopTabState extends State<TopTab> {
  late TourManagementBloc _tourBloc;

  @override
  void initState() {
    super.initState();
    _tourBloc = context.read<TourManagementBloc>();
  }

  @override
  void dispose() {
    _tourBloc.add(SelectTourEvent(tourId: null));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatorBloc, CreatorState>(
      builder: (context, state) {
        return SizedBox(
          height: 70,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.tour.title, style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                GlobalErrorListener<TourManagementBloc, TourManagementState>(
                  child: BlocBuilder<TourManagementBloc, TourManagementState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          SizedBox(
                            height: 32,
                            width: 121.5,
                            child: OutlinedButton(
                              onPressed:
                                  () => showConfirmationDialog(
                                    context: context,
                                    title: "Usuń trasę",
                                    content: "Na pewno? Trasa będize na stałe utracona!",
                                    onPressed: () {
                                      //_tourBloc.add(DeleteTourEvent(tourId: state.selectedTour!.id!));
                                      _tourBloc.add(SelectTourEvent(tourId: null));
                                      context.pop();
                                    },
                                  ),
                              child:
                                  state.deleteTourLoading
                                      ? const SizedBox(height: 17, width: 17, child: CircularProgressIndicator(strokeWidth: 2))
                                      : const Text("Usuń trasę"),
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            height: 32,
                            width: 121.5,
                            child: OutlinedButton(
                              onPressed:
                                  () => showConfirmationDialog(
                                    context: context,
                                    title: "Publikacja trasy",
                                    content: "Opublikować trasę dla wszystkicgh użytkowników?",
                                    onPressed: () => _tourBloc.add(SetPublicTourEvent(tourId: widget.tour.id!)),
                                  ),
                              child:
                                  state.publishLoading
                                      ? const SizedBox(height: 17, width: 17, child: CircularProgressIndicator(strokeWidth: 2))
                                      : const Text("Publikuj trasę"),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
