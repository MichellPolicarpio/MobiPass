class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String token;
  final String? licenseNumber;  // Campo opcional para transportistas
  final String? busNumber;      // Campo opcional para transportistas
  final DateTime? dateOfBirth;  // Campo opcional para fecha de nacimiento
  final String? gender;         // Campo opcional para género

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
    this.licenseNumber,
    this.busNumber,
    this.dateOfBirth,
    this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      token: json['token'] ?? '',
      licenseNumber: json['licenseNumber'],
      busNumber: json['busNumber'],
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth']) : null,
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'token': token,
      'licenseNumber': licenseNumber,
      'busNumber': busNumber,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
    };
  }
} 