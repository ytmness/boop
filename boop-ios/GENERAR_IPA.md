# 📦 Generar IPA del Proyecto SwiftUI

## Método 1: Desde Xcode (Más Fácil)

### Paso 1: Abrir el Proyecto
```bash
cd /Users/user284318/Documents/boop/boop-ios
open BoopApp.xcodeproj
```

### Paso 2: Configurar para Archive

1. En Xcode, selecciona el scheme **BoopApp** → **Any iOS Device (arm64)**
2. Ve a **Product → Scheme → Edit Scheme**
3. Selecciona **Archive** en el lado izquierdo
4. Build Configuration: **Release**
5. Click **Close**

### Paso 3: Crear Archive

1. **Product → Archive** (o `Cmd + Shift + B`)
2. Espera a que compile (puede tomar 1-2 minutos)
3. Se abrirá el Organizer automáticamente

### Paso 4: Exportar IPA

1. En el Organizer, selecciona el archive recién creado
2. Click en **Distribute App**
3. Selecciona **Custom**
4. Selecciona **Development**
5. Marca **"Export without re-signing"** (si aparece)
6. Click **Next** → **Export**
7. Elige dónde guardar el IPA

---

## Método 2: Desde Terminal (Más Rápido)

Abre tu **Terminal** (no Cursor) y ejecuta:

```bash
cd /Users/user284318/Documents/boop/boop-ios

# Compilar y crear archive
xcodebuild \
    -project BoopApp.xcodeproj \
    -scheme BoopApp \
    -configuration Release \
    -sdk iphoneos \
    -archivePath build/BoopApp.xcarchive \
    archive \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO

# Crear IPA manualmente desde el archive
mkdir -p build/ipa/Payload
cp -r build/BoopApp.xcarchive/Products/Applications/BoopApp.app build/ipa/Payload/
cd build/ipa
zip -r BoopApp.ipa Payload
cd ../..

echo "✅ IPA creado en: build/ipa/BoopApp.ipa"
ls -lh build/ipa/BoopApp.ipa
```

---

## Método 3: Usar el Script

He creado un script que hace todo automáticamente:

```bash
cd /Users/user284318/Documents/boop/boop-ios
./compilar_ipa.sh
```

El IPA se generará en: `build/ipa/BoopApp.ipa`

---

## ⚠️ Nota Importante

Este proyecto Swift es **nuevo** y aún no tiene todas las funcionalidades del proyecto Flutter. El IPA será una app básica con:

- ✅ Pantalla de Login con Liquid Glass
- ✅ Navegación por tabs
- ✅ Efectos visuales impresionantes
- ❌ Sin autenticación real (aún)
- ❌ Sin conexión a Supabase (aún)
- ❌ Sin funcionalidad completa de eventos (aún)

Es más una **demo visual** del efecto Liquid Glass que una app funcional completa.

---

## 🔄 ¿Prefieres usar el IPA de Flutter?

El proyecto Flutter que compilamos antes (`/Users/user284318/Documents/boop/build/ios/ipa/Runner.ipa`) tiene **todas las funcionalidades** completas:

- ✅ Autenticación
- ✅ Eventos
- ✅ Perfil
- ✅ Todo funcional

**Recomendación:** Usa el IPA de Flutter para funcionalidad completa, y el de Swift para ver el efecto Liquid Glass visual.

---

## 📱 Para Instalar con AltStore

Una vez que tengas el IPA:

1. Transfiérelo a Windows (USB, cloud, etc.)
2. Usa AltServer para instalarlo
3. Sigue la guía: `TRANSFERIR_IPA_WINDOWS.md`

---

¿Prefieres que te ayude con algo específico del proyecto?

