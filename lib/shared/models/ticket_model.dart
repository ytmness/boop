class TicketModel {
  final String id;
  final String orderId;
  final String eventId;
  final String ticketTypeId;
  final String ownerUserId;
  final String qrCode;
  final bool isScanned;
  final DateTime? scannedAt;
  final DateTime createdAt;

  TicketModel({
    required this.id,
    required this.orderId,
    required this.eventId,
    required this.ticketTypeId,
    required this.ownerUserId,
    required this.qrCode,
    this.isScanned = false,
    this.scannedAt,
    required this.createdAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      eventId: json['event_id'] as String,
      ticketTypeId: json['ticket_type_id'] as String,
      ownerUserId: json['owner_user_id'] as String,
      qrCode: json['qr_code'] as String,
      isScanned: json['is_scanned'] as bool? ?? false,
      scannedAt: json['scanned_at'] != null
          ? DateTime.parse(json['scanned_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'event_id': eventId,
      'ticket_type_id': ticketTypeId,
      'owner_user_id': ownerUserId,
      'qr_code': qrCode,
      'is_scanned': isScanned,
      'scanned_at': scannedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

