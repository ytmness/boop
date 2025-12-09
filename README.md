# BOOP - Aplicación Móvil de Eventos

Aplicación móvil desarrollada con Flutter y Supabase para descubrir, crear y gestionar eventos.

## Características

- 🔐 Autenticación multi-método (Teléfono OTP, Email, Apple ID)
- 🎉 Exploración de eventos públicos y contenido social
- 👥 Gestión de comunidades y amigos
- 🎫 Creación y gestión de eventos
- 💳 Venta de tickets con integración Stripe
- 📊 Panel administrativo para organizadores
- 📱 Diseño nativo iOS con Flutter Cupertino

## Requisitos Previos

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Cuenta de Supabase
- Cuenta de Stripe (para pagos)
- Firebase (para notificaciones push)

## Configuración

### 1. Clonar el repositorio

```bash
git clone <repository-url>
cd BOOP
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Configurar variables de entorno

Crea un archivo `.env` en la raíz del proyecto o configura las variables de entorno:

```bash
SUPABASE_URL=tu_url_de_supabase
SUPABASE_ANON_KEY=tu_anon_key_de_supabase
```

O edita directamente `lib/core/config/supabase_config.dart` con tus credenciales.

### 4. Configurar Supabase

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

```bash
flutter run
```

## Estructura del Proyecto

```
lib/
├── core/                 # Configuración y utilidades core
│   ├── config/          # Configuración de Supabase, etc.
│   ├── theme/           # Temas y colores
│   └── services/        # Servicios compartidos
├── features/            # Módulos por funcionalidad
│   ├── auth/           # Autenticación
│   ├── events/         # Eventos
│   ├── profile/        # Perfil de usuario
│   ├── explore/        # Exploración
│   ├── communities/    # Comunidades
│   ├── friends/        # Amigos
│   └── tickets/        # Tickets y pagos
├── shared/             # Recursos compartidos
│   ├── widgets/        # Widgets reutilizables
│   └── models/         # Modelos de datos
└── routes/             # Configuración de navegación
```

## Desarrollo

### Generar código Riverpod

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Ejecutar tests

```bash
flutter test
```

## Licencia

[Especificar licencia]

