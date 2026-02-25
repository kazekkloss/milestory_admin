import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:milestory_crm/core/core_export.dart';

import '../bloc/tour_management_bloc.dart';

class TourInfo extends StatefulWidget {
  const TourInfo({super.key});

  @override
  State<TourInfo> createState() => _TourInfoState();
}

class _TourInfoState extends State<TourInfo> {
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
    return BlocBuilder<TourManagementBloc, TourManagementState>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(border: Border(left: BorderSide(color: Color.fromARGB(255, 49, 49, 49), width: 1.0))),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      height: 40,
                      child:
                          state.selectedTour!.id!.isEmpty
                              ? null
                              : ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 320),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () => context.goNamed(RouteConstants.creator, extra: state.selectedTour),
                                      child: const Text("Przejdź do trasy"),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        context.read<TourManagementBloc>().add(SelectTourEvent(tourId: state.selectedTour!.id!));
                                      },
                                      icon: const Icon(FontAwesomeIcons.xmark, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nazwa trasy", style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: 3),
                      AppContainer(
                        padding: const EdgeInsets.all(13),
                        child: SizedBox(width: 320, child: Text(state.selectedTour!.title, style: Theme.of(context).textTheme.bodySmall)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Czym się poruszać?", style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: 3),
                      AppContainer(
                        padding: const EdgeInsets.all(13),
                        child: SizedBox(
                          width: 320,
                          child: Row(
                            children: [
                              state.selectedTour!.transportMode != TransportMode.none
                                  ? Icon(
                                    TransportModeData.mapRouteEnumToIcon(state.selectedTour!.transportMode).icon!,
                                    color: Colors.white,
                                    size: 18,
                                  )
                                  : SizedBox(),
                              const SizedBox(width: 8),
                              Text(
                                state.selectedTour!.transportMode != TransportMode.none
                                    ? TransportModeData.mapRouteEnumToString(state.selectedTour!.transportMode)
                                    : "",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Opis trasy", style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: 3),
                      AppContainer(
                        padding: const EdgeInsets.all(13),
                        child: SizedBox(
                          width: 320,
                          height: 244,
                          child: SingleChildScrollView(child: Text(state.selectedTour!.description, style: Theme.of(context).textTheme.bodySmall)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  AppContainer(child: ImageNetwork(imageUrl: state.selectedTour!.imageUrl, width: 320, height: 180, borderRadius: 8.0)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
