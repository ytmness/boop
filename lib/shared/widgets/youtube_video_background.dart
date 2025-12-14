/// Export condicional de YoutubeVideoBackground
/// En Web usa la versión con dart:html, en iOS/Android usa la versión stub
export 'youtube_video_background_stub.dart'
    if (dart.library.html) 'youtube_video_background_web.dart';
