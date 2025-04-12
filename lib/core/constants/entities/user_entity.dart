class User {
  final String id;
  final String email;
  final String? password;
  final String? name;
  final bool verify;
  final String role;

  const User({
    required this.id,
    required this.email,
    this.password,
    this.name,
    required this.verify,
    required this.role,
  });

  User copyWith({
    final String? id,
    final String? email,
    final String? password,
    final String? name,
    final bool? verify,
    final String? token,
    final String? role,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      verify: verify ?? this.verify,
      role: role ?? this.role,
    );
  }

  static const empty = User(id: "", email: "", password: null, name: null, verify: false, role: "T");
}
