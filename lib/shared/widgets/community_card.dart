import 'package:flutter/cupertino.dart';
import '../models/community_model.dart';
import 'profile_avatar.dart';

class CommunityCard extends StatelessWidget {
  final CommunityModel community;
  final VoidCallback? onTap;

  const CommunityCard({
    super.key,
    required this.community,
    this.onTap,
  });

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
        child: Row(
          children: [
            ProfileAvatar(
              imageUrl: community.logoUrl,
              name: community.name,
              radius: 30,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    community.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (community.city != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      community.city!,
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                  ],
                  if (community.followersCount != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${community.followersCount} seguidores',
                      style: TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (community.isVerified)
              const Icon(
                CupertinoIcons.check_mark_circled_solid,
                color: CupertinoColors.systemBlue,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

