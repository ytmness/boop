import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'dart:ui';

/// Widget que reproduce un video como fondo en loop
/// Perfecto para efectos de liquid glass tipo Apple
class VideoBackground extends StatefulWidget {
  final String videoPath;
  final double? opacity;
  final BoxFit fit;

  const VideoBackground({
    super.key,
    required this.videoPath,
    this.opacity,
    this.fit = BoxFit.cover,
  });

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _userInteracted = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      debugPrint('🎬 Inicializando video: ${widget.videoPath}');
      final controller = VideoPlayerController.asset(widget.videoPath);
      _controller = controller;
      
      // Agregar listener para detectar cuando está listo
      controller.addListener(_videoListener);
      
      // Inicializar el video
      await controller.initialize();
      
      debugPrint('✅ Video inicializado. Tamaño: ${controller.value.size}');
      
      if (mounted && _controller == controller && controller.value.isInitialized) {
        // Configurar loop
        await controller.setLooping(true);
        
        setState(() {
          _isInitialized = true;
          _hasError = false;
        });
        
        // No intentar reproducir automáticamente en web (requiere interacción del usuario)
        // El video se reproducirá cuando el usuario interactúe con la página
        debugPrint('⏸️ Video inicializado, esperando interacción del usuario...');
      } else {
        debugPrint('❌ Video no inicializado correctamente');
        controller.dispose();
        _controller = null;
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error inicializando video: $e');
      debugPrint('Stack trace: $stackTrace');
      _controller?.removeListener(_videoListener);
      _controller?.dispose();
      _controller = null;
      if (mounted) {
        setState(() {
          _isInitialized = false;
          _hasError = true;
        });
      }
    }
  }

  void _videoListener() {
    if (_controller != null && mounted) {
      // Si el video terminó y no está en loop, reiniciarlo
      if (_controller!.value.position >= _controller!.value.duration &&
          !_controller!.value.isLooping) {
        _controller!.seekTo(Duration.zero);
        _controller!.play();
      }
      
      // Si hay un error, marcarlo
      if (_controller!.value.hasError) {
        debugPrint('❌ Error en el video: ${_controller!.value.errorDescription}');
        if (mounted) {
          setState(() {
            _hasError = true;
            _isInitialized = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  void _handleUserInteraction() {
    if (!_userInteracted && _controller != null && _isInitialized) {
      _userInteracted = true;
      _controller!.play().then((_) {
        debugPrint('▶️ Video iniciado después de interacción del usuario');
      }).catchError((e) {
        debugPrint('❌ Error al reproducir video: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Siempre mostrar fondo degradado animado (el video puede no funcionar en web)
    return GestureDetector(
      onTap: _handleUserInteraction,
      onPanStart: (_) => _handleUserInteraction(),
      child: Stack(
        children: [
          // Fondo degradado como base
          Container(
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
          ),
          // Video si está inicializado y funcionando
          if (_isInitialized && 
              _controller != null && 
              _controller!.value.isInitialized &&
              !_hasError)
            Opacity(
              opacity: widget.opacity ?? 1.0,
              child: SizedBox.expand(
                child: FittedBox(
                  fit: widget.fit,
                  child: SizedBox(
                    width: _controller!.value.size.width > 0 
                        ? _controller!.value.size.width 
                        : 1920,
                    height: _controller!.value.size.height > 0 
                        ? _controller!.value.size.height 
                        : 1080,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

