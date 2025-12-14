# Configuración de Firma iOS en Codemagic

Este documento explica cómo configurar la firma de código para compilar aplicaciones iOS en Codemagic.

## Opciones de Firma

### Opción 1: Build sin Firma (Actual - para desarrollo/testing)

El workflow actual usa `--no-codesign` que genera un `.app` sin firma. Esto es útil para:
- Testing interno
- Desarrollo
- Verificar que la compilación funciona

**Limitaciones:**
- No se puede instalar en dispositivos físicos
- No se puede subir a TestFlight o App Store
- No genera un `.ipa` válido

### Opción 2: Firma Automática con Certificados (Recomendado para producción)

Para generar un `.ipa` válido que puedas instalar en dispositivos o subir a TestFlight/App Store:

#### Paso 1: Obtener Certificados y Provisioning Profiles

1. **Certificado de Distribución (.p12)**
   - Ve a [Apple Developer Portal](https://developer.apple.com/account)
   - Certificates, Identifiers & Profiles → Certificates
   - Crea un certificado de tipo "Apple Distribution"
   - Descárgalo y conviértelo a `.p12` usando Keychain Access

2. **Provisioning Profile (.mobileprovision)**
   - En Apple Developer Portal → Profiles
   - Crea un perfil de tipo "App Store" o "Ad Hoc"
   - Asócialo con tu App ID: `com.boop.app`
   - Descárgalo

#### Paso 2: Configurar en Codemagic

1. **Subir Certificados a Codemagic**
   - Ve a tu proyecto en Codemagic
   - Settings → Code signing identities
   - Sube tu archivo `.p12` y la contraseña
   - Sube tu archivo `.mobileprovision`

2. **Crear un Grupo de Credenciales**
   - Settings → Code signing identities → Add group
   - Nombra el grupo (ej: `ios_credentials`)
   - Asocia los certificados y provisioning profiles

#### Paso 3: Actualizar codemagic.yaml

Descomenta y configura la sección `ios_signing`:

```yaml
boop-ios:
  name: BOOP iOS Build
  environment:
    ios_signing:
      distribution_type: app_store  # o 'ad_hoc' para distribución interna
      bundle_identifier: com.boop.app
  groups:
    - app_config
    - ios_credentials  # Descomenta esta línea
  scripts:
    - name: Build iOS (con firma)
      script: |
        flutter build ipa --release
        # Esto genera un .ipa firmado en build/ios/ipa/
```

### Opción 3: Firma con App Store Connect API Key (Más Moderno)

1. **Crear API Key en App Store Connect**
   - Ve a [App Store Connect](https://appstoreconnect.apple.com)
   - Users and Access → Keys → App Store Connect API
   - Crea una nueva key con rol "Admin" o "App Manager"
   - Descarga el archivo `.p8`

2. **Configurar en Codemagic**
   - Settings → Code signing identities
   - Sube el archivo `.p8`
   - Copia el Key ID y el Issuer ID

3. **Actualizar codemagic.yaml**

```yaml
boop-ios:
  environment:
    ios_signing:
      distribution_type: app_store
      bundle_identifier: com.boop.app
      app_store_connect_api_key:
        key_id: YOUR_KEY_ID
        issuer_id: YOUR_ISSUER_ID
        key_file: path/to/AuthKey.p8
```

## Configuración Actual del Proyecto

- **Bundle Identifier:** `com.boop.app`
- **iOS Deployment Target:** `14.0`
- **Code Sign Style:** `Automatic` (recomendado)
- **Build actual:** Sin firma (`--no-codesign`)

## Verificación

Para verificar que la configuración es correcta:

```bash
# Verificar bundle identifier
grep PRODUCT_BUNDLE_IDENTIFIER ios/Runner.xcodeproj/project.pbxproj

# Verificar deployment target
grep IPHONEOS_DEPLOYMENT_TARGET ios/Runner.xcodeproj/project.pbxproj
```

## Troubleshooting

### Error: "No Development Team"
- Asegúrate de tener un Development Team configurado en Codemagic
- Verifica que el bundle identifier coincida en todos los lugares

### Error: "Provisioning Profile doesn't match"
- Verifica que el provisioning profile esté asociado al bundle identifier correcto
- Asegúrate de que el certificado y el perfil sean del mismo tipo (Distribution)

### Error: "Code signing is required"
- Si quieres generar un `.ipa`, NO uses `--no-codesign`
- Usa `flutter build ipa --release` en su lugar

## Referencias

- [Codemagic iOS Code Signing](https://docs.codemagic.io/code-signing/ios-code-signing/)
- [Apple Developer Portal](https://developer.apple.com/account)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)

