class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String token;
  final String? licenseNumber;  // Campo opcional para transportistas
  final String? busNumber;      // Campo opcional para transportistas

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
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      token: json['token'] ?? '',
      licenseNumber: json['licenseNumber'],
      busNumber: json['busNumber'],
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
    };
  }
} 