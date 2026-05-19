import 'dart:typed_data';
import 'package:equatable/equatable.dart';

import '../../../features/creator/creator_export.dart';

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
  final String? imageUrlToDelete;

  final Uint8List? audioFile;
  final String? audioFileId;
  final String? audioFileName;
  final int? audioDuration;

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
    this.audioDuration,
    this.image,
    this.imageFileName,
    this.imageUrl,
    this.imageUrlToDelete,
  });

  TourPoint copyWith({
    String? externalId,
    int? id,
    String? tourId,
    String? title,
    String? description,
    List<Area>? areas,
    Object? image = _undefined,
    Object? imageFileName = _undefined,
    Object? imageUrl = _undefined,
    Object? imageUrlToDelete = _undefined,
    Object? audioFile = _undefined,
    String? audioFileId,
    String? audioFileName,
    Object? audioDuration = _undefined,
  }) {
    return TourPoint(
      externalId: externalId ?? this.externalId,
      id: id ?? this.id,
      tourId: tourId ?? this.tourId,
      title: title ?? this.title,
      description: description ?? this.description,
      areas: areas ?? this.areas,
      image: image == _undefined ? this.image : image as Uint8List?,
      imageFileName: imageFileName == _undefined
          ? this.imageFileName
          : imageFileName as String?,
      imageUrl: imageUrl == _undefined ? this.imageUrl : imageUrl as String?,
      imageUrlToDelete: imageUrlToDelete == _undefined
          ? this.imageUrlToDelete
          : imageUrlToDelete as String?,
      audioFile:
          audioFile == _undefined ? this.audioFile : audioFile as Uint8List?,
      audioFileId: audioFileId ?? this.audioFileId,
      audioFileName: audioFileName ?? this.audioFileName,
      audioDuration: audioDuration == _undefined
          ? this.audioDuration
          : audioDuration as int?,
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
        audioDuration,
        image,
        imageUrl,
        imageFileName,
      ];
}