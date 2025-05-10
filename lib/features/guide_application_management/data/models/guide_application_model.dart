import '../../guide_application_export.dart';

class GuideApplicationModel extends GuideApplication {
  const GuideApplicationModel({
    required super.id,
    super.userId,
    required super.firstName,
    required super.lastName,
    super.q1,
    super.q2,
    super.q3,
    super.q4,
    super.q5,
  });

  Map<String, dynamic> toJson() {
    return {'_id': id, 'userId': userId, 'firstName': firstName, 'lastName': lastName, 'q1': q1, 'q2': q2, 'q3': q3, 'q4': q4, 'q5': q5};
  }

  factory GuideApplicationModel.fromJson(Map<String, dynamic> json) {
    return GuideApplicationModel(
      id: json['_id'],
      userId: json['userId'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      q1: json['q1'] as String?,
      q2: json['q2'] as String?,
      q3: json['q3'] as String?,
      q4: json['q4'] as String?,
      q5: json['q5'] as String?,
    );
  }

  static GuideApplicationModel toModel(GuideApplication entity) {
    return GuideApplicationModel(
      id: entity.id,
      userId: entity.userId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      q1: entity.q1,
      q2: entity.q2,
      q3: entity.q3,
      q4: entity.q4,
      q5: entity.q5,
    );
  }

  static GuideApplication toEntity(GuideApplicationModel model) {
    return GuideApplication(
      id: model.id,
      userId: model.userId,
      firstName: model.firstName,
      lastName: model.lastName,
      q1: model.q1,
      q2: model.q2,
      q3: model.q3,
      q4: model.q4,
      q5: model.q5,
    );
  }
}
