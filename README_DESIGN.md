# 🎨 Sistema de Diseño BOOP - Apple Style

## Visión General

BOOP implementa un sistema de diseño inspirado en las **Apple Human Interface Guidelines** con efectos **Liquid Glass** (vidrio esmerilado), animaciones suaves y una paleta de colores morada/lavanda.

## 🎨 Branding

### Paleta de Colores

- **Morado Principal**: `#8B5CF6` - Color principal de la marca
- **Morado Oscuro**: `#6D28D9` - Para elementos destacados
- **Morado Claro**: `#A78BFA` - Para acentos sutiles
- **Lavanda**: `#C4B5FD` - Color secundario
- **Violeta**: `#7C3AED` - Para gradientes

### Tipografía

- **Display**: `.SF Pro Display` - Para títulos grandes (34pt)
- **Text**: `.SF Pro Text` - Para texto normal (17pt)
- **Rounded**: `.SF Pro Rounded` - Para elementos especiales

### Espaciado

Sistema de 8pt siguiendo Apple HIG:
- XS: 4pt
- S: 8pt
- M: 16pt
- L: 24pt
- XL: 32pt
- XXL: 48pt

## 🔮 Componentes Glass

### GlassContainer

Widget base para crear efectos de vidrio esmerilado:

```dart
GlassContainer(
  child: Text('Contenido con efecto glass'),
  borderRadius: Branding.radiusMedium,
  blur: Branding.glassBlur,
)
```

### GlassCard

Card con efecto glass y bordes sutiles:

```dart
GlassCard(
  child: Column(...),
  onTap: () {},
)
```

### GlassButton

Botón con efecto glass y animación bounce:

```dart
GlassButton(
  text: 'Continuar',
  onPressed: () {},
)
```

### PrimaryGlassButton

Botón primario con gradiente morado:

```dart
PrimaryGlassButton(
  text: 'Iniciar Sesión',
  onPressed: () {},
)
```

## ✨ Animaciones

### AppleFadeTransition

Fade in/out suave:

```dart
AppleFadeTransition(
  visible: isVisible,
  child: Widget(),
)
```

### AppleScaleTransition

Escala tipo Apple:

```dart
AppleScaleTransition(
  visible: isVisible,
  child: Widget(),
)
```

### AppleSlideTransition

Slide suave:

```dart
AppleSlideTransition(
  visible: isVisible,
  offset: Offset(0, 0.1),
  child: Widget(),
)
```

### AppleBounceAnimation

Animación bounce para botones:

```dart
AppleBounceAnimation(
  onTap: () {},
  child: Button(),
)
```

## 🌓 Modo Oscuro

El tema se adapta automáticamente al modo del sistema:

```dart
// Cambiar tema manualmente
ThemeHelper.setThemeMode(ref, ThemeMode.dark);

// Alternar tema
ThemeHelper.toggleTheme(ref);
```

## 📱 Componentes UI

### GlassEventCard

Card de evento con efecto glass:

```dart
GlassEventCard(
  event: eventModel,
  onTap: () {},
)
```

### GlassModal

Modal con efecto glass:

```dart
GlassModal.show(
  context: context,
  title: 'Título',
  child: Content(),
)
```

## 🎯 Uso Recomendado

1. **Cards y Contenedores**: Usa `GlassCard` para elementos destacados
2. **Botones**: Usa `PrimaryGlassButton` para acciones principales
3. **Modales**: Usa `GlassModal` para diálogos y acciones secundarias
4. **Animaciones**: Envuelve elementos interactivos con animaciones Apple
5. **Espaciado**: Usa constantes de `Branding` para mantener consistencia

## 📚 Archivos Clave

- `lib/core/branding/branding.dart` - Sistema de branding completo
- `lib/shared/components/glass/` - Componentes Glass
- `lib/shared/components/animations/` - Animaciones Apple-style
- `lib/core/theme/` - Temas claro/oscuro

## 🚀 Próximos Pasos

- [ ] Agregar más componentes Glass (inputs, listas, etc.)
- [ ] Implementar Hero animations para transiciones
- [ ] Crear sistema de iconografía personalizado
- [ ] Agregar más variantes de Glass (GlassInput, GlassList, etc.)

