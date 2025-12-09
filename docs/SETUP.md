# Guía de Configuración de BOOP

## Requisitos Previos

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Cuenta de Supabase
- Cuenta de Stripe
- Firebase project (para notificaciones push)

## Pasos de Configuración

### 1. Configurar Supabase

1. Crea un proyecto en [Supabase](https://supabase.com)
2. Ejecuta las migraciones SQL en orden:
   ```bash
   # En el SQL Editor de Supabase Dashboard
   # Ejecuta los archivos en orden:
   # - supabase/migrations/001_initial_schema.sql
   # - supabase/migrations/002_rls_policies.sql
   # - supabase/migrations/003_storage_buckets.sql
   # - supabase/migrations/004_functions.sql
   ```

3. Configura los buckets de Storage según `docs/STORAGE_SETUP.md`

4. Configura las Edge Functions:
   ```bash
   # Instala Supabase CLI
   npm install -g supabase
   
   # Login
   supabase login
   
   # Link tu proyecto
   supabase link --project-ref tu-project-ref
   
   # Despliega las funciones
   supabase functions deploy create-payment-intent
   supabase functions deploy stripe-webhook
   supabase functions deploy redeem-ticket
   supabase functions deploy send-notification
   ```

5. Configura los secretos de las Edge Functions:
   ```bash
   supabase secrets set STRIPE_SECRET_KEY=sk_test_...
   supabase secrets set STRIPE_WEBHOOK_SECRET=whsec_...
   ```

### 2. Configurar Stripe

1. Crea una cuenta en [Stripe](https://stripe.com)
2. Obtén tus API keys (test y producción)
3. Configura webhooks en Stripe Dashboard:
   - URL: `https://tu-proyecto.supabase.co/functions/v1/stripe-webhook`
   - Eventos: `payment_intent.succeeded`, `payment_intent.payment_failed`

### 3. Configurar Firebase

1. Crea un proyecto en [Firebase Console](https://console.firebase.google.com)
2. Agrega apps iOS y Android
3. Descarga `GoogleService-Info.plist` (iOS) y `google-services.json` (Android)
4. Colócalos en las carpetas correspondientes del proyecto Flutter

### 4. Configurar la App Flutter

1. Clona el repositorio
2. Instala dependencias:
   ```bash
   flutter pub get
   ```

3. Configura las variables de entorno en `lib/core/config/supabase_config.dart`:
   ```dart
   const supabaseUrl = 'TU_SUPABASE_URL';
   const supabaseAnonKey = 'TU_SUPABASE_ANON_KEY';
   ```

4. Ejecuta la app:
   ```bash
   flutter run
   ```

## Variables de Entorno Necesarias

- `SUPABASE_URL` - URL de tu proyecto Supabase
- `SUPABASE_ANON_KEY` - Anon key de Supabase
- `STRIPE_SECRET_KEY` - Secret key de Stripe (en Edge Functions)
- `STRIPE_WEBHOOK_SECRET` - Webhook secret de Stripe (en Edge Functions)

## Próximos Pasos

- Configurar autenticación de Apple en Supabase Dashboard
- Configurar proveedor SMS (Twilio) para OTP
- Personalizar colores y branding
- Configurar dominios y deep links

