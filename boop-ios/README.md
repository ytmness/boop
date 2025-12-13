# BOOP iOS - SwiftUI con Liquid Glass

Aplicación iOS nativa desarrollada en SwiftUI con el efecto **Liquid Glass** de iOS 26.

## 🎨 Características

- **Liquid Glass Effect**: Implementación completa del efecto de vidrio líquido translúcido
- **SwiftUI Moderno**: Construido con SwiftUI y las últimas APIs de iOS 26
- **Componentes Reutilizables**: GlassCard, GlassButton, GlassBackground
- **Navegación Fluida**: Tab bar y navigation bars con efecto glass automático
- **Animaciones Suaves**: Transiciones y morphing entre elementos

## 📋 Requisitos

- **Xcode 26.1+** (o superior)
- **iOS 26.0+** (para Liquid Glass completo)
- **Swift 6.0+**

## 🏗️ Estructura del Proyecto

```
BoopApp/
├── BoopApp/
│   ├── BoopAppApp.swift          # Entry point
│   ├── ContentView.swift          # Main view router
│   ├── Views/
│   │   ├── Auth/
│   │   │   └── LoginView.swift    # Pantalla de login con glass
│   │   ├── Events/
│   │   │   └── EventsHubView.swift # Hub de eventos
│   │   ├── Profile/
│   │   │   └── ProfileView.swift   # Perfil de usuario
│   │   ├── ExploreView.swift
│   │   └── MainTabView.swift       # Navegación principal
│   ├── Components/
│   │   └── Glass/
│   │       ├── GlassCard.swift     # Tarjeta con efecto glass
│   │       ├── GlassButton.swift   # Botón interactivo glass
│   │       └── GlassBackground.swift
│   └── Utils/
│       └── GlassEffectExtensions.swift # Extensiones y helpers
```

## 🚀 Uso

### Componentes Básicos

#### GlassCard
```swift
GlassCard {
    Text("Contenido")
        .foregroundStyle(.white)
}
```

#### GlassButton
```swift
GlassButton("Iniciar Sesión", isProminent: true) {
    // Acción
}
```

#### Glass Effect Directo
```swift
Text("Hola")
    .padding()
    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
```

### GlassEffectContainer

Para agrupar múltiples elementos de vidrio:

```swift
GlassEffectContainer {
    VStack {
        Button1().glassEffect()
        Button2().glassEffect()
    }
}
```

### Morphing Animations

Para transiciones suaves entre vistas:

```swift
@Namespace private var glassNamespace

GlassEffectContainer {
    if expanded {
        Panel().glassEffectID("panel", in: glassNamespace)
    } else {
        Button().glassEffectID("panel", in: glassNamespace)
    }
}
```

## 📱 Pantallas

### Login
- Fondo con gradiente oscuro
- Formulario en tarjeta glass translúcida
- Botones interactivos con efecto glass
- Logo con efecto circular glass

### Events Hub
- Barra de búsqueda glass
- Grid de eventos con tarjetas glass
- Navegación con barra glass automática

### Profile
- Header de perfil con imagen glass
- Menú de opciones con items glass
- Botón de logout con tinte rojo

## 🎯 Buenas Prácticas

1. **No sobreusar**: Reserva Liquid Glass para navegación y controles, no para todo el contenido
2. **Contenedores**: Agrupa elementos cercanos en `GlassEffectContainer`
3. **Rendimiento**: Evita múltiples capas de glass apiladas
4. **Accesibilidad**: Respeta las preferencias del usuario (Reduce Transparency, etc.)

## ⚠️ Notas Importantes

- **iOS 26+**: El efecto Liquid Glass completo requiere iOS 26.0+
- **Fallback**: En versiones anteriores, se usa `.ultraThinMaterial` como fallback
- **Xcode 26**: Necesitas Xcode 26.1+ para compilar con las APIs de Liquid Glass

## 🔄 Migración desde Flutter

Este proyecto es una versión nativa SwiftUI del proyecto Flutter original. Las funcionalidades principales se mantienen:

- ✅ Autenticación
- ✅ Eventos
- ✅ Perfil
- ✅ Navegación por tabs

## 📚 Referencias

- [Apple WWDC25 - Meet Liquid Glass](https://developer.apple.com)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [iOS 26 Release Notes](https://developer.apple.com)

## 🛠️ Desarrollo

Para abrir el proyecto:

```bash
cd boop-ios
open BoopApp.xcodeproj
```

O crear el proyecto Xcode completo si aún no existe.

## 📝 TODO

- [ ] Integrar con Supabase
- [ ] Implementar autenticación real
- [ ] Agregar más pantallas (Create Event, Event Details)
- [ ] Integrar mapas con Google Maps
- [ ] Agregar notificaciones push
- [ ] Implementar pagos con Stripe

