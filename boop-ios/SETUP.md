<<<<<<< HEAD
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
=======
# Guía de Configuración - BOOP iOS

## Paso 1: Crear Proyecto Xcode

1. Abre Xcode
2. File > New > Project
3. Selecciona **iOS > App**
4. Configura:
   - **Product Name:** `Boop`
   - **Interface:** SwiftUI
   - **Language:** Swift
   - **Storage:** None (o Core Data si lo necesitas después)
5. Guarda el proyecto donde prefieras

## Paso 2: Agregar Dependencias (SPM)

1. En Xcode, ve a **File > Add Package Dependencies**
2. Agrega Supabase:
   - URL: `https://github.com/supabase/supabase-swift`
   - Versión: Latest (o `^2.0.0`)
3. Click **Add Package**

## Paso 3: Copiar Archivos

1. Copia todos los archivos de la carpeta `boop-ios/Boop/` a tu proyecto Xcode
2. Mantén la estructura de carpetas:
   ```
   Boop/
   ├── App/
   │   └── BoopApp.swift
   ├── Core/
   │   ├── Design/
   │   ├── Config/
   │   └── Models/
   ├── Features/
   │   ├── Auth/
   │   ├── Events/
   │   └── Profile/
   └── Shared/
   ```

3. En Xcode, arrastra los archivos a las carpetas correspondientes
4. Asegúrate de que todos los archivos estén en el target **Boop**

## Paso 4: Configurar Info.plist

1. Abre `Info.plist`
2. Agrega permisos si es necesario:
   - **Privacy - Camera Usage Description** (si usas cámara)
   - **Privacy - Photo Library Usage Description** (si usas galería)

## Paso 5: Configurar Supabase

Las credenciales ya están configuradas en `SupabaseConfig.swift` (mismas que Flutter):
- URL: `https://wmhithphfqvyfzeerazg.supabase.co`
- Anon Key: (ya configurada)

Si necesitas cambiarlas, edita `Boop/Core/Config/SupabaseConfig.swift`

## Paso 6: Requisitos de iOS

- **iOS Deployment Target:** iOS 17.0 (mínimo)
- **Swift Version:** 5.9+
- **Xcode:** 15.0+

## Paso 7: Ejecutar

1. Selecciona un simulador o dispositivo
2. Presiona **Cmd + R** para ejecutar
3. La app debería iniciar con la pantalla de onboarding

## Características Implementadas

✅ **Liquid Glass nativo:**
- iOS 26+: Usa `.glassEffect(.clear.interactive())`
- iOS < 26: Fallback a `.ultraThinMaterial`

✅ **Flujo OTP:**
- Login con teléfono o email
- Verificación con 8 dígitos (igual que Flutter)
- Misma lógica de Supabase

✅ **Pantallas:**
- Onboarding
- PhoneLoginView
- EmailLoginView
- VerifyOTPView
- EventsHubView (grid de eventos)
- CreateEventView
- ProfileView

✅ **Servicios:**
- AuthViewModel (OTP completo)
- EventService (CRUD de eventos)

## Notas Importantes

1. **Liquid Glass:** El efecto nativo solo funciona en iOS 26+. En versiones anteriores se usa `.ultraThinMaterial` como fallback.

2. **OTP:** El código acepta 6 u 8 dígitos (igual que Flutter), pero la UI muestra 8 campos.

3. **Navegación:** Usa `NavigationStack` (iOS 16+) y `NavigationLink` para navegar entre pantallas.

4. **Estado:** El `AuthViewModel` se comparte usando `@EnvironmentObject` en la app principal.

## Próximos Pasos

- [ ] Agregar manejo de imágenes (selector de imagen para eventos)
- [ ] Implementar detalle de evento
- [ ] Agregar búsqueda y filtros
- [ ] Implementar notificaciones push
- [ ] Agregar soporte para comunidades
>>>>>>> dd03647 (feat: Agregar proyecto iOS nativo con Liquid Glass y flujo OTP completo)

