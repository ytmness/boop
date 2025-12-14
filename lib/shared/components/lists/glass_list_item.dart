import 'package:flutter/cupertino.dart';
import '../../../core/branding/branding.dart';
import '../glass/glass_container.dart';
import '../animations/apple_animations.dart';

/// Item de lista con efecto Glass tipo Apple
class GlassListItem extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const GlassListItem({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AppleBounceAnimation(
      onTap: onTap,
      child: GlassCard(
        padding: padding ?? const EdgeInsets.all(Branding.spacingM),
        margin: const EdgeInsets.only(bottom: Branding.spacingS),
        borderRadius: Branding.radiusMedium,
        onTap: onTap,
        child: Row(
          children: [
            leading,
            const SizedBox(width: Branding.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: Branding.fontSizeBody,
                      fontWeight: Branding.weightMedium,
                      letterSpacing: -0.4,
                    ),
                    child: title,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: Branding.spacingXS),
                    DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: Branding.fontSizeSubhead,
                        color: CupertinoColors.secondaryLabel,
                      ),
                      child: subtitle!,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: Branding.spacingM),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
