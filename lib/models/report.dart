class Report {
  final String? id;
  final String driverLicense;
  final String route;
  final String complaint;
  final DateTime createdAt;
  final String status;

  Report({
    this.id,
    required this.driverLicense,
    required this.route,
    required this.complaint,
    DateTime? createdAt,
    this.status = 'pendiente',
  }) : createdAt = createdAt ?? DateTime.now();

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['_id'],
      driverLicense: json['driverLicense'],
      route: json['route'],
      complaint: json['complaint'],
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'driverLicense': driverLicense,
      'route': route,
      'complaint': complaint,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }
} 