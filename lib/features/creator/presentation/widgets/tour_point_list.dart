import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_export.dart';
import '../../creator_export.dart';

class TourPointList extends StatelessWidget {
  const TourPointList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatorBloc, CreatorState>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(border: Border(left: BorderSide(color: Color.fromARGB(255, 49, 49, 49), width: 1.0))),
          width: 340,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text("Wszystkie punkty: ${state.tourPoints.length}", style: Theme.of(context).textTheme.labelMedium),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.tourPoints.length,
                    itemBuilder: (context, index) {
                      final tourPoint = state.tourPoints[index];
                      final isSelected = state.selectedTourPoint?.id == tourPoint.id;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          trailing: tourPoint.audioFileId != null ? const Icon(Icons.save_outlined, size: 15, color: Colors.white) : null,
                          title: Text(tourPoint.title ?? 'Punkt ${index + 1}'),
                          selected: isSelected,
                          onTap: () {
                            context.read<CreatorBloc>().add(SelectTourPointEvent(tourPointId: tourPoint.id));
                          },
                        ),
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