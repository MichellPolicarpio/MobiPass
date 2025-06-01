class Ticket {
  final String? id;
  final String routeId;
  final String busId;
  final int seatNumber;
  final DateTime departureTime;
  final double price;
  final String passengerName;
  final String passengerId;
  final String status;
  final DateTime purchaseDate;
  final bool isActive;

  Ticket({
    this.id,
    required this.routeId,
    required this.busId,
    required this.seatNumber,
    required this.departureTime,
    required this.price,
    required this.passengerName,
    required this.passengerId,
    this.status = 'pending',
    DateTime? purchaseDate,
    this.isActive = true,
  }) : purchaseDate = purchaseDate ?? DateTime.now();

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['_id'],
      routeId: json['routeId'],
      busId: json['busId'],
      seatNumber: json['seatNumber'],
      departureTime: DateTime.parse(json['departureTime']),
      price: json['price'].toDouble(),
      passengerName: json['passengerName'],
      passengerId: json['passengerId'],
      status: json['status'] ?? 'pending',
      purchaseDate: DateTime.parse(json['purchaseDate']),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'routeId': routeId,
      'busId': busId,
      'seatNumber': seatNumber,
      'departureTime': departureTime.toIso8601String(),
      'price': price,
      'passengerName': passengerName,
      'passengerId': passengerId,
      'status': status,
      'purchaseDate': purchaseDate.toIso8601String(),
      'isActive': isActive,
    };
  }
} 