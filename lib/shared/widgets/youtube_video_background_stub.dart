import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:ui';

/// Widget optimizado que reproduce un video de YouTube como fondo
/// Versión para iOS/Android - usa youtube_player_flutter
class YoutubeVideoBackground extends StatefulWidget {
  final String youtubeVideoId;
  final double? opacity;
  final BoxFit fit;
  final bool autoplay;
  final bool loop;
  final bool muted;
  final int? startSeconds;

  const YoutubeVideoBackground({
    super.key,
    required this.youtubeVideoId,
    this.opacity,
    this.fit = BoxFit.cover,
    this.autoplay = true,
    this.loop = true,
    this.muted = true,
    this.startSeconds,
  });

  /// Extrae el ID del video de una URL de YouTube
  static String extractVideoId(String youtubeUrl) {
    final uri = Uri.parse(youtubeUrl);
    if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'] ?? '';
    } else if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
    }
    return youtubeUrl;
  }

  @override
  State<YoutubeVideoBackground> createState() => _YoutubeVideoBackgroundState();
}

class _YoutubeVideoBackgroundState extends State<YoutubeVideoBackground> {
  YoutubePlayerController? _controller;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    final videoId =
        YoutubeVideoBackground.extractVideoId(widget.youtubeVideoId);

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: widget.autoplay,
        loop: widget.loop,
        mute: widget.muted,
        startAt: widget.startSeconds ?? 0,
        hideControls: true,
        controlsVisibleAtStart: false,
        enableCaption: false,
      ),
    );

    _controller!.addListener(() {
      if (_controller!.value.isReady && !_isReady) {
        setState(() {
          _isReady = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      // Mientras se inicializa, mostrar gradiente
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF4A90E2),
              const Color(0xFF5B9BD5),
              const Color(0xFF00F0FF),
              const Color(0xFF7ED321),
              const Color(0xFF8E5AFF),
              const Color(0xFFB89CFF),
            ],
            stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Video de YouTube con blur
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Opacity(
                opacity: widget.opacity ?? 0.9,
                child: YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    controller: _controller!,
                    aspectRatio: 16 / 9,
                    showVideoProgressIndicator: false,
                    progressIndicatorColor: Colors.transparent,
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.transparent,
                      handleColor: Colors.transparent,
                      bufferedColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  builder: (context, player) {
                    return SizedBox.expand(
                      child: FittedBox(
                        fit: widget.fit,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 2,
                          height: MediaQuery.of(context).size.height * 2,
                          child: player,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        // Indicador de carga mientras se inicializa
        if (!_isReady)
          Container(
            color: CupertinoColors.black.withOpacity(0.3),
            child: const Center(
              child: CupertinoActivityIndicator(),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
