import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import '../../core_export.dart';

class Tour extends Equatable {
  final String? id;
  final TourStatus status;
  final String title;
  final int pointLength; // Assuming this is a placeholder, as it's not used in the original code
  final String authorId;
  final TransportMode transportMode;
  final String description;
  final DateTime? createdAt;

  final Uint8List? image;
  final String? imageFileName;
  final String? imageUrl;

  final Uint8List? audioFile;
  final String? audioFileId;
  final String audioFileName;

  const Tour({
    this.id,
    required this.title,
    required this.authorId,
    required this.transportMode,
    required this.description,
    required this.status,
    this.createdAt,
    this.audioFile,
    this.audioFileId,
    required this.pointLength,
    required this.audioFileName,
    this.image,
    this.imageFileName,
    this.imageUrl,
  });

  Tour copyWith({
    String? id,
    String? title,
    String? authorId,
    TransportMode? transportMode,
    TourStatus? status,
    String? description,
    DateTime? createdAt,
    Object? image = _undefined,
    Object? imageFileName = _undefined,
    Object? imageUrl = _undefined,
    int? pointLength,
    Uint8List? audioFile,
    String? audioFileId,
    String? audioFileName,
  }) {
    return Tour(
      id: id ?? this.id,
      title: title ?? this.title,
      authorId: authorId ?? this.authorId,
      transportMode: transportMode ?? this.transportMode,
      status: status ?? this.status,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      image: image == _undefined ? this.image : image as Uint8List?,
      imageFileName: imageFileName == _undefined ? this.imageFileName : imageFileName as String?,
      imageUrl: imageUrl == _undefined ? this.imageUrl : imageUrl as String?,
      pointLength: pointLength ?? this.pointLength,
      audioFile: audioFile ?? this.audioFile,
      audioFileId: audioFileId ?? this.audioFileId,
      audioFileName: audioFileName ?? this.audioFileName,
    );
  }

  static const _undefined = Object();

  @override
  List<Object?> get props => [
        id,
        title,
        authorId,
        transportMode,
        description,
        createdAt,
        pointLength,
        status,
        audioFile,
        audioFileName,
        audioFileId,
        image,
        imageUrl,
        imageFileName,
      ];

  static const empty = Tour(
    id: '',
    title: '',
    authorId: '',
    transportMode: TransportMode.none,
    status: TourStatus.private,
    pointLength: 0,
    description: '',
    audioFileName: '',
  );
}
