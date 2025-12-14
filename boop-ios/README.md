# BOOP iOS - Aplicación Nativa SwiftUI

Aplicación iOS nativa con Liquid Glass usando SwiftUI y Supabase.

## Estructura del Proyecto

```
boop-ios/
├── Boop/
│   ├── App/
│   │   └── BoopApp.swift
│   ├── Core/
│   │   ├── Design/
│   │   │   ├── GlassComponents.swift
│   │   │   └── GlassExtensions.swift
│   │   ├── Config/
│   │   │   └── SupabaseConfig.swift
│   │   └── Models/
│   │       ├── Event.swift
│   │       └── User.swift
│   ├── Features/
│   │   ├── Auth/
│   │   │   ├── ViewModels/
│   │   │   │   └── AuthViewModel.swift
│   │   │   └── Views/
│   │   │       ├── PhoneLoginView.swift
│   │   │       ├── EmailLoginView.swift
│   │   │       └── VerifyOTPView.swift
│   │   ├── Events/
│   │   │   ├── Services/
│   │   │   │   └── EventService.swift
│   │   │   └── Views/
│   │   │       ├── EventsHubView.swift
│   │   │       └── CreateEventView.swift
│   │   └── Profile/
│   │       └── Views/
│   │           └── ProfileView.swift
│   └── Shared/
│       └── Components/
│           └── GlassButton.swift
└── Package.swift (SPM dependencies)
```

## Configuración

1. **Crear proyecto Xcode:**
   - Abre Xcode
   - File > New > Project
   - iOS > App
   - Nombre: `Boop`
   - Interface: SwiftUI
   - Language: Swift

2. **Agregar dependencias (SPM):**
   - File > Add Package Dependencies
   - URL: `https://github.com/supabase/supabase-swift`
   - Versión: Latest

3. **Copiar archivos:**
   - Copia todos los archivos de esta carpeta a tu proyecto Xcode
   - Asegúrate de que los archivos estén en los targets correctos

4. **Configurar Supabase:**
   - Edita `SupabaseConfig.swift` con tus credenciales (ya están configuradas desde Flutter)

## Características

- ✅ Liquid Glass nativo (iOS 26+) con fallback a `.ultraThinMaterial`
- ✅ Flujo OTP idéntico a Flutter (8 dígitos, email/phone)
- ✅ Misma base Supabase que Flutter
- ✅ Pantallas: Login, VerifyOTP, Home, Profile, CreateEvent

## 🎨 Liquid Glass

### Componentes Básicos

#### GlassButton
```swift
GlassButton(title: "Iniciar Sesión", action: {})
```

#### GlassTextField
```swift
GlassTextField(placeholder: "Email", text: $email)
```

#### GlassContainer
```swift
GlassContainer {
    Text("Contenido")
        .foregroundStyle(.white)
}
```

### Extensiones

```swift
// Aplicar efecto glass directamente
Text("Hola")
    .boopGlassEffect(interactive: true)

// Botón circular glass
Image(systemName: "plus")
    .boopGlassCircleButton(diameter: 64)
```

## 📱 Pantallas

### Login
- Fondo oscuro
- Formulario en tarjeta glass translúcida
- Botones interactivos con efecto glass
- Soporte para teléfono y email

### VerifyOTP
- 8 campos de código
- Verificación automática al completar
- Reenvío de código

### Events Hub
- Grid de eventos con cards glass
- Navegación con barra glass automática

### Profile
- Header de perfil
- Información del usuario
- Botón de logout

## ⚠️ Notas Importantes

- **iOS 26+**: El efecto Liquid Glass completo requiere iOS 26.0+
- **Fallback**: En versiones anteriores, se usa `.ultraThinMaterial` como fallback
- **Xcode**: Necesitas Xcode 15.0+ para compilar

## 🔄 Migración desde Flutter

Este proyecto es una versión nativa SwiftUI del proyecto Flutter original. Las funcionalidades principales se mantienen:

- ✅ Autenticación OTP (8 dígitos)
- ✅ Eventos (CRUD completo)
- ✅ Perfil
- ✅ Navegación por tabs
- ✅ Misma base Supabase

## 📚 Referencias

- [Apple WWDC25 - Meet Liquid Glass](https://developer.apple.com)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Supabase Swift](https://github.com/supabase/supabase-swift)
