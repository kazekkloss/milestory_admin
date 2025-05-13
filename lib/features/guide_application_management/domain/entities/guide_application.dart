import 'package:equatable/equatable.dart';

class GuideApplication extends Equatable {
  final String id;
  final String? userId;
  final String? name;
  final String? q1;
  final String? q2;
  final String? q3;
  final String? q4;
  final String? q5;
  final DateTime? createdAt; 

  const GuideApplication({
    required this.id,
    this.userId,
    this.name,
    this.q1,
    this.q2,
    this.q3,
    this.q4,
    this.q5,
    this.createdAt,
  });

  GuideApplication copyWith({
    String? id,
    String? userId,
    String? name,
    String? q1,
    String? q2,
    String? q3,
    String? q4,
    String? q5,
    DateTime? createdAt, 
  }) {
    return GuideApplication(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      q1: q1 ?? this.q1,
      q2: q2 ?? this.q2,
      q3: q3 ?? this.q3,
      q4: q4 ?? this.q4,
      q5: q5 ?? this.q5,
      createdAt: createdAt ?? this.createdAt, 
    );
  }

  @override
  List<Object?> get props => [id, userId, name, q1, q2, q3, q4, q5, createdAt]; 

  static const empty = GuideApplication(id: "", name: null);
}