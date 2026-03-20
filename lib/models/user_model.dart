class User {
  final int userId;
  final String fullName;
  final String email;

  User({required this.userId, required this.fullName, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      fullName: json['fullName'],
      email: json['email'],
    );
  }
}