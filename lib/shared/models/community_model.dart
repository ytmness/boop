class CommunityModel {
  final String id;
  final String name;
  final String? description;
  final String? city;
  final String? logoUrl;
  final String ownerUserId;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int? followersCount;

  CommunityModel({
    required this.id,
    required this.name,
    this.description,
    this.city,
    this.logoUrl,
    required this.ownerUserId,
    this.isVerified = false,
    required this.createdAt,
    this.updatedAt,
    this.followersCount,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      city: json['city'] as String?,
      logoUrl: json['logo_url'] as String?,
      ownerUserId: json['owner_user_id'] as String,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      followersCount: json['followers_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'city': city,
      'logo_url': logoUrl,
      'owner_user_id': ownerUserId,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'followers_count': followersCount,
    };
  }
}

