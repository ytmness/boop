# Guía para Ejecutar la App BOOP

## Opción 1: Instalar Flutter (Recomendado)

### Windows:

1. **Descargar Flutter SDK:**
   - Ve a https://docs.flutter.dev/get-started/install/windows
   - Descarga el SDK de Flutter
   - Extrae el archivo ZIP a una ubicación (ej: `C:\src\flutter`)

2. **Agregar Flutter al PATH:**
   - Busca "Variables de entorno" en Windows
   - Agrega `C:\src\flutter\bin` al PATH del sistema
   - Reinicia PowerShell/Terminal

3. **Verificar instalación:**
   ```powershell
   flutter doctor
   ```

4. **Instalar dependencias:**
   ```powershell
   cd C:\Users\PC\Desktop\BOOP
   flutter pub get
   ```

5. **Ejecutar la app:**
   ```powershell
   # Para ver dispositivos disponibles
   flutter devices
   
   # Para ejecutar en Chrome (web)
   flutter run -d chrome
   
   # O en un emulador Android/iOS si tienes uno configurado
   flutter run
   ```

## Opción 2: Usar Flutter Web (Más rápido)

Si solo quieres ver las pantallas sin instalar todo:

1. **Instalar solo Flutter (sin Android Studio):**
   - Descarga Flutter SDK
   - Agrega al PATH
   - Ejecuta: `flutter config --enable-web`

2. **Ejecutar en navegador:**
   ```powershell
   flutter run -d chrome
   ```

## Opción 3: Usar VS Code con Extensión Flutter

1. Instala VS Code
2. Instala la extensión "Flutter"
3. Abre la carpeta del proyecto
4. Presiona F5 o usa el botón "Run"

## Nota sobre Supabase

La app está configurada para funcionar en **modo demo** sin credenciales de Supabase. Las pantallas se mostrarán pero las funcionalidades que requieren backend no funcionarán hasta que configures Supabase.

Para configurar Supabase:
1. Crea un proyecto en https://supabase.com
2. Edita `lib/core/config/supabase_config.dart` con tus credenciales
   O usa variables de entorno:
   ```powershell
   $env:SUPABASE_URL="tu_url"
   $env:SUPABASE_ANON_KEY="tu_key"
   flutter run -d chrome
   ```

## Problemas Comunes

- **"flutter no se reconoce"**: Flutter no está en el PATH
- **"No devices found"**: Ejecuta `flutter run -d chrome` para web
- **Errores de dependencias**: Ejecuta `flutter pub get`

