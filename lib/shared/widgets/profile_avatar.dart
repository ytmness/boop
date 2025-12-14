import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double radius;
  final bool showBorder;
  final Color? borderColor;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.radius = 30,
    this.showBorder = false,
    this.borderColor,
  });

  String _getInitials() {
    if (name == null || name!.isEmpty) return '?';
    final parts = name!.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name![0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: borderColor ?? CupertinoColors.separator,
                width: 2,
              )
            : null,
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: CupertinoColors.secondarySystemBackground,
                  child: Center(
                    child: CupertinoActivityIndicator(
                      radius: radius * 0.3,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => _buildInitialsAvatar(),
              )
            : _buildInitialsAvatar(),
      ),
    );
  }

  Widget _buildInitialsAvatar() {
    return Container(
      color: CupertinoColors.systemGrey,
      child: Center(
        child: Text(
          _getInitials(),
          style: TextStyle(
            fontSize: radius * 0.6,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.white,
          ),
        ),
      ),
    );
  }
}

