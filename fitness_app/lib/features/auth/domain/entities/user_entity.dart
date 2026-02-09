class UserEntity {
  final String uid;
  final String email;
  final String? name;
  final String? photoUrl;
  final DateTime? createdAt;

  UserEntity ({
    required this.uid,
    required this.email,
    this.name,
    this.photoUrl,
    this.createdAt,
  });
}