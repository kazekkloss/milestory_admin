import '../../creator_export.dart';

class TourPointModel extends TourPoint {
  const TourPointModel({
    required super.tourId,
    required super.id,
    super.externalId,
    required super.title,
    required super.description,
    required List<AreaModel> areas,
    required super.audioFileId,
    required super.audioFileName,
    super.imageUrl,
    super.imageFileName,
  }) : super(areas: areas);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      '_id': externalId,
      'tourId': tourId,
      'title': title,
      'description': description,
      'areas': areas.map((area) => (area as AreaModel).toJson()).toList(),
      'audioFileId': audioFileId,
      'audioFileName': audioFileName,
      'imageUrl': imageUrl,
      'imageFileName': imageFileName,
    };
  }

  factory TourPointModel.fromJson(Map<String, dynamic> json) {
    return TourPointModel(
      id: json['id'],
      externalId: json['_id'],
      tourId: json['tourId'],
      title: json['title'],
      description: json['description'],
      areas: (json['areas'] as List).map((area) => AreaModel.fromJson(area)).toList(),
      audioFileId: json['audioFileId'],
      audioFileName: json['audioFileName'],
      imageUrl: json['imageUrl'],
      imageFileName: json['imageFileName'],
    );
  }

  static TourPointModel toModel(TourPoint tourPoint) {
    return TourPointModel(
      id: tourPoint.id,
      externalId: tourPoint.externalId,
      tourId: tourPoint.tourId,
      title: tourPoint.title,
      description: tourPoint.description,
      areas: tourPoint.areas.map((area) => AreaModel.toModel(area)).toList(),
      audioFileId: tourPoint.audioFileId,
      audioFileName: tourPoint.audioFileName,
      imageUrl: tourPoint.imageUrl,
      imageFileName: tourPoint.imageFileName,
    );
  }

  static TourPoint toEntity(TourPointModel tourPointModel) {
    final List<Area> areas = tourPointModel.areas.map((area) => AreaModel.toEntity(area as AreaModel)).toList();
    return TourPoint(
      id: tourPointModel.id,
      externalId: tourPointModel.externalId,
      tourId: tourPointModel.tourId,
      title: tourPointModel.title,
      description: tourPointModel.description,
      areas: areas,
      audioFileId: tourPointModel.audioFileId,
      audioFileName: tourPointModel.audioFileName,
      imageUrl: tourPointModel.imageUrl,
      imageFileName: tourPointModel.imageFileName,
    );
  }
}
