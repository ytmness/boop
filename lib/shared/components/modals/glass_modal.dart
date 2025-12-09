import 'package:flutter/cupertino.dart';
import '../../../core/branding/branding.dart';
import '../glass/glass_container.dart';

/// Modal con efecto Glass tipo Apple
class GlassModal extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? padding;

  const GlassModal({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.padding,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    List<Widget>? actions,
    EdgeInsetsGeometry? padding,
  }) {
    return showCupertinoModalPopup<T>(
      context: context,
      barrierDismissible: true,
      builder: (context) => GlassModal(
        title: title,
        actions: actions,
        padding: padding,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: CupertinoColors.black.withOpacity(0.4),
        child: SafeArea(
          child: GestureDetector(
            onTap: () {}, // Prevenir que el tap se propague
            child: GlassContainer(
              margin: const EdgeInsets.all(Branding.spacingM),
              padding: padding ?? const EdgeInsets.all(Branding.spacingL),
              borderRadius: Branding.radiusLarge,
              backgroundColor: isDark
                  ? Branding.glassBackgroundDark
                  : Branding.glassBackgroundLight,
              blur: Branding.glassBlur,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    Text(
                      title!,
                      style: const TextStyle(
                        fontSize: Branding.fontSizeTitle2,
                        fontWeight: Branding.weightBold,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: Branding.spacingM),
                  ],
                  child,
                  if (actions != null && actions!.isNotEmpty) ...[
                    const SizedBox(height: Branding.spacingL),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: actions!,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

