import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../../core/branding/branding.dart';
import '../glass/glass_container.dart';
import '../animations/apple_animations.dart';
import '../../../shared/models/event_model.dart';

/// Card de evento con efecto Glass tipo Apple
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

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return AppleBounceAnimation(
      onTap: onTap,
      child: GlassCard(
        margin: margin ?? const EdgeInsets.only(bottom: Branding.spacingM),
        padding: EdgeInsets.zero,
        borderRadius: Branding.radiusLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del evento (placeholder)
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Branding.radiusLarge),
                  topRight: Radius.circular(Branding.radiusLarge),
                ),
                gradient: LinearGradient(
                  colors: [
                    Branding.primaryPurple,
                    Branding.accentViolet,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: event.imageUrl != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(Branding.radiusLarge),
                        topRight: Radius.circular(Branding.radiusLarge),
                      ),
                      child: Image.network(
                        event.imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: Icon(
                        CupertinoIcons.calendar,
                        size: 60,
                        color: CupertinoColors.white.withOpacity(0.8),
                      ),
                    ),
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
                    style: const TextStyle(
                      fontSize: Branding.fontSizeTitle3,
                      fontWeight: Branding.weightSemibold,
                      letterSpacing: -0.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: Branding.spacingS),

                  // Descripción
                  if (event.description != null)
                    Text(
                      event.description!,
                      style: const TextStyle(
                        fontSize: Branding.fontSizeSubhead,
                        color: CupertinoColors.secondaryLabel,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: Branding.spacingM),

                  // Información de fecha y lugar
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.calendar,
                        size: 16,
                        color: Branding.primaryPurple,
                      ),
                      const SizedBox(width: Branding.spacingXS),
                      Text(
                        dateFormat.format(event.startTime),
                        style: const TextStyle(
                          fontSize: Branding.fontSizeCaption1,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                      if (event.city != null) ...[
                        const SizedBox(width: Branding.spacingM),
                        const Icon(
                          CupertinoIcons.location,
                          size: 16,
                          color: Branding.primaryPurple,
                        ),
                        const SizedBox(width: Branding.spacingXS),
                        Text(
                          event.city!,
                          style: const TextStyle(
                            fontSize: Branding.fontSizeCaption1,
                            color: CupertinoColors.secondaryLabel,
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
    );
  }
}
