# Configuración de Codemagic para BOOP

Esta guía te ayudará a configurar Codemagic CI/CD para buildear automáticamente tu aplicación Flutter BOOP.

## Requisitos Previos

1. Cuenta en [Codemagic](https://codemagic.io)
2. Repositorio en GitHub (ya configurado)
3. Credenciales de firma (para Android/iOS si planeas publicar)

## Pasos de Configuración

### 1. Conectar tu Repositorio

1. Ve a [Codemagic](https://codemagic.io) e inicia sesión
2. Haz clic en "Add application"
3. Selecciona tu repositorio `ytmness/boop` desde GitHub
4. Codemagic detectará automáticamente el archivo `codemagic.yaml`

### 2. Configurar Variables de Entorno (Opcional)

Si tu aplicación necesita variables de entorno (como credenciales de Supabase), puedes configurarlas en Codemagic:

1. Ve a tu aplicación en Codemagic
2. Ve a "Environment variables"
3. Agrega las variables necesarias:
   - `SUPABASE_URL` (si es necesario)
   - `SUPABASE_ANON_KEY` (si es necesario)
   - Cualquier otra variable que tu app necesite

### 3. Configurar Credenciales de Firma (Solo para Android/iOS)

#### Android

Si quieres buildear APK/AAB firmados:

1. Genera un keystore:
   ```bash
   keytool -genkey -v -keystore ~/boop-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias boop
   ```

2. En Codemagic:
   - Ve a "Code signing identities"
   - Sube tu archivo `.jks`
   - Configura el alias y contraseña como variables de entorno

#### iOS

Si quieres buildear para iOS:

1. Necesitas un certificado de distribución de Apple Developer
2. En Codemagic:
   - Ve a "Code signing identities"
   - Sube tu certificado `.p12` y perfil de aprovisionamiento
   - O conecta tu cuenta de Apple Developer directamente

### 4. Configurar Grupos de Variables

En el archivo `codemagic.yaml` hay referencias a grupos de variables. Configúralos en Codemagic:

1. Ve a "Environment variables"
2. Crea los grupos:
   - `app_config`: Variables generales de la app
   - `android_credentials`: Credenciales de Android (solo si builds Android)
   - `ios_credentials`: Credenciales de iOS (solo si builds iOS)

### 5. Actualizar Email de Notificaciones

Edita el archivo `codemagic.yaml` y reemplaza `user@example.com` con tu email real en la sección `publishing.email.recipients`.

### 6. Ejecutar el Primer Build

1. En Codemagic, selecciona el workflow que quieres ejecutar:
   - `boop-web`: Para builds de web
   - `boop-android`: Para builds de Android
   - `boop-ios`: Para builds de iOS

2. Haz clic en "Start new build"
3. El build comenzará automáticamente

## Workflows Disponibles

### boop-web
- **Plataforma**: Web
- **Artefactos**: Carpeta `build/web/` completa
- **Uso**: Despliegue en hosting web (Firebase Hosting, Netlify, Vercel, etc.)

### boop-android
- **Plataforma**: Android
- **Artefactos**: 
  - APK (`build/app/outputs/flutter-apk/*.apk`)
  - App Bundle (`build/app/outputs/bundle/*.aab`)
- **Uso**: Publicación en Google Play Store

### boop-ios
- **Plataforma**: iOS
- **Artefactos**: IPA (`build/ios/ipa/*.ipa`)
- **Uso**: Publicación en App Store

## Personalización

### Modificar el Archivo codemagic.yaml

Puedes editar `codemagic.yaml` para:

- Cambiar la versión de Flutter: `flutter: stable` o `flutter: "3.x.x"`
- Agregar scripts personalizados antes/durante el build
- Configurar diferentes artefactos
- Cambiar las notificaciones de email
- Agregar pasos de despliegue automático

### Ejemplo: Agregar Despliegue Automático a Firebase Hosting

```yaml
scripts:
  - name: Build web
    script: |
      flutter build web --release
  - name: Deploy to Firebase
    script: |
      firebase deploy --only hosting
```

## Troubleshooting

### Error: "No se encontró el archivo codemagic.yaml"
- Asegúrate de que el archivo esté en la raíz del repositorio
- Verifica que esté commitado y pusheado a GitHub

### Error: "Flutter version not found"
- Verifica que la versión de Flutter especificada esté disponible en Codemagic
- Usa `flutter: stable` para la última versión estable

### Error: "Tests failed"
- Revisa los logs del build en Codemagic
- Ejecuta los tests localmente primero: `flutter test`

### Build de Web falla
- Verifica que todas las dependencias sean compatibles con web
- Algunos paquetes pueden no soportar web (como `mobile_scanner`)

## Recursos

- [Documentación de Codemagic](https://docs.codemagic.io/)
- [Guía de Flutter en Codemagic](https://docs.codemagic.io/yaml-quick-start/building-a-flutter-app/)
- [Configuración de Android](https://docs.codemagic.io/code-signing/android-code-signing/)
- [Configuración de iOS](https://docs.codemagic.io/code-signing/ios-code-signing/)

