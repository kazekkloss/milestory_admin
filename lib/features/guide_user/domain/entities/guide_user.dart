import 'dart:typed_data';

class GuideUser {
  final String id;
  final String userId;
  final String name;
  final String guideDescription;
  final List<String> tours;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final String? avatarUrl;
  final Uint8List? avatarBytes;
  final String? avatarFileName;
  final bool hasSeenCreatorOnboarding;

  const GuideUser({
    required this.id,
    required this.userId,
    this.name = '',
    this.guideDescription = '',
    this.tours = const [],
    required this.createdAt,
    required this.updatedAt,
    this.avatarUrl,
    this.avatarBytes,
    this.avatarFileName,
    this.hasSeenCreatorOnboarding = false,
  });

  GuideUser copyWith({
    String? id,
    String? userId,
    String? name,
    String? guideDescription,
    List<String>? tours,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? avatarUrl = _undefined,
    Object? avatarBytes = _undefined,
    Object? avatarFileName = _undefined,
    bool? hasSeenCreatorOnboarding,
  }) {
    return GuideUser(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      guideDescription: guideDescription ?? this.guideDescription,
      tours: tours ?? this.tours,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      avatarUrl: avatarUrl == _undefined ? this.avatarUrl : avatarUrl as String?,
      avatarBytes:
          avatarBytes == _undefined ? this.avatarBytes : avatarBytes as Uint8List?,
      avatarFileName: avatarFileName == _undefined
          ? this.avatarFileName
          : avatarFileName as String?,
      hasSeenCreatorOnboarding:
          hasSeenCreatorOnboarding ?? this.hasSeenCreatorOnboarding,
    );
  }

  static const _undefined = Object();

  static const empty = GuideUser(
    id: '',
    userId: '',
    name: '',
    guideDescription: '',
    tours: [],
    createdAt: null,
    updatedAt: null,
  );
}
