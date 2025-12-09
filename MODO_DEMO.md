# Modo Demo - BOOP

## ¿Qué es el Modo Demo?

El modo demo permite explorar la interfaz de la aplicación BOOP sin necesidad de configurar Supabase. Puedes iniciar sesión con cualquier teléfono o email y cualquier código OTP será aceptado.

## Cómo usar el Modo Demo

### 1. Iniciar Sesión

1. **Con Teléfono:**
   - Ve a la pantalla de inicio de sesión
   - Ingresa cualquier número de teléfono (ej: `+1234567890`)
   - Presiona "Enviar código"
   - Ingresa cualquier código de 6 dígitos (ej: `123456`)
   - Presiona "Verificar"

2. **Con Email:**
   - Ve a la pantalla de inicio de sesión con email
   - Ingresa cualquier email (ej: `demo@boop.com`)
   - Presiona "Enviar código"
   - Ingresa cualquier código de 6 dígitos (ej: `123456`)
   - Presiona "Verificar"

### 2. Navegar por la App

Una vez iniciada la sesión, podrás:
- ✅ Explorar eventos
- ✅ Ver tu perfil
- ✅ Navegar por todas las pantallas
- ✅ Ver la interfaz completa

### 3. Datos Mock

En modo demo:
- El usuario se crea automáticamente con datos de ejemplo
- No se guarda nada en la base de datos
- Los datos se pierden al cerrar la app
- Todas las operaciones son simuladas

## Configurar Supabase (Para Producción)

Cuando quieras usar la app con datos reales:

1. Crea una cuenta en [Supabase](https://supabase.com)
2. Crea un nuevo proyecto
3. Obtén tu URL y Anon Key
4. Edita `lib/core/config/supabase_config.dart` y reemplaza:
   ```dart
   const supabaseUrl = 'TU_URL_AQUI';
   const supabaseAnonKey = 'TU_ANON_KEY_AQUI';
   ```
5. Ejecuta las migraciones SQL en `supabase/migrations/`
6. Reinicia la app

## Notas

- El modo demo está activo automáticamente cuando Supabase no está configurado
- No necesitas hacer nada especial para activarlo
- Todos los códigos OTP son aceptados en modo demo
- Los datos son temporales y solo existen en memoria

