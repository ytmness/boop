import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import '../../core/branding/branding.dart';
import '../components/glass/glass_container.dart';
import '../components/buttons/glass_button.dart';
import '../../routes/route_names.dart';

/// Widget placeholder para cuando no hay eventos disponibles
/// Con estilo glass similar a las tarjetas de eventos
class EmptyEventsPlaceholder extends StatelessWidget {
  final String? city;
  final VoidCallback? onCreateEvent;
  final VoidCallback? onExploreCommunities;

  const EmptyEventsPlaceholder({
    super.key,
    this.city,
    this.onCreateEvent,
    this.onExploreCommunities,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: Branding.spacingM),
      borderRadius: Branding.radiusLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen placeholder con estilo glass
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Branding.radiusLarge),
                topRight: Radius.circular(Branding.radiusLarge),
              ),
              gradient: LinearGradient(
                colors: [
                  Branding.primaryPurple.withOpacity(0.3),
                  Branding.accentViolet.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Branding.radiusLarge),
                topRight: Radius.circular(Branding.radiusLarge),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.2,
                      colors: [
                        CupertinoColors.white.withOpacity(0.05),
                        CupertinoColors.white.withOpacity(0.02),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      CupertinoIcons.calendar_badge_plus,
                      size: 80,
                      color: CupertinoColors.white.withOpacity(0.6),
                    ),
                  ),
                ),
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
                const Text(
                  'No hay eventos disponibles',
                  style: TextStyle(
                    fontSize: Branding.fontSizeTitle3,
                    fontWeight: Branding.weightSemibold,
                    letterSpacing: -0.4,
                    color: CupertinoColors.white,
                    shadows: [
                      Shadow(
                        color: CupertinoColors.black,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: Branding.spacingS),

                // Descripción
                Text(
                  city != null && city!.isNotEmpty
                      ? 'Aún no hay eventos públicos en $city. ¡Sé el primero en crear uno!'
                      : 'Aún no hay eventos públicos disponibles. ¡Sé el primero en crear uno!',
                  style: const TextStyle(
                    fontSize: Branding.fontSizeSubhead,
                    color: CupertinoColors.secondaryLabel,
                    shadows: [
                      Shadow(
                        color: CupertinoColors.black,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: Branding.spacingM),

                // Información adicional
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.info,
                      size: 16,
                      color: Branding.primaryPurple.withOpacity(0.8),
                    ),
                    const SizedBox(width: Branding.spacingXS),
                    const Expanded(
                      child: Text(
                        'Crea un evento o sigue comunidades para ver más contenido',
                        style: TextStyle(
                          fontSize: Branding.fontSizeCaption1,
                          color: CupertinoColors.secondaryLabel,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: Branding.spacingL),

                // Botones de acción
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PrimaryGlassButton(
                      text: 'Crear evento',
                      onPressed: onCreateEvent ??
                          () {
                            Navigator.pushNamed(
                                context, RouteNames.createEvent);
                          },
                    ),
                    const SizedBox(height: Branding.spacingM),
                    GlassButton(
                      text: 'Explorar comunidades',
                      onPressed: onExploreCommunities ??
                          () {
                            Navigator.pushNamed(
                                context, RouteNames.communities);
                          },
                      textColor: CupertinoColors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
