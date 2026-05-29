import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import '../../core_export.dart';

class Tour extends Equatable {
  final String? id;
  final TourStatus status;
  final String? rejectionReason;
  final String title;
  final int pointLength;
  final String authorId;
  final TransportMode transportMode;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final Uint8List? image;
  final String? imageFileName;
  final String? imageUrl;
  final String? imageUrlToDelete;

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
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
    this.audioFile,
    this.audioFileId,
    required this.pointLength,
    required this.audioFileName,
    this.image,
    this.imageFileName,
    this.imageUrl,
    this.imageUrlToDelete,
  });

  Tour copyWith({
    String? id,
    String? title,
    String? authorId,
    TransportMode? transportMode,
    TourStatus? status,
    Object? rejectionReason = _undefined,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? image = _undefined,
    Object? imageFileName = _undefined,
    Object? imageUrl = _undefined,
    Object? imageUrlToDelete = _undefined,
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
      rejectionReason: rejectionReason == _undefined
          ? this.rejectionReason
          : rejectionReason as String?,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      image: image == _undefined ? this.image : image as Uint8List?,
      imageFileName: imageFileName == _undefined
          ? this.imageFileName
          : imageFileName as String?,
      imageUrl: imageUrl == _undefined ? this.imageUrl : imageUrl as String?,
      imageUrlToDelete: imageUrlToDelete == _undefined
          ? this.imageUrlToDelete
          : imageUrlToDelete as String?,
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
        updatedAt,
        pointLength,
        status,
        rejectionReason,
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
    status: TourStatus.draft,
    pointLength: 0,
    description: '',
    audioFileName: '',
  );
}
