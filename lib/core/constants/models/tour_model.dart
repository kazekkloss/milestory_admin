import '../../core_export.dart';

class TourModel extends Tour {
  const TourModel({
    super.id,
    required super.title,
    required super.authorId,
    required super.transportMode,
    required super.description,
    required super.status,
    super.createdAt,
    required super.pointLength,
    super.audioFileId,
    required super.audioFileName,
    super.imageUrl,
    super.imageFileName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authorId': authorId,
      'transportMode': transportMode.toString().split('.').last,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'audioFileId': audioFileId,
      'status': TourStatusData.mapStatusEnumToApiString(status),
      'audioFileName': audioFileName,
      'imageUrl': imageUrl,
      'imageFileName': imageFileName,
      'pointLength': pointLength,
    };
  }

  factory TourModel.fromJson(Map<String, dynamic> json) {
    return TourModel(
      id: json['_id'],
      title: json['title'],
      authorId: json['authorId'],
      transportMode: TransportMode.values.firstWhere(
        (e) => e.toString().split('.').last == json['transportMode'],
        orElse: () => TransportMode.none,
      ),
      status: TourStatusData.fromApiString(json['status'] ?? 'private'),
      description: json['description'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      audioFileId: json['audioFileId'],
      audioFileName: json['audioFileName'],
      imageUrl: json['imageUrl'],
      imageFileName: json['imageFileName'],
      pointLength: json['pointLength'] ?? 0,
    );
  }

  static TourModel toModel(Tour tour) {
    return TourModel(
      id: tour.id,
      title: tour.title,
      authorId: tour.authorId,
      transportMode: tour.transportMode,
      description: tour.description,
      createdAt: tour.createdAt,
      status: tour.status,
      audioFileId: tour.audioFileId,
      audioFileName: tour.audioFileName,
      imageUrl: tour.imageUrl,
      imageFileName: tour.imageFileName,
      pointLength: tour.pointLength,
    );
  }

  static Tour toEntity(TourModel tourModel) {
    return Tour(
      id: tourModel.id,
      title: tourModel.title,
      authorId: tourModel.authorId,
      transportMode: tourModel.transportMode,
      description: tourModel.description,
      createdAt: tourModel.createdAt,
      audioFile: tourModel.audioFile,
      status: tourModel.status,
      audioFileId: tourModel.audioFileId,
      audioFileName: tourModel.audioFileName,
      image: tourModel.image,
      imageUrl: tourModel.imageUrl,
      imageFileName: tourModel.imageFileName,
      pointLength: tourModel.pointLength,
    );
  }
}
