# 📱 Generar IPA para AltServer

## ⚠️ Requisitos
- **macOS** con Xcode instalado (necesario para compilar)
- El proyecto debe estar en macOS o transferido desde Windows

## 🚀 Método Rápido: Script Automático

### En macOS (Terminal):

```bash
cd /ruta/a/boop-main/boop-ios
chmod +x generar_ipa.sh
./generar_ipa.sh
```

El IPA se generará en: `build/ipa/BoopApp.ipa`

---

## 📋 Método Manual: Desde Xcode

### Paso 1: Abrir el Proyecto
```bash
cd /ruta/a/boop-main/boop-ios
open BoopApp.xcodeproj
```

### Paso 2: Configurar Scheme
1. En Xcode, selecciona el scheme **BoopApp**
2. Selecciona **"Any iOS Device (arm64)"** como destino
3. Ve a **Product → Scheme → Edit Scheme**
4. Selecciona **Archive** en el lado izquierdo
5. Build Configuration: **Release**
6. Click **Close**

### Paso 3: Crear Archive
1. **Product → Archive** (o `Cmd + Shift + B`)
2. Espera a que compile (2-5 minutos)

### Paso 4: Exportar IPA
1. Se abrirá el Organizer automáticamente
2. Selecciona el archive recién creado
3. Click en **"Distribute App"**
4. Selecciona **"Development"**
5. Si aparece, marca **"Export without re-signing"**
6. Click **Next** → **Export**
7. Elige dónde guardar el IPA

---

## 🛠️ Método Terminal (Sin Xcode UI)

```bash
cd /ruta/a/boop-main/boop-ios

# Limpiar builds anteriores
rm -rf build/

# Crear archive
xcodebuild clean archive \
    -project BoopApp.xcodeproj \
    -scheme BoopApp \
    -configuration Release \
    -destination 'generic/platform=iOS' \
    -archivePath build/BoopApp.xcarchive \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO

# Crear estructura del IPA
mkdir -p build/ipa/Payload
cp -r build/BoopApp.xcarchive/Products/Applications/BoopApp.app build/ipa/Payload/

# Comprimir IPA
cd build/ipa
zip -r BoopApp.ipa Payload
cd ../..

echo "✅ IPA creado en: build/ipa/BoopApp.ipa"
```

---

## 📱 Instalar con AltServer

1. **Transferir el IPA a Windows:**
   - USB, email, cloud storage, etc.
   - El archivo estará en: `build/ipa/BoopApp.ipa`

2. **En Windows:**
   - Abre AltServer
   - Conecta tu iPhone
   - En AltStore (en tu iPhone), presiona **"+"**
   - Selecciona el archivo `BoopApp.ipa`

---

## ⚠️ Notas Importantes

- **Firma de código:** El IPA generado NO está firmado. AltServer lo firmará automáticamente cuando lo instales.
- **Certificado:** Necesitas tener un certificado de desarrollo válido en AltServer.
- **Límite de apps:** AltServer tiene un límite de 3 apps simultáneas (con cuenta gratuita).

---

## 🔍 Verificar el IPA

```bash
# Ver contenido
unzip -l build/ipa/BoopApp.ipa

# Ver tamaño
ls -lh build/ipa/BoopApp.ipa
```

---

## ❌ Solución de Problemas

### Error: "No such scheme 'BoopApp'"
```bash
# Verificar que el scheme existe
ls -la BoopApp.xcodeproj/xcshareddata/xcschemes/
```

### Error: "Code signing is required"
- Asegúrate de usar los flags: `CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO`

### Error: Build failed
- Abre Xcode y compila primero para ver errores específicos
- Verifica que todas las dependencias estén instaladas

---

¿Necesitas ayuda? Revisa los logs de compilación o abre el proyecto en Xcode para ver errores específicos.

