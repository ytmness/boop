import 'package:flutter/cupertino.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (actionText != null && onActionTap != null)
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onActionTap,
              child: Text(
                actionText!,
                style: const TextStyle(
                  fontSize: 17,
                  color: CupertinoColors.systemBlue,
                ),
              ),
              minimumSize: Size(0, 0),
            ),
        ],
      ),
    );
  }
}
