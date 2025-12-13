# Transferir IPA a Windows e Instalar con AltStore

## Paso 1: Transferir el IPA desde macOS a Windows

Tienes varias opciones para transferir el archivo `Runner.ipa`:

### Opción A: Usar un servicio en la nube (Más fácil)
1. Sube el archivo a Google Drive, Dropbox, OneDrive, etc.
2. Descárgalo en tu PC con Windows
3. Guarda el archivo en una ubicación fácil de encontrar (ej: Escritorio)

### Opción B: Usar AirDrop (si tienes ambos dispositivos cerca)
1. En macOS, abre Finder
2. Encuentra el archivo: `/Users/user284318/Documents/boop/build/ios/ipa/Runner.ipa`
3. Haz clic derecho → Compartir → AirDrop
4. Selecciona tu iPhone/iPad
5. Luego transfiere desde el iPhone a Windows vía email/cloud

### Opción C: Usar USB/Disco externo
1. Copia el archivo a un USB o disco externo
2. Conéctalo a tu PC con Windows
3. Copia el archivo al escritorio

### Opción D: Usar red local (SMB/FTP)
1. En macOS, comparte la carpeta
2. Desde Windows, accede a la carpeta compartida
3. Copia el archivo

## Paso 2: Instalar AltServer en Windows

1. Ve a [altstore.io](https://altstore.io)
2. Descarga **AltServer para Windows**
3. Instala AltServer
4. Abre AltServer (debería aparecer en la bandeja del sistema)

## Paso 3: Instalar AltStore en tu iPhone/iPad

1. **Conecta tu iPhone/iPad a tu PC con Windows** usando un cable USB
2. Abre **iTunes** (o **Apple Devices** en Windows 11)
3. Asegúrate de que tu dispositivo esté confiado y conectado
4. En AltServer (bandeja del sistema), haz clic derecho
5. Selecciona **"Install AltStore"** → Elige tu dispositivo
6. Ingresa tu **Apple ID** y contraseña
7. AltStore se instalará en tu iPhone/iPad

## Paso 4: Instalar el IPA con AltStore

### Método 1: Desde AltServer (Recomendado)

1. Asegúrate de que tu iPhone esté conectado a Windows vía USB
2. Abre **AltServer** en Windows
3. Haz clic derecho en el icono de AltServer (bandeja del sistema)
4. Selecciona **"Install .ipa"**
5. Navega y selecciona el archivo `Runner.ipa`
6. Elige tu dispositivo
7. AltStore instalará la app automáticamente

### Método 2: Desde el iPhone (Alternativo)

1. Transfiere el archivo `Runner.ipa` a tu iPhone:
   - Envíatelo por email
   - Úsalo desde Files app si lo subiste a iCloud
   - O compártelo vía AirDrop desde otro dispositivo
2. Abre **AltStore** en tu iPhone
3. Ve a la pestaña **"My Apps"**
4. Toca el botón **"+"** en la esquina superior izquierda
5. Selecciona el archivo `Runner.ipa`
6. AltStore firmará e instalará la app

## Paso 5: Confiar en el Certificado

1. En tu iPhone, ve a **Configuración** → **General** → **Gestión de Dispositivos** (o **VPN y Gestión de Dispositivos**)
2. Toca tu Apple ID
3. Toca **"Confiar en [tu Apple ID]"**
4. Confirma

## Paso 6: Abrir la App

1. Busca el icono de **BOOP** en tu pantalla de inicio
2. Toca para abrir
3. ¡Listo! La app debería funcionar

## Renovación de Certificados (Cada 7 días)

Los certificados de AltStore expiran cada 7 días. Para renovarlos:

1. Asegúrate de que tu iPhone y PC estén en la **misma red WiFi**
2. Abre **AltStore** en tu iPhone
3. Ve a **"My Apps"**
4. Toca el botón de **refrescar** (↻) en la esquina superior derecha
5. Esto renovará todos los certificados automáticamente

**Nota:** También puedes renovar conectando el iPhone vía USB a Windows y usando AltServer.

## Troubleshooting

### "Could not find AltServer"
- Asegúrate de que AltServer esté corriendo en Windows
- Verifica que ambos dispositivos estén en la misma red WiFi (para renovación)
- O conecta el iPhone vía USB

### "App limit reached"
- AltStore permite máximo 3 apps activas (incluyendo AltStore)
- Desinstala alguna app de AltStore
- O espera a que expire una app (7 días)

### "Certificate expired"
- Abre AltStore y toca el botón de refrescar
- Asegúrate de estar en la misma red WiFi que tu PC
- O conecta vía USB y renueva desde AltServer

### El IPA no se instala
- Verifica que el archivo sea un `.ipa` válido
- Asegúrate de que AltStore esté actualizado
- Intenta reiniciar AltServer

## Ubicación del Archivo IPA

El archivo está en:
```
/Users/user284318/Documents/boop/build/ios/ipa/Runner.ipa
```

Tamaño: ~19 MB


