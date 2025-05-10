import 'package:equatable/equatable.dart';

class GuideApplication extends Equatable {
  final String id;
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? q1;
  final String? q2;
  final String? q3;
  final String? q4;
  final String? q5;

  const GuideApplication({required this.id, this.userId, this.firstName, this.lastName, this.q1, this.q2, this.q3, this.q4, this.q5});

  GuideApplication copyWith({
    String? id,
    String? userId,
    String? firstName,
    String? lastName,
    String? q1,
    String? q2,
    String? q3,
    String? q4,
    String? q5,
  }) {
    return GuideApplication(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      q1: q1 ?? this.q1,
      q2: q2 ?? this.q2,
      q3: q3 ?? this.q3,
      q4: q4 ?? this.q4,
      q5: q5 ?? this.q5,
    );
  }

  @override
  List<Object?> get props => [id, userId, firstName, lastName, q1, q2, q3, q4, q5];

  static const empty = GuideApplication(id: "", firstName: null, lastName: null);
}
