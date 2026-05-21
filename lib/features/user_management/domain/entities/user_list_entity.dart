import 'package:equatable/equatable.dart';

class UserListItem extends Equatable {
  final String id;
  final String email;
  final String type;
  final bool verify;
  final String? guideUserId;
  final DateTime? createdAt;

  const UserListItem({
    required this.id,
    required this.email,
    required this.type,
    required this.verify,
    this.guideUserId,
    this.createdAt,
  });

  bool get isAdmin => type == 'admin';
  bool get isGuide => guideUserId != null && guideUserId!.isNotEmpty;

  @override
  List<Object?> get props => [id, email, type, verify, guideUserId, createdAt];
}
