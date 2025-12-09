# Arquitectura de BOOP

## Stack Tecnológico

- **Frontend**: Flutter (Dart) con widgets Cupertino para diseño iOS nativo
- **Backend**: Supabase (PostgreSQL, Auth, Storage, Edge Functions)
- **Pagos**: Stripe
- **Notificaciones**: Firebase Cloud Messaging
- **State Management**: Riverpod

## Estructura del Proyecto

```
lib/
├── core/                 # Configuración y utilidades core
│   ├── config/          # Supabase, etc.
│   ├── theme/           # Temas y colores
│   └── services/        # Servicios compartidos
├── features/            # Módulos por funcionalidad
│   ├── auth/           # Autenticación
│   ├── events/         # Eventos
│   ├── profile/        # Perfil
│   ├── explore/        # Exploración
│   ├── communities/    # Comunidades
│   ├── friends/        # Amigos
│   └── tickets/        # Tickets y pagos
├── shared/             # Recursos compartidos
│   ├── widgets/        # Widgets reutilizables
│   └── models/         # Modelos de datos
└── routes/             # Configuración de navegación
```

## Patrón de Arquitectura

Se utiliza **MVVM** con **Riverpod** para gestión de estado:

- **Models**: Representan entidades de datos (UserModel, EventModel, etc.)
- **Services**: Lógica de negocio y comunicación con Supabase
- **Providers**: Gestionan estado reactivo con Riverpod
- **Screens**: Widgets de UI que consumen providers

## Flujo de Datos

1. **UI** → Llama a métodos de **Providers**
2. **Providers** → Consumen **Services**
3. **Services** → Interactúan con **Supabase**
4. **Supabase** → Retorna datos
5. **Services** → Transforman a **Models**
6. **Providers** → Notifican cambios a **UI**

## Seguridad

- **Row Level Security (RLS)** en Supabase para control de acceso
- **Edge Functions** para lógica sensible (pagos, validación)
- **JWT** para autenticación de usuarios
- Validación en backend antes de procesar operaciones críticas

## Base de Datos

Ver `supabase/migrations/` para el esquema completo. Principales tablas:

- `profiles` - Perfiles de usuario
- `communities` - Comunidades/organizaciones
- `events` - Eventos
- `tickets` - Tickets individuales
- `orders` - Órdenes de compra
- `friends` - Relaciones de amistad
- `posts` - Feed de actividad

## Edge Functions

- `create-payment-intent` - Crea Payment Intent de Stripe
- `stripe-webhook` - Maneja webhooks de Stripe
- `redeem-ticket` - Valida y marca tickets como usados
- `send-notification` - Envía notificaciones push

