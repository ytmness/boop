# Cómo usar el video de YouTube optimizado

## Uso básico

```dart
import 'package:boop/shared/widgets/youtube_video_background.dart';

// En tu pantalla, reemplaza VideoBackground con:
YoutubeVideoBackground(
  youtubeVideoId: '0WQTZvunC2Q', // ID del video o URL completa
  opacity: 0.9,
)
```

## Ventajas del streaming de YouTube

✅ **Eficiente**: Solo carga lo necesario, no descarga todo el video de 10 horas
✅ **Variación**: Cada vez que se carga, empieza en un punto aleatorio diferente
✅ **Sin peso**: No aumenta el tamaño de tu app
✅ **Siempre diferente**: El video de 10 horas siempre se verá diferente

## Extraer ID de URL

El widget automáticamente extrae el ID de URLs como:
- `https://www.youtube.com/watch?v=0WQTZvunC2Q`
- `https://youtu.be/0WQTZvunC2Q`
- O simplemente el ID: `0WQTZvunC2Q`

## Ejemplo completo

```dart
YoutubeVideoBackground(
  youtubeVideoId: 'https://www.youtube.com/watch?v=0WQTZvunC2Q',
  opacity: 0.9,
  autoplay: true,
  loop: true,
  muted: true,
  startSeconds: null, // null = tiempo aleatorio (0-3600 segundos)
)
```

