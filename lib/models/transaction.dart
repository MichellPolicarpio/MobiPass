class Transaction {
  final String? id;
  final String userId;
  final String busNumber;
  final DateTime timestamp;
  final String status;

  Transaction({
    this.id,
    required this.userId,
    required this.busNumber,
    required this.timestamp,
    required this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'] ?? json['id'],
      userId: json['userId'],
      busNumber: json['busNumber'],
      timestamp: DateTime.parse(json['timestamp']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'busNumber': busNumber,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }
} 