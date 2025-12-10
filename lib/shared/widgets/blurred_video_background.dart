import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'youtube_video_background.dart';

/// Widget wrapper que proporciona el fondo de video difuminado
/// para usar en todas las pantallas de la aplicación
class BlurredVideoBackground extends StatelessWidget {
  final Widget child;
  final double blurIntensity;

  const BlurredVideoBackground({
    super.key,
    required this.child,
    this.blurIntensity = 8.0, // Reducido para ver más detalles del video
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Video de YouTube como fondo - streaming optimizado
        YoutubeVideoBackground(
          youtubeVideoId: '0WQTZvunC2Q', // ID del video de YouTube
          opacity: 0.9,
        ),

        // Capa de blur suave - se ven claramente las luces y colores del video
        // Mantiene la luz del video para destacar los botones transparentes
        BackdropFilter(
          filter:
              ImageFilter.blur(sigmaX: blurIntensity, sigmaY: blurIntensity),
          child: Container(
            color: Colors.transparent, // Sin overlay para que se vean las luces
          ),
        ),

        // Contenido de la pantalla
        child,
      ],
    );
  }
}
