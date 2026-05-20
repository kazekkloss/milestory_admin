class User {
  final String id;
  final String email;
  final String? password;
  final bool verify;
  final String type;
  final String? guideUserId;

  const User({
    required this.id,
    required this.email,
    this.password,
    required this.verify,
    required this.type,
    this.guideUserId,
  });

  bool get isAdmin => type == 'admin';

  User copyWith({
    String? id,
    String? email,
    String? password,
    bool? verify,
    String? type,
    String? guideUserId,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      verify: verify ?? this.verify,
      type: type ?? this.type,
      guideUserId: guideUserId ?? this.guideUserId,
    );
  }

  static const empty = User(
    id: "",
    email: "",
    password: null,
    verify: false,
    type: 'user',
    guideUserId: null,
  );
}
