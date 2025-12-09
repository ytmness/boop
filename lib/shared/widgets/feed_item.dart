import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'profile_avatar.dart';

class FeedItem extends StatelessWidget {
  final String userName;
  final String? userAvatarUrl;
  final String activityType; // photo, status_update, new_event, friend_joined
  final String? content;
  final String? imageUrl;
  final DateTime createdAt;
  final VoidCallback? onTap;

  const FeedItem({
    super.key,
    required this.userName,
    this.userAvatarUrl,
    required this.activityType,
    this.content,
    this.imageUrl,
    required this.createdAt,
    this.onTap,
  });

  String _getActivityText() {
    switch (activityType) {
      case 'photo':
        return 'subió una foto';
      case 'status_update':
        return 'actualizó su estado';
      case 'new_event':
        return 'creó un nuevo evento';
      case 'friend_joined':
        return 'se unió a un evento';
      default:
        return 'realizó una actividad';
    }
  }

  IconData _getActivityIcon() {
    switch (activityType) {
      case 'photo':
        return CupertinoIcons.photo;
      case 'status_update':
        return CupertinoIcons.chat_bubble_text;
      case 'new_event':
        return CupertinoIcons.calendar;
      case 'friend_joined':
        return CupertinoIcons.person_add;
      default:
        return CupertinoIcons.bell;
    }
  }

  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return 'hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'ahora';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileAvatar(
              imageUrl: userAvatarUrl,
              name: userName,
              radius: 25,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 15,
                        color: CupertinoColors.label,
                      ),
                      children: [
                        TextSpan(
                          text: userName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(text: ' ${_getActivityText()}'),
                      ],
                    ),
                  ),
                  if (content != null && content!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      content!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                  ],
                  if (imageUrl != null && imageUrl!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          color: CupertinoColors.systemGrey5,
                          child: const Icon(
                            CupertinoIcons.photo,
                            size: 40,
                            color: CupertinoColors.secondaryLabel,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        _getActivityIcon(),
                        size: 12,
                        color: CupertinoColors.secondaryLabel,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getTimeAgo(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
