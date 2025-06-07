class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String token;
  final String? licenseNumber;  // Opcional para transportistas
  final String? busNumber;      // Opcional para transportistas

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
    this.licenseNumber,
    this.busNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',  // Acepta tanto _id como id
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      token: json['token'] ?? '',
      licenseNumber: json['licenseNumber'],
      busNumber: json['busNumber'],
    );
  }
} 