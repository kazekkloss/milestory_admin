import '../../guide_application_export.dart';

class GuideApplicationModel extends GuideApplication {
  const GuideApplicationModel({
    required super.id,
    super.userId,
    required super.name,
    super.q1,
    super.q2,
    super.q3,
    super.q4,
    super.q5,
    super.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'firstName': name,
      'q1': q1,
      'q2': q2,
      'q3': q3,
      'q4': q4,
      'q5': q5,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory GuideApplicationModel.fromJson(Map<String, dynamic> json) {
    return GuideApplicationModel(
      id: json['_id'],
      userId: json['userId'] as String?,
      name: json['name'] as String,
      q1: json['q1'] as String?,
      q2: json['q2'] as String?,
      q3: json['q3'] as String?,
      q4: json['q4'] as String?,
      q5: json['q5'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  static GuideApplicationModel toModel(GuideApplication entity) {
    return GuideApplicationModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      q1: entity.q1,
      q2: entity.q2,
      q3: entity.q3,
      q4: entity.q4,
      q5: entity.q5,
      createdAt: entity.createdAt,
    );
  }

  static GuideApplication toEntity(GuideApplicationModel model) {
    return GuideApplication(
      id: model.id,
      userId: model.userId,
      name: model.name,
      q1: model.q1,
      q2: model.q2,
      q3: model.q3,
      q4: model.q4,
      q5: model.q5,
      createdAt: model.createdAt,
    );
  }
}
