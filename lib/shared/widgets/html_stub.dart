// Stub para dart:html en plataformas no-web
// Este archivo proporciona stubs vacíos para todas las clases de dart:html

class CssStyleDeclaration {
  String width = '';
  String height = '';
  String minWidth = '';
  String minHeight = '';
  String maxWidth = '';
  String maxHeight = '';
  String position = '';
  String top = '';
  String left = '';
  String right = '';
  String bottom = '';
  String transform = '';
  String transformOrigin = '';
  String display = '';
  String visibility = '';
  String opacity = '';
  String zIndex = '';
  String margin = '';
  String padding = '';
  String filter = '';
  String border = '';
  String overflow = '';
  String backgroundColor = '';
  String pointerEvents = '';
  String boxSizing = '';
  
  void setProperty(String property, String value, [String? priority]) {}
}

class Window {
  int? get innerWidth => null;
  int? get innerHeight => null;
  Stream<dynamic> get onResize => const Stream.empty();
}

class Document {
  dynamic get body => null;
  dynamic getElementById(String id) => null;
}

class DivElement {
  String? id;
  CssStyleDeclaration style = CssStyleDeclaration();
  void setAttribute(String name, String value) {}
  void insertAdjacentElement(String position, dynamic element) {}
  void append(dynamic element) {}
  void remove() {}
  dynamic querySelector(String selector) => null;
}

class IFrameElement {
  String? src;
  CssStyleDeclaration style = CssStyleDeclaration();
  bool allowFullscreen = false;
  String? allow = '';
  Stream<dynamic> get onLoad => const Stream.empty();
  void setAttribute(String name, String value) {}
}

final window = Window();
final document = Document();

