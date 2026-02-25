import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:milestory_crm/core/core_export.dart';

import '../../creator_export.dart';

class TourPointEditor extends StatefulWidget {
  final String tourId;
  final int tourPointId;
  final VoidCallback addDirecton;
  const TourPointEditor({super.key, required this.tourPointId, required this.tourId, required this.addDirecton});

  @override
  State<TourPointEditor> createState() => _TourPointEditorState();
}

class _TourPointEditorState extends State<TourPointEditor> {
  late final TextEditingController _descriptionController;
  late CreatorBloc _creatorBloc;

  Uint8List? _audioFile;
  String? _audioFileName;
  String? _audioFileId;
  Uint8List? _imageFile;
  String? _imageFileName;
  String? _imageUrl;

  int? _lastTourPointId;

  @override
  void initState() {
    super.initState();
    _creatorBloc = context.read<CreatorBloc>();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _syncControllers(TourPoint tourPoint) {
    if (_lastTourPointId != tourPoint.id) {
      _descriptionController.text = tourPoint.description ?? '';
      _audioFile = tourPoint.audioFile;
      _audioFileName = tourPoint.audioFileName;
      _audioFileId = tourPoint.audioFileId;
      _imageFile = tourPoint.image;
      _imageFileName = tourPoint.imageFileName;
      _imageUrl = tourPoint.imageUrl;
      _lastTourPointId = tourPoint.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatorBloc, CreatorState>(
      builder: (context, state) {
        final currentTourPoint = state.tourPoints.firstWhere(
          (tp) => tp.id == widget.tourPointId,
          orElse: () => throw Exception('TourPoint not found'),
        );

        _syncControllers(currentTourPoint);

        return Container(
          width: 340,
          decoration: const BoxDecoration(border: Border(left: BorderSide(color: Color.fromARGB(255, 49, 49, 49), width: 1.0))),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        _creatorBloc.add(SelectTourPointEvent(tourPointId: widget.tourPointId));
                      },
                      icon: const Icon(FontAwesomeIcons.xmark, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nazwa przystanku", style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: 3),
                      AppContainer(
                        padding: const EdgeInsets.all(13),
                        child: SizedBox(width: 320, child: Text(currentTourPoint.title!, style: Theme.of(context).textTheme.bodySmall)),
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
                          child: SingleChildScrollView(child: Text(currentTourPoint.description!, style: Theme.of(context).textTheme.bodySmall)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  AppContainer(
                    padding: const EdgeInsets.all(10),
                    height: 140,
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: currentTourPoint.areas.length,
                        itemBuilder: (context, index) {
                          final area = currentTourPoint.areas[index];
                          final isSelected = state.selectedAreaId == area.id;
                          return _areaTab(isSelected, area, index, currentTourPoint);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Container(
                  //   width: 320,
                  //   height: 180,
                  //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Colors.grey[200]),
                  // ),
                  AppContainer(child: ImageNetwork(imageUrl: currentTourPoint.imageUrl, width: 320, height: 180, borderRadius: 8.0)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _areaTab(bool isSelected, Area area, int index, TourPoint currentTourPoint) {
    void handleDirectionTap() {
      if (!isSelected) {
        _creatorBloc.add(SelectAreaEvent(areaId: area.id));
        Future.delayed(const Duration(milliseconds: 50), widget.addDirecton);
      } else {
        widget.addDirecton();
      }
    }

    Widget buildDirectionWidget() {
      if (area.direction != null) {
        return GestureDetector(
          onTap: handleDirectionTap,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              '${area.direction!.toStringAsFixed(1)}°',
              style: isSelected ? CustomTextTheme.textTheme.bodyMedium!.copyWith(color: Colors.black) : CustomTextTheme.textTheme.bodyMedium!,
            ),
          ),
        );
      } else {
        return IconButton(onPressed: handleDirectionTap, icon: Icon(Icons.explore_outlined, color: isSelected ? Colors.black : Colors.white));
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          _creatorBloc.add(SelectAreaEvent(areaId: area.id));
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : const Color.fromARGB(255, 49, 49, 49),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 40,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    'Obszar ${index + 1}',
                    style: isSelected ? CustomTextTheme.textTheme.bodyMedium!.copyWith(color: Colors.black) : CustomTextTheme.textTheme.bodyMedium!,
                  ),
                ),
                buildDirectionWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
