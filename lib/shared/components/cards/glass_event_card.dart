import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:intl/intl.dart';
import 'dart:ui';
import '../../../core/branding/branding.dart';
import '../animations/apple_animations.dart';
import '../../../shared/models/event_model.dart';

/// Card de evento con efecto Liquid Glass tipo Apple
class GlassEventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const GlassEventCard({
    super.key,
    required this.event,
    this.onTap,
    this.margin,
  });

  String _getImageUrl() {
    // Usar imagen del evento si existe, sino usar placeholder con el ID del evento
    if (event.imageUrl != null && event.imageUrl!.isNotEmpty) {
      return event.imageUrl!;
    }
    // Usar picsum.photos con seed basado en el ID del evento para consistencia
    final seed = event.id.hashCode.abs();
    return 'https://picsum.photos/seed/boop-$seed/800/600';
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return AppleBounceAnimation(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.only(bottom: Branding.spacingM),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Branding.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: -5,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: CupertinoColors.white.withOpacity(0.05),
              blurRadius: 15,
              spreadRadius: -3,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Branding.radiusLarge),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Branding.radiusLarge),
                border: Border.all(
                  color: CupertinoColors.white.withOpacity(0.18),
                  width: 1.0,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          CupertinoColors.white.withOpacity(0.15),
                          CupertinoColors.white.withOpacity(0.10),
                          CupertinoColors.white.withOpacity(0.08),
                          CupertinoColors.white.withOpacity(0.05),
                        ]
                      : [
                          CupertinoColors.white.withOpacity(0.85),
                          CupertinoColors.white.withOpacity(0.70),
                          CupertinoColors.white.withOpacity(0.60),
                          CupertinoColors.white.withOpacity(0.50),
                        ],
                  stops: const [0.0, 0.3, 0.6, 1.0],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del evento con overlay glass
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        child: Image.network(
                          _getImageUrl(),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Branding.primaryPurple,
                                    Branding.accentViolet,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.calendar,
                                  size: 60,
                                  color: CupertinoColors.white.withOpacity(0.6),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Overlay glass sutil sobre la imagen
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                CupertinoColors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Contenido
                  Padding(
                    padding: const EdgeInsets.all(Branding.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título
                        Text(
                          event.title,
                          style: TextStyle(
                            fontSize: Branding.fontSizeTitle3,
                            fontWeight: Branding.weightSemibold,
                            letterSpacing: -0.4,
                            color: isDark
                                ? CupertinoColors.white
                                : CupertinoColors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: Branding.spacingS),

                        // Descripción
                        if (event.description != null)
                          Text(
                            event.description!,
                            style: TextStyle(
                              fontSize: Branding.fontSizeSubhead,
                              color: isDark
                                  ? CupertinoColors.white.withOpacity(0.75)
                                  : CupertinoColors.black.withOpacity(0.65),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                        const SizedBox(height: Branding.spacingM),

                        // Información de fecha y lugar
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.calendar,
                              size: 16,
                              color: isDark
                                  ? CupertinoColors.white.withOpacity(0.6)
                                  : CupertinoColors.black.withOpacity(0.5),
                            ),
                            const SizedBox(width: Branding.spacingXS),
                            Text(
                              dateFormat.format(event.startTime),
                              style: TextStyle(
                                fontSize: Branding.fontSizeCaption1,
                                color: isDark
                                    ? CupertinoColors.white.withOpacity(0.7)
                                    : CupertinoColors.black.withOpacity(0.6),
                              ),
                            ),
                            if (event.city != null) ...[
                              const SizedBox(width: Branding.spacingM),
                              Icon(
                                CupertinoIcons.location,
                                size: 16,
                                color: isDark
                                    ? CupertinoColors.white.withOpacity(0.6)
                                    : CupertinoColors.black.withOpacity(0.5),
                              ),
                              const SizedBox(width: Branding.spacingXS),
                              Text(
                                event.city!,
                                style: TextStyle(
                                  fontSize: Branding.fontSizeCaption1,
                                  color: isDark
                                      ? CupertinoColors.white.withOpacity(0.7)
                                      : CupertinoColors.black.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
