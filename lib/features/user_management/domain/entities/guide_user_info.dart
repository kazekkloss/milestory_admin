class GuideUserInfo {
  final String id;
  final String name;
  final String? imageUrl;
  final String? bio;

  const GuideUserInfo({
    required this.id,
    required this.name,
    this.imageUrl,
    this.bio,
  });
}
