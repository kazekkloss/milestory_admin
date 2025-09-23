import 'dart:typed_data';
import 'package:equatable/equatable.dart';

import '../../creator_export.dart';

class TourPoint extends Equatable {
  final String? externalId;
  final int id;
  final String? tourId;
  final String? title;
  final String? description;
  final List<Area> areas;

  final Uint8List? image;
  final String? imageFileName;
  final String? imageUrl;

  final Uint8List? audioFile;
  final String? audioFileId;
  final String? audioFileName;

  const TourPoint({
    this.externalId,
    required this.id,
    this.tourId,
    required this.title,
    required this.description,
    required this.areas,
    this.audioFile,
    this.audioFileId,
    this.audioFileName,
    this.image,
    this.imageFileName,
    this.imageUrl,
  });

  TourPoint copyWith({
    String? externalId,
    int? id,
    String? tourId,
    String? title,
    String? description,
    List<Area>? areas,
    Uint8List? image,
    Object? imageFileName = _undefined,
    Object? imageUrl = _undefined,
    Uint8List? audioFile,
    String? audioFileId,
    String? audioFileName,
  }) {
    return TourPoint(
      externalId: externalId ?? this.externalId,
      id: id ?? this.id,
      tourId: tourId ?? this.tourId,
      title: title ?? this.title,
      description: description ?? this.description,
      areas: areas ?? this.areas,
      image: image ?? this.image,
      imageFileName: imageFileName == _undefined ? this.imageFileName : imageFileName as String?,
      imageUrl: imageUrl == _undefined ? this.imageUrl : imageUrl as String?,
      audioFile: audioFile ?? this.audioFile,
      audioFileId: audioFileId ?? this.audioFileId,
      audioFileName: audioFileName ?? this.audioFileName,
    );
  }

  static const _undefined = Object();

  @override
  List<Object?> get props => [
        externalId,
        id,
        tourId,
        title,
        description,
        areas,
        audioFile,
        audioFileName,
        audioFileId,
        image,
        imageUrl,
        imageFileName,
      ];
}
