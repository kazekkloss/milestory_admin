import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core_export.dart';
import '../../../tour_management/tour_managenent_export.dart';

class TopTab extends StatefulWidget {
  const TopTab({super.key});

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
    return GlobalErrorListener<TourManagementBloc, TourManagementState>(
      child: BlocBuilder<TourManagementBloc, TourManagementState>(
        builder: (context, state) {
          final statusIcon = TourStatusData.mapStatusEnumToIcon(state.selectedTour!.status);
          final statusText = TourStatusData.mapStatusEnumToString(state.selectedTour!.status);

          return SizedBox(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 5,
                        children: [
                          Text(statusText, style: CustomTextTheme.textTheme.labelSmall!),
                          Icon(statusIcon.icon, color: Colors.white, size: 16),
                        ],
                      ),
                      SizedBox(width: 20),
                      Text(state.selectedTour!.title, style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      state.selectedTour!.status == TourStatus.verify ||
                              state.selectedTour!.status == TourStatus.edited ||
                              state.selectedTour!.status == TourStatus.private
                          ? SizedBox(
                            height: 32,
                            width: 121.5,
                            child: OutlinedButton(
                              onPressed:
                                  () => showConfirmationDialog(
                                    context: context,
                                    title: "Publikacja trasy",
                                    content: "Opublikować trasę dla wszystkicgh użytkowników?",
                                    onPressed: () => _tourBloc.add(SetPublicTourEvent(tourId: state.selectedTour!.id!)),
                                  ),
                              child:
                                  state.publishLoading
                                      ? const SizedBox(height: 17, width: 17, child: CircularProgressIndicator(strokeWidth: 2))
                                      : const Text("Publikuj trasę"),
                            ),
                          )
                          : state.selectedTour!.status == TourStatus.public
                          ? SizedBox(
                            height: 32,
                            width: 158,
                            child: OutlinedButton(
                              onPressed:
                                  () => showConfirmationDialog(
                                    context: context,
                                    title: "Zmiana statusu trasy",
                                    content: "Jeśli zmienisz trasę na prywatną, nie będzie ona widoczna dla innych użytkowników. Kontynuować?",
                                    onPressed: () => _tourBloc.add(SetPrivateTourEvent(tourId: state.selectedTour!.id!)),
                                  ),
                              child:
                                  state.publishLoading
                                      ? const SizedBox(height: 17, width: 17, child: CircularProgressIndicator(strokeWidth: 2))
                                      : const Text("Zmień na prywatną"),
                            ),
                          )
                          : SizedBox(),
                      SizedBox(width: 10),
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
                                  _tourBloc.add(DeleteTourEvent(tourId: state.selectedTour!.id!));
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
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
