# 📱 Instrucciones para Generar el IPA (Proyecto Swift BoopApp)

## ✅ Proyecto Listo

He actualizado el proyecto Swift con:

### 🎨 **Design System Completo (Liquid Glass)**
- `GlassComponents.swift`: Componentes reutilizables
  - `GlassCard`: Tarjetas translúcidas con múltiples capas
  - `GlassButton`: Botones con efecto vidrio e interacción
  - `GlassTextField`: Campos de texto con focus animado
  - `GlassAnimatedBackground`: Fondo con orbes animados

### 🏗️ **Arquitectura MVVM**
- `AuthViewModel.swift`: ViewModel para autenticación
- Separación clara Views/ViewModels/Services
- `@StateObject` y `@ObservedObject` para gestión de estado

### 🎯 **Pantallas Actualizadas**
- `LoginView`: Login con validación y efecto vidrio real
- `SplashView`: Splash animado con logo rotando
- `ProfileView`: Con botón logout funcional
- `MainTabView`: Navegación por tabs

### ♿ **Accesibilidad**
- Soporte para Reduce Transparency
- Soporte para Reduce Motion
- Contraste mejorado

---

## 🛠️ OPCIÓN 1: Generar IPA desde Xcode (Recomendado)

### Paso 1: Abrir el Proyecto
```bash
cd /Users/user284318/Documents/boop/boop-ios
open BoopApp.xcodeproj
```

### Paso 2: Seleccionar Destino
En Xcode:
1. Click en "Any iOS Device (arm64)" en la barra superior
2. Selecciona "Any iOS Device (arm64)"

### Paso 3: Crear Archive
```
Product → Archive
```

Espera a que compile (2-5 minutos).

### Paso 4: Exportar IPA
1. Cuando termine, se abrirá el Organizer
2. Click en "Distribute App"
3. Selecciona **"Development"** (o "Ad Hoc")
4. Selecciona **"Export without signing"** o usa tu perfil de desarrollo
5. Click "Export"
6. Guarda el `.ipa` donde quieras

---

## 🛠️ OPCIÓN 2: Desde Terminal (Más rápido)

### Compilar y Crear Archive

```bash
cd /Users/user284318/Documents/boop/boop-ios

# 1. Limpiar build anterior
rm -rf build/

# 2. Crear archive
xcodebuild clean archive \
  -project BoopApp.xcodeproj \
  -scheme BoopApp \
  -destination 'generic/platform=iOS' \
  -archivePath build/BoopApp.xcarchive \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO

# 3. Exportar IPA sin firma
xcodebuild -exportArchive \
  -archivePath build/BoopApp.xcarchive \
  -exportPath build/ \
  -exportOptionsPlist ExportOptions.plist

# El IPA estará en: build/BoopApp.ipa
```

### Crear ExportOptions.plist (si no existe)

```bash
cat > /Users/user284318/Documents/boop/boop-ios/ExportOptions.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>development</string>
    <key>signingStyle</key>
    <string>manual</string>
    <key>compileBitcode</key>
    <false/>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>uploadSymbols</key>
    <false/>
    <key>uploadBitcode</key>
    <false/>
</dict>
</plist>
EOF
```

---

## 🚨 Errores Comunes y Soluciones

### Error: "No such scheme 'BoopApp'"
**Solución:** Verifica que el scheme esté compartido:
```bash
ls -la BoopApp.xcodeproj/xcshareddata/xcschemes/
```
Si no existe, ábrelo en Xcode y ve a `Product → Scheme → Manage Schemes` → marca "Shared"

### Error: "Code signing is required"
**Solución:** Añade los flags de no firma:
```bash
CODE_SIGN_IDENTITY="" \
CODE_SIGNING_REQUIRED=NO \
CODE_SIGNING_ALLOWED=NO
```

### Error: Build failed
**Solución:** Compila primero en Xcode para ver errores específicos:
1. Abre Xcode
2. `Product → Clean Build Folder` (⇧⌘K)
3. `Product → Build` (⌘B)
4. Revisa errores en el panel de issues

---

## 📦 Verificar el IPA

```bash
# Ver contenido del IPA
unzip -l build/BoopApp.ipa

# Extraer y verificar
unzip build/BoopApp.ipa -d build/ipa_contents/
ls -lh build/ipa_contents/Payload/BoopApp.app/
```

---

## 🎉 ¡IPA Generado!

El archivo `BoopApp.ipa` estará en:
```
/Users/user284318/Documents/boop/boop-ios/build/BoopApp.ipa
```

### Para instalar con AltStore:
1. Transfiere el IPA a tu Windows (USB, email, cloud)
2. Instala AltServer en Windows
3. Instala AltStore en tu iPhone
4. En AltStore, click "+" y selecciona el IPA

---

## 🔍 Estructura del Proyecto

```
BoopApp/
├── BoopApp/
│   ├── BoopAppApp.swift          # Entry point
│   ├── ContentView.swift         # Root view con auth state
│   ├── Features/
│   │   └── Auth/
│   │       └── ViewModels/
│   │           └── AuthViewModel.swift
│   ├── Views/
│   │   ├── Auth/
│   │   │   ├── LoginView.swift
│   │   │   └── SplashView.swift
│   │   ├── Events/
│   │   │   └── EventsHubView.swift
│   │   ├── Profile/
│   │   │   └── ProfileView.swift
│   │   ├── ExploreView.swift
│   │   └── MainTabView.swift
│   ├── Components/
│   │   └── Glass/
│   │       ├── GlassCard.swift
│   │       ├── GlassButton.swift
│   │       └── GlassBackground.swift
│   ├── DesignSystem/
│   │   └── GlassComponents.swift    # ⭐ NUEVO Design System completo
│   └── Utils/
│       └── GlassEffectExtensions.swift
```

---

## 📚 Próximos Pasos

1. ✅ Generar IPA
2. ⚡ Integrar con Supabase (Auth, Database)
3. 🗺️ Añadir Google Maps
4. 📷 Implementar QR Scanner
5. 💳 Integrar pagos (Stripe/Apple Pay)
6. 🔔 Push Notifications

---

**¿Necesitas ayuda?** 
- Revisa los logs de compilación
- Verifica que todos los archivos estén en Xcode
- Asegúrate de tener Xcode 15+

