import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_theme.dart';

/// Enum para el modo de tema de la aplicación
enum AppThemeMode {
  system,
  light,
  dark,
}

/// Provider para manejar el tema de la aplicación
/// Permite cambiar entre modo claro y oscuro dinámicamente
final themeModeProvider = StateProvider<AppThemeMode>((ref) => AppThemeMode.system);

/// Provider que retorna el tema actual basado en el AppThemeMode
final currentThemeProvider = Provider<CupertinoThemeData>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
  
  // Si es system, usar el brightness del sistema
  if (themeMode == AppThemeMode.system) {
    return brightness == Brightness.dark
        ? AppTheme.darkTheme
        : AppTheme.lightTheme;
  }
  
  // Si es manual, usar el seleccionado
  return themeMode == AppThemeMode.dark
      ? AppTheme.darkTheme
      : AppTheme.lightTheme;
});

/// Helper para cambiar el tema
class ThemeHelper {
  static void setThemeMode(WidgetRef ref, AppThemeMode mode) {
    ref.read(themeModeProvider.notifier).state = mode;
  }
  
  static void toggleTheme(WidgetRef ref) {
    final current = ref.read(themeModeProvider);
    final newMode = current == AppThemeMode.dark
        ? AppThemeMode.light
        : AppThemeMode.dark;
    ref.read(themeModeProvider.notifier).state = newMode;
  }
}

