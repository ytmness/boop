import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Import condicional: usar dart:html en web, stub en otras plataformas
import 'dart:html' if (dart.library.io) 'html_stub.dart' as html;

/// Widget optimizado que reproduce un video de YouTube como fondo
/// Usa iframe embebido para streaming eficiente - solo carga lo necesario
/// Perfecto para videos largos sin consumir mucho ancho de banda
class YoutubeVideoBackground extends StatefulWidget {
  final String youtubeVideoId;
  final double? opacity;
  final BoxFit fit;
  final bool autoplay;
  final bool loop;
  final bool muted;
  final int? startSeconds; // Tiempo de inicio aleatorio para variación

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
    return youtubeUrl; // Si ya es un ID, devolverlo tal cual
  }

  @override
  State<YoutubeVideoBackground> createState() => _YoutubeVideoBackgroundState();
}

class _YoutubeVideoBackgroundState extends State<YoutubeVideoBackground> {
  dynamic _container; // html.DivElement? en web
  dynamic _iframe; // html.IFrameElement? en web
  String? _containerId;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _containerId = 'youtube-bg-${DateTime.now().millisecondsSinceEpoch}';
      // Crear el iframe después del primer frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _createIframe();
      });
    }
  }

  void _updateSize() {
    if (!kIsWeb || _container == null || _iframe == null) return;
    
    // Solo ejecutar en web
    if (!kIsWeb) return;
    
    final width = (html.window.innerWidth ?? 1920) as int;
    final height = (html.window.innerHeight ?? 1080) as int;

    // Forzar tamaño del contenedor usando píxeles y viewport units
    _container!.style.setProperty('width', '100vw', 'important');
    _container!.style.setProperty('height', '100vh', 'important');
    _container!.style.setProperty('min-width', '100vw', 'important');
    _container!.style.setProperty('min-height', '100vh', 'important');
    _container!.style.width = '${width}px';
    _container!.style.height = '${height}px';
    _container!.style.minWidth = '${width}px';
    _container!.style.minHeight = '${height}px';
    // Asegurar que el blur se mantenga
    _container!.style.setProperty('filter', 'blur(8px)', 'important');
    _container!.style.setProperty('-webkit-filter', 'blur(8px)', 'important');

    // Forzar tamaño del iframe usando píxeles y viewport units
    _iframe!.style.setProperty('width', '100vw', 'important');
    _iframe!.style.setProperty('height', '100vh', 'important');
    _iframe!.style.setProperty('min-width', '100vw', 'important');
    _iframe!.style.setProperty('min-height', '100vh', 'important');
    _iframe!.style.setProperty('max-width', '100vw', 'important');
    _iframe!.style.setProperty('max-height', '100vh', 'important');
    _iframe!.style.setProperty('position', 'absolute', 'important');
    _iframe!.style.setProperty('top', '0', 'important');
    _iframe!.style.setProperty('left', '0', 'important');
    _iframe!.style.setProperty('right', '0', 'important');
    _iframe!.style.setProperty('bottom', '0', 'important');
    _iframe!.style.width = '${width}px';
    _iframe!.style.height = '${height}px';
    _iframe!.style.minWidth = '${width}px';
    _iframe!.style.minHeight = '${height}px';
    _iframe!.style.maxWidth = '${width}px';
    _iframe!.style.maxHeight = '${height}px';
    // Asegurar que el blur se mantenga en el iframe
    _iframe!.style.setProperty('filter', 'blur(8px)', 'important');
    _iframe!.style.setProperty('-webkit-filter', 'blur(8px)', 'important');

    // También establecer atributos directamente
    _iframe!.setAttribute('width', '$width');
    _iframe!.setAttribute('height', '$height');
  }

  void _createIframe() {
    if (!kIsWeb || _container != null || _containerId == null) return;

    // Generar tiempo de inicio aleatorio si no se especifica (para variación)
    final startTime = widget.startSeconds ??
        (DateTime.now().millisecondsSinceEpoch % 3600); // 0-3600 segundos

    // Extraer ID del video si es una URL completa
    final videoId =
        YoutubeVideoBackground.extractVideoId(widget.youtubeVideoId);

    // Construir URL de embed de YouTube optimizada
    final embedUrl = 'https://www.youtube.com/embed/$videoId?'
        'autoplay=${widget.autoplay ? 1 : 0}&'
        'loop=${widget.loop ? 1 : 0}&'
        'mute=${widget.muted ? 1 : 0}&'
        'controls=0&' // Sin controles
        'showinfo=0&' // Sin información
        'rel=0&' // Sin videos relacionados
        'modestbranding=1&' // Branding mínimo
        'playsinline=1&' // Reproducir inline
        'enablejsapi=1&' // Habilitar API JS
        'playlist=$videoId&' // Necesario para loop
        'start=$startTime&' // Tiempo de inicio
        'iv_load_policy=3&' // Sin anotaciones
        'cc_load_policy=0&' // Sin subtítulos
        'fs=0&' // Sin pantalla completa
        'disablekb=1'; // Deshabilitar teclado

    // Crear contenedor usando unidades de viewport para llenar toda la pantalla
    _container = html.DivElement()
      ..id = _containerId!
      ..style.width = '100vw'
      ..style.height = '100vh'
      ..style.position = 'fixed'
      ..style.top = '0px'
      ..style.left = '0px'
      ..style.right = '0px'
      ..style.bottom = '0px'
      ..style.overflow = 'hidden'
      ..style.backgroundColor = 'transparent'
      ..style.pointerEvents = 'none'
      ..style.display = 'block'
      ..style.visibility = 'visible'
      ..style.opacity = '1'
      ..style.zIndex =
          '0' // z-index 0 para estar detrás de Flutter (que tiene z-index 10+)
      ..style.margin = '0'
      ..style.padding = '0'
      ..style.filter =
          'blur(8px)' // Blur muy suave para ver claramente las luces y colores
      ..style.setProperty('-webkit-filter', 'blur(8px)')
      ..setAttribute('data-youtube-bg', 'true');

    // Obtener dimensiones reales para establecer atributos del iframe
    final windowWidth = html.window.innerWidth ?? 1920;
    final windowHeight = html.window.innerHeight ?? 1080;

    // Crear iframe usando unidades de viewport para llenar toda la pantalla
    _iframe = html.IFrameElement()
      ..src = embedUrl
      ..setAttribute('width', '$windowWidth')
      ..setAttribute('height', '$windowHeight')
      ..setAttribute('frameborder', '0')
      ..setAttribute('scrolling', 'no')
      ..style.border = 'none'
      ..style.width = '100vw'
      ..style.height = '100vh'
      ..style.minWidth = '100vw'
      ..style.minHeight = '100vh'
      ..style.maxWidth = '100vw'
      ..style.maxHeight = '100vh'
      ..style.position = 'absolute'
      ..style.top = '0px'
      ..style.left = '0px'
      ..style.right = '0px'
      ..style.bottom = '0px'
      ..style.transform =
          'scale(4.0)' // Escalar para cubrir completamente el área
      ..style.transformOrigin = 'center center'
      ..style.display = 'block'
      ..style.opacity = '1'
      ..style.visibility = 'visible'
      ..style.pointerEvents = 'none'
      ..style.margin = '0'
      ..style.padding = '0'
      ..style.boxSizing = 'border-box'
      ..style.overflow = 'hidden'
      ..style.filter =
          'blur(8px)' // Blur muy suave aplicado directamente al iframe
      ..style.setProperty('-webkit-filter', 'blur(8px)')
      ..allowFullscreen = false
      ..allow = 'autoplay; encrypted-media'
      ..setAttribute('loading', 'eager'); // Cargar inmediatamente

    // Agregar listener para cuando el iframe esté cargado
    _iframe!.onLoad.listen((_) {
      _updateSize();
      Future.delayed(const Duration(milliseconds: 100), () => _updateSize());
      Future.delayed(const Duration(milliseconds: 500), () => _updateSize());
      Future.delayed(const Duration(milliseconds: 1000), () => _updateSize());
    });

    // Listener para redimensionar cuando cambie el tamaño de la ventana
    html.window.onResize.listen((_) {
      _updateSize();
    });

    _container!.append(_iframe!);

    // Insertar directamente en el body al inicio
    if (html.document.body != null) {
      html.document.body!.insertAdjacentElement('afterbegin', _container!);

      // Forzar estilos con !important después de insertar usando viewport units
      Future.delayed(const Duration(milliseconds: 50), () {
        final container = html.document.getElementById(_containerId!);
        if (container != null) {
          container.style.setProperty('display', 'block', 'important');
          container.style.setProperty('visibility', 'visible', 'important');
          container.style.setProperty('opacity', '1', 'important');
          container.style.setProperty('z-index', '0', 'important');
          container.style.setProperty('position', 'fixed', 'important');
          container.style.setProperty('width', '100vw', 'important');
          container.style.setProperty('height', '100vh', 'important');
          container.style.setProperty('top', '0', 'important');
          container.style.setProperty('left', '0', 'important');
          container.style.setProperty('right', '0', 'important');
          container.style.setProperty('bottom', '0', 'important');
          // Aplicar blur muy suave directamente al contenedor del video
          container.style.setProperty('filter', 'blur(8px)', 'important');
          container.style
              .setProperty('-webkit-filter', 'blur(8px)', 'important');

          final iframeInContainer =
              container.querySelector('iframe') as html.IFrameElement?;
          if (iframeInContainer != null) {
            iframeInContainer.style
                .setProperty('display', 'block', 'important');
            iframeInContainer.style
                .setProperty('visibility', 'visible', 'important');
            iframeInContainer.style.setProperty('opacity', '1', 'important');
            iframeInContainer.style.setProperty('width', '100vw', 'important');
            iframeInContainer.style.setProperty('height', '100vh', 'important');
            iframeInContainer.style
                .setProperty('min-width', '100vw', 'important');
            iframeInContainer.style
                .setProperty('min-height', '100vh', 'important');
            iframeInContainer.style
                .setProperty('position', 'absolute', 'important');
            iframeInContainer.style.setProperty('top', '0', 'important');
            iframeInContainer.style.setProperty('left', '0', 'important');
            iframeInContainer.style.setProperty('right', '0', 'important');
            iframeInContainer.style.setProperty('bottom', '0', 'important');
            // Aplicar blur también al iframe directamente
            iframeInContainer.style
                .setProperty('filter', 'blur(8px)', 'important');
            iframeInContainer.style
                .setProperty('-webkit-filter', 'blur(8px)', 'important');
          }
        }
      });

      // Asegurar tamaño múltiples veces después de insertar
      Future.delayed(const Duration(milliseconds: 100), () {
        _updateSize();
        final container = html.document.getElementById(_containerId!);
        if (container != null) {
          final iframe =
              container.querySelector('iframe') as html.IFrameElement?;
          if (iframe != null) {
            // Forzar tamaño directamente en el DOM
            final width = html.window.innerWidth ?? 1920;
            final height = html.window.innerHeight ?? 1080;

            // Aplicar tamaño de múltiples formas
            container.style.setProperty('width', '100vw', 'important');
            container.style.setProperty('height', '100vh', 'important');
            container.style.width = '${width}px';
            container.style.height = '${height}px';
            // Asegurar que el blur se aplique
            container.style.setProperty('filter', 'blur(8px)', 'important');
            container.style
                .setProperty('-webkit-filter', 'blur(8px)', 'important');

            iframe.style.setProperty('width', '100vw', 'important');
            iframe.style.setProperty('height', '100vh', 'important');
            iframe.style.setProperty('transform', 'scale(4.0)', 'important');
            iframe.style
                .setProperty('transform-origin', 'center center', 'important');
            iframe.style.width = '${width}px';
            iframe.style.height = '${height}px';
            iframe.setAttribute('width', '$width');
            iframe.setAttribute('height', '$height');
            // Asegurar que el blur se aplique al iframe también
            iframe.style.setProperty('filter', 'blur(8px)', 'important');
            iframe.style
                .setProperty('-webkit-filter', 'blur(8px)', 'important');
          }
        }
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        _updateSize();
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        _updateSize();
        if (mounted) {
          setState(() {
            _isReady = true;
          });
        }
      });
    } else {
      // Si el body no está disponible, esperar un poco
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && html.document.body != null && _container != null) {
          html.document.body!.insertAdjacentElement('afterbegin', _container!);
          _updateSize();
          if (mounted) {
            setState(() {
              _isReady = true;
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return Container(color: CupertinoColors.black);
    }

    // Verificar si el contenedor existe en el DOM
    if (kIsWeb && _containerId != null) {
      final containerInDom = html.document.getElementById(_containerId!);
      if (containerInDom != null && !_isReady) {
        // El contenedor existe pero aún no está marcado como listo
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() {
              _isReady = true;
            });
          }
        });
      }
    }

    return Stack(
      children: [
        // Fondo transparente para que se vea el video de fondo
        Container(
          color: Colors.transparent,
        ),
        // El iframe se inserta directamente en el DOM, así que solo mostramos un placeholder
        // El iframe está en el body y se renderiza detrás de Flutter
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
    if (kIsWeb && _container != null) {
      _container!.remove();
    }
    super.dispose();
  }
}
