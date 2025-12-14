class EventModel {
  final String id;
  final String? communityId;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime? endTime;
  final String? timezone;
  final String? city;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;
  final String status; // draft, published, past
  final bool isPublic;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int viewsCount;
  final int? interestedCount;

  EventModel({
    required this.id,
    this.communityId,
    required this.title,
    this.description,
    required this.startTime,
    this.endTime,
    this.timezone,
    this.city,
    this.address,
    this.latitude,
    this.longitude,
    this.imageUrl,
    this.status = 'draft',
    this.isPublic = false,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
    this.viewsCount = 0,
    this.interestedCount,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String,
      communityId: json['community_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : null,
      timezone: json['timezone'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      latitude: json['lat'] != null ? (json['lat'] as num).toDouble() : null,
      longitude: json['lng'] != null ? (json['lng'] as num).toDouble() : null,
      imageUrl: json['image_url'] as String?,
      status: json['status'] as String? ?? 'draft',
      isPublic: json['is_public'] as bool? ?? false,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      viewsCount: json['views_count'] as int? ?? 0,
      interestedCount: json['interested_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'community_id': communityId,
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'timezone': timezone,
      'city': city,
      'address': address,
      'lat': latitude,
      'lng': longitude,
      'image_url': imageUrl,
      'status': status,
      'is_public': isPublic,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'views_count': viewsCount,
      'interested_count': interestedCount,
    };
  }

  bool get isPast => endTime != null
      ? endTime!.isBefore(DateTime.now())
      : startTime.isBefore(DateTime.now());

  bool get isUpcoming => !isPast && startTime.isAfter(DateTime.now());
}

