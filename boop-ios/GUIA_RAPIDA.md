# 🚀 Guía Rápida: Ejecutar el Proyecto SwiftUI

## Paso 1: Abrir Xcode

Abre **Xcode** desde tu Mac.

## Paso 2: Crear Nuevo Proyecto

1. **File** → **New** → **Project** (o presiona `Cmd + Shift + N`)

2. Selecciona:
   - Plataforma: **iOS**
   - Template: **App**
   - Click **Next**

## Paso 3: Configurar el Proyecto

Ingresa los siguientes datos:

```
Product Name:              BoopApp
Team:                      (tu cuenta de desarrollador)
Organization Identifier:   com.boop
Bundle Identifier:         com.boop.app
Interface:                 SwiftUI ✓
Language:                  Swift
Storage:                   None
Include Tests:             ☐ (opcional)
```

Click **Next**

## Paso 4: Guardar en la Ubicación Correcta

**IMPORTANTE**: Guarda el proyecto en:
```
/Users/user284318/Documents/boop/boop-ios/
```

Click **Create**

## Paso 5: Agregar los Archivos Swift

Una vez creado el proyecto:

1. En el **Finder**, ve a:
   ```
   /Users/user284318/Documents/boop/boop-ios/BoopApp/BoopApp/
   ```

2. Selecciona **TODOS** los archivos y carpetas:
   - BoopAppApp.swift
   - ContentView.swift
   - Views/ (carpeta completa)
   - Components/ (carpeta completa)
   - Utils/ (carpeta completa)
   - Info.plist

3. **Arrastra** todos estos archivos al proyecto en Xcode (en el navegador de la izquierda)

4. Cuando te pregunte:
   - ✓ **Copy items if needed**
   - ✓ **Create groups**
   - ✓ Add to targets: BoopApp
   - Click **Finish**

## Paso 6: Eliminar Archivos Duplicados

Xcode habrá creado algunos archivos automáticamente. **Elimina** (click derecho → Delete → Move to Trash):
- El `ContentView.swift` generado automáticamente (si es diferente al tuyo)
- `BoopAppApp.swift` generado (si es diferente)

**Mantén solo tus archivos.**

## Paso 7: Configurar el Target

1. Click en el proyecto **BoopApp** en el navegador
2. Selecciona el target **BoopApp**
3. En la pestaña **General**:
   - Minimum Deployments: **iOS 17.0** (o superior)
   - Display Name: **BOOP**
4. En **Signing & Capabilities**:
   - Selecciona tu **Team**

## Paso 8: Compilar y Ejecutar

1. Selecciona un **simulador** en la parte superior (ej: iPhone 15 Pro)
2. Presiona **Cmd + R** o click en el botón **▶️ Run**

## ¡Listo! 🎉

La app debería compilar y ejecutarse mostrando:
- Pantalla de Login con efecto Glass translúcido
- Gradiente oscuro de fondo
- Campos de texto con material translúcido
- Botones con efecto glass

## Solución de Problemas

### Error: "No such module 'SwiftUI'"
- Asegúrate de que el Deployment Target sea iOS 17.0+

### Error: "Cannot find type in scope"
- Verifica que todos los archivos estén agregados al target
- Build Settings → Swift Compiler → Build Active Architecture Only: No

### La app no muestra el efecto glass
- Es normal, el efecto completo requiere iOS 26
- Por ahora usa `.ultraThinMaterial` como fallback

### Archivos no encontrados
- Asegúrate de haber copiado TODAS las carpetas (Views, Components, Utils)
- Verifica que Info.plist esté en el proyecto

## Siguiente Paso: Integrar Supabase

Una vez que la app funcione, puedes:
1. Agregar Supabase Swift SDK
2. Implementar autenticación real
3. Conectar con tu base de datos

¿Preguntas? Revisa `README.md` o `MIGRACION.md`

