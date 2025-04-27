class User {
  final int id;
  final String? username; // Made nullable
  final String? email; // Made nullable
  final String? firstName; // Made nullable
  final String? lastName; // Made nullable
  final String? gender; // Made nullable
  final String? image; // Made nullable
  final String? token; // Made nullable (or accessToken if that's the field name)

  User({
    required this.id,
    this.username, // No longer required if nullable
    this.email, // No longer required if nullable
    this.firstName, // No longer required if nullable
    this.lastName, // No longer required if nullable
    this.gender, // No longer required if nullable
    this.image, // No longer required if nullable
    this.token, // No longer required if nullable
  });

  // Factory method to create a User object from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      image: json['image'],
      token: json['token'], // Use json['accessToken'] if that's the actual field name
    );
  }

  // Helper to get full name - handle potential nulls
  String get fullName {
    // Use null-aware operators to safely access potentially null fields
    final first = firstName ?? '';
    final last = lastName ?? '';
    if (first.isEmpty && last.isEmpty) return 'User'; // Default if both are null/empty
    return '$first $last'.trim(); // Trim extra space if one is empty
  }
}
