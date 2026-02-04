class AppUser {
  final String uid;
  final String email;
  final String? name;

  AppUser({
    required this.uid,
    required this.email,
    this.name,
  });

  // AppUser -> json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }

  // Json -> AppUser
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
    );
  }
}