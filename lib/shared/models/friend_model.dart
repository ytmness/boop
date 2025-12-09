class FriendModel {
  final String userId;
  final String friendUserId;
  final String status; // pending, accepted
  final DateTime createdAt;
  final DateTime? updatedAt;

  FriendModel({
    required this.userId,
    required this.friendUserId,
    this.status = 'pending',
    required this.createdAt,
    this.updatedAt,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      userId: json['user_id'] as String,
      friendUserId: json['friend_user_id'] as String,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'friend_user_id': friendUserId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  bool get isAccepted => status == 'accepted';
  bool get isPending => status == 'pending';
}

