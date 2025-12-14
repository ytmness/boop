# BOOP - Aplicación iOS de Eventos

Aplicación iOS nativa desarrollada con SwiftUI y Supabase para descubrir, crear y gestionar eventos.

## Características

- 🔐 Autenticación multi-método (Teléfono OTP, Email, Apple ID)
- 🎉 Exploración de eventos públicos y contenido social
- 👥 Gestión de comunidades y amigos
- 🎫 Creación y gestión de eventos
- 💳 Venta de tickets con integración Stripe
- 📊 Panel administrativo para organizadores
- 🎨 Liquid Glass UI (iOS 26+) con fallback a materiales

## Requisitos Previos

- Xcode 15.0+
- iOS 17.0+ (iOS 26.0+ para Liquid Glass completo)
- Cuenta de Supabase
- Cuenta de Stripe (para pagos)
- Swift Package Manager

## Configuración

### 1. Clonar el repositorio

```bash
git clone <repository-url>
cd boop-main
```

### 2. Abrir el proyecto

```bash
cd boop-ios/BoopApp
open BoopApp.xcodeproj
```

### 3. Configurar Supabase

Edita `boop-ios/Boop/Core/Config/SupabaseConfig.swift` con tus credenciales:

```swift
static let url = "tu_url_de_supabase"
static let anonKey = "tu_anon_key_de_supabase"
```

### 4. Configurar Supabase Backend

1. Crea un proyecto en [Supabase](https://supabase.com)
2. Ejecuta los scripts SQL para crear las tablas (ver `supabase/migrations/`)
3. Configura los buckets de Storage:
   - `avatars`
   - `event-images`
   - `memories`
4. Configura las políticas RLS según las necesidades de seguridad

### 5. Configurar Stripe

1. Crea una cuenta en [Stripe](https://stripe.com)
2. Obtén tus API keys (test y producción)
3. Configura los webhooks en Stripe Dashboard apuntando a tu Edge Function
4. Agrega las keys como secretos en Supabase:
   - `STRIPE_SECRET_KEY`
   - `STRIPE_WEBHOOK_SECRET`

### 6. Ejecutar la aplicación

1. Selecciona un simulador o dispositivo en Xcode
2. Presiona `Cmd + R` o haz clic en el botón Run

## Estructura del Proyecto

```
boop-ios/
├── BoopApp/
│   └── BoopApp/
│       ├── BoopAppApp.swift          # Entry point
│       ├── ContentView.swift         # Root view
│       ├── Core/
│       │   └── DesignTokens.swift    # Design tokens
│       ├── DesignSystem/
│       │   └── GlassComponents.swift # Liquid Glass components
│       ├── Features/
│       │   └── Auth/
│       │       └── ViewModels/
│       │           └── AuthViewModel.swift
│       ├── Utils/
│       │   └── GlassEffectExtensions.swift
│       └── Views/
│           ├── Auth/                 # Login, Splash
│           ├── Events/               # Events Hub, Create Event
│           ├── ExploreView.swift     # Explore feed
│           ├── MainTabView.swift     # Tab navigation
│           └── Profile/              # Profile, Settings
└── Boop/                             # Shared modules
    ├── App/
    ├── Core/
    │   ├── Config/                   # Supabase config
    │   ├── Design/                   # Design system
    │   └── Models/                   # Data models
    └── Features/                     # Feature modules
```

## Pestañas de la Aplicación

Según el BRIEF, la app incluye:

1. **Explore** - Feed público de eventos con selector de ciudad
2. **Search** - Búsqueda de eventos, usuarios y comunidades
3. **Create Event** - Crear nuevo evento (modal)
4. **Activity** - Feed de actividad (notificaciones, interacciones)
5. **Profile** - Perfil de usuario y configuración

### Events Hub

Dentro del hub de eventos hay tabs adicionales:
- **Explore** - Eventos públicos
- **Following** - Eventos de comunidades/usuarios seguidos
- **My Events** - Eventos creados por el usuario
- Filtros: Host/Tickets/History

## Desarrollo

### Dependencias

El proyecto usa Swift Package Manager. Las dependencias se gestionan desde Xcode:
- File > Add Package Dependencies
- Agregar: `https://github.com/supabase/supabase-swift`

### Liquid Glass

La app usa Liquid Glass nativo de iOS 26+ con fallback automático a `.ultraThinMaterial` en versiones anteriores.

## Licencia

[Especificar licencia]
