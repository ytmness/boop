# 🔧 Solucionar Errores de Build

## Errores Comunes y Soluciones

### 1. "No such module 'SwiftUI'"

**Solución:**
- En Xcode, selecciona el proyecto **BoopApp** en el navegador
- Ve a **Target → BoopApp → General**
- Cambia **Minimum Deployments** a **iOS 17.0** (o superior)
- Presiona **Cmd + Shift + K** para limpiar
- Presiona **Cmd + B** para compilar de nuevo

### 2. "Cannot find type 'GlassEffectStyle' in scope"

**Solución:**
Este es esperado. El código usa tipos placeholder. Reemplaza temporalmente:

En `GlassEffectExtensions.swift`, asegúrate de que esté así:

```swift
// Tipos placeholder para compatibilidad
typealias GlassEffectStyle = String
```

### 3. "Missing required module 'SwiftUI'"

**Solución:**
- Asegúrate de que todos los archivos estén agregados al target
- Click en cada archivo Swift
- En el panel derecho, marca el checkbox **BoopApp** en "Target Membership"

### 4. Archivos no encontrados

**Solución:**
Verifica que todos los archivos estén en la ubicación correcta:

```
BoopApp/
└── BoopApp/
    ├── BoopAppApp.swift
    ├── ContentView.swift
    ├── Info.plist
    ├── Views/
    │   ├── Auth/
    │   │   └── LoginView.swift
    │   ├── Events/
    │   │   └── EventsHubView.swift
    │   ├── Profile/
    │   │   └── ProfileView.swift
    │   ├── ExploreView.swift
    │   └── MainTabView.swift
    ├── Components/
    │   └── Glass/
    │       ├── GlassCard.swift
    │       ├── GlassButton.swift
    │       └── GlassBackground.swift
    └── Utils/
        └── GlassEffectExtensions.swift
```

### 5. "Code signing required"

**Solución:**
- Ve a **Target → Signing & Capabilities**
- Selecciona tu **Team** (Apple ID)
- O marca **"Automatically manage signing"**

### 6. Build exitoso pero app no se ejecuta

**Solución:**
- Verifica que tengas un simulador iOS 17+ instalado
- Xcode → Settings → Platforms
- Descarga iOS 17+ si es necesario

---

## 🔄 Proceso de Limpieza Completo

Si sigues teniendo problemas:

1. **Limpiar Build Folder**
   - Product → Clean Build Folder (Cmd + Shift + K)

2. **Borrar Derived Data**
   - Xcode → Settings → Locations
   - Click en la flecha junto a Derived Data
   - Borra la carpeta BoopApp

3. **Reiniciar Xcode**
   - Cierra Xcode completamente
   - Vuelve a abrirlo

4. **Compilar de nuevo**
   - Cmd + B

---

## 📝 Si el Error Persiste

**Comparte el error específico:**
Copia el mensaje de error completo de Xcode y compártelo. El error estará en:
- Panel de Issues (triángulo amarillo/rojo en la barra superior)
- O en el panel de Report Navigator (último ícono en el navegador)

**Errores típicos que puedo ayudar a resolver:**
- Módulos no encontrados
- Tipos no definidos
- Archivos faltantes
- Problemas de firma de código
- Configuración del proyecto

---

## ✅ Verificación Rápida

Antes de compilar, verifica:
- [ ] Deployment Target = iOS 17.0+
- [ ] Todos los .swift files tienen el checkbox BoopApp marcado
- [ ] Info.plist está en el proyecto
- [ ] Swift Version = 5.0
- [ ] Simulador seleccionado es iOS 17+

---

¿Qué error específico te apareció? Compártelo y lo soluciono de inmediato.

