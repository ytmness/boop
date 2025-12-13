# Setup del Proyecto SwiftUI

## Crear el Proyecto Xcode

Para crear el proyecto Xcode desde los archivos Swift que ya están creados:

### Opción 1: Crear desde Xcode (Recomendado)

1. Abre **Xcode 26.1+**
2. File → New → Project
3. Selecciona **iOS** → **App**
4. Configura:
   - **Product Name**: `BoopApp`
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Minimum Deployment**: iOS 26.0
   - **Bundle Identifier**: `com.boop.app`
5. Guarda el proyecto en: `/Users/user284318/Documents/boop/boop-ios/`
6. **Reemplaza** los archivos generados con los que ya están en `BoopApp/BoopApp/`

### Opción 2: Usar el script de creación

Ejecuta:

```bash
cd /Users/user284318/Documents/boop/boop-ios
./create_xcode_project.sh
```

## Estructura de Archivos

Los archivos ya están organizados en:

```
BoopApp/
├── BoopApp/
│   ├── BoopAppApp.swift
│   ├── ContentView.swift
│   ├── Views/
│   ├── Components/
│   └── Utils/
```

## Configuración del Proyecto

1. **Deployment Target**: iOS 26.0 (para Liquid Glass completo)
2. **Swift Version**: 6.0
3. **Build Settings**:
   - `SWIFT_VERSION = 6.0`
   - `IPHONEOS_DEPLOYMENT_TARGET = 26.0`

## Compilar y Ejecutar

1. Abre `BoopApp.xcodeproj` en Xcode
2. Selecciona un simulador iOS 26+ o dispositivo físico
3. Presiona `Cmd + R` para compilar y ejecutar

## Notas

- Si usas iOS < 26, el código usará `.ultraThinMaterial` como fallback
- Asegúrate de tener Xcode 26.1+ instalado
- El proyecto está configurado para usar SwiftUI puro

