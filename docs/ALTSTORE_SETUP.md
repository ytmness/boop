# Instalación con AltStore (IPA sin Firma)

Esta guía explica cómo generar e instalar un `.ipa` sin firmar usando AltStore.

## ¿Qué es AltStore?

AltStore es una alternativa al App Store que te permite instalar aplicaciones en tu iPhone/iPad usando tu Apple ID personal. No requiere una cuenta de desarrollador de pago ($99/año).

## Requisitos

- iPhone/iPad con iOS 14.0 o superior
- Apple ID gratuito
- AltStore instalado en tu dispositivo
- AltServer instalado en tu Mac/PC

## Generación del IPA sin Firma

### En Codemagic (Automático)

El workflow `boop-ios` en `codemagic.yaml` está configurado para generar un `.ipa` sin firma:

```yaml
- name: Build iOS IPA (sin firma para AltStore)
  script: |
    flutter build ipa --release --no-codesign
```

El archivo se genera en: `build/ios/ipa/Runner.ipa`

### Localmente (Manual)

Si quieres compilar localmente:

```bash
# Limpiar build anterior
flutter clean

# Obtener dependencias
flutter pub get

# Instalar CocoaPods
cd ios
pod install
cd ..

# Generar IPA sin firma
flutter build ipa --release --no-codesign
```

El `.ipa` se generará en: `build/ios/ipa/Runner.ipa`

## Instalación con AltStore

### Paso 1: Instalar AltStore

1. Descarga AltServer desde [altstore.io](https://altstore.io)
2. Instala AltServer en tu Mac/PC
3. Abre AltServer y asegúrate de que esté corriendo
4. Conecta tu iPhone/iPad a la misma red WiFi que tu computadora
5. Abre Safari en tu iPhone y ve a `http://[IP-de-tu-PC]:12345`
6. Descarga e instala AltStore

### Paso 2: Instalar el IPA

1. **Opción A: Desde Codemagic**
   - Descarga el `.ipa` desde los artifacts de Codemagic
   - Compártelo a tu iPhone (AirDrop, email, etc.)
   - Abre el archivo con AltStore
   - AltStore firmará e instalará la app automáticamente

2. **Opción B: Desde tu computadora**
   - Conecta tu iPhone a tu Mac/PC
   - Abre AltServer
   - Arrastra el archivo `Runner.ipa` a AltServer
   - AltStore en tu iPhone firmará e instalará la app

### Paso 3: Verificar Instalación

- La app aparecerá en tu pantalla de inicio
- La primera vez que la abras, ve a Configuración → General → Gestión de Dispositivos
- Confía en tu certificado de desarrollador (tu Apple ID)

## Renovación de Certificados

Los certificados de AltStore expiran cada 7 días. Para renovarlos:

1. Abre AltStore en tu iPhone
2. Ve a "My Apps"
3. Toca el botón de refrescar en la esquina superior derecha
4. Esto renovará todos los certificados automáticamente

**Nota:** Tu iPhone y tu computadora deben estar en la misma red WiFi para renovar.

## Limitaciones

- **Expiración:** Los certificados expiran cada 7 días y deben renovarse
- **Límite de apps:** Puedes tener hasta 3 apps activas a la vez (incluyendo AltStore)
- **WiFi requerido:** Necesitas estar en la misma red WiFi que AltServer para renovar

## Troubleshooting

### Error: "Could not find AltServer"
- Asegúrate de que AltServer esté corriendo en tu computadora
- Verifica que ambos dispositivos estén en la misma red WiFi
- Intenta reiniciar AltServer

### Error: "App limit reached"
- Desinstala alguna app de AltStore
- O espera a que expire una app (7 días)

### Error: "Certificate expired"
- Abre AltStore y toca el botón de refrescar
- Asegúrate de estar en la misma red WiFi que AltServer

### El IPA no se instala
- Verifica que el archivo sea un `.ipa` válido
- Asegúrate de que AltStore esté actualizado
- Intenta regenerar el IPA con `flutter clean` primero

## Ventajas vs Cuenta de Desarrollador

| Característica | AltStore | Apple Developer ($99/año) |
|----------------|----------|---------------------------|
| Costo | Gratis | $99/año |
| Expiración | 7 días | 1 año |
| Límite de apps | 3 activas | Ilimitado |
| TestFlight | No | Sí |
| App Store | No | Sí |
| Distribución | Solo tú | Público |

## Referencias

- [AltStore Website](https://altstore.io)
- [AltStore FAQ](https://altstore.io/faq/)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)

