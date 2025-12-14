# Solución de Errores de Compilación

Si después de hacer `git pull` sigues viendo errores, sigue estos pasos:

## 1. Limpiar y Reconstruir el Proyecto

En Xcode:
1. **Product** > **Clean Build Folder** (Shift + Cmd + K)
2. Cierra Xcode completamente
3. Vuelve a abrir el proyecto
4. **Product** > **Build** (Cmd + B)

## 2. Verificar que los Paquetes se Descargaron

1. En Xcode, ve al navegador del proyecto
2. Busca **Package Dependencies** en la parte inferior
3. Deberías ver `supabase-swift`
4. Si no está, ve a **File** > **Packages** > **Resolve Package Versions**

## 3. Verificar que los Archivos Estén en el Target

Para cada archivo que da error:
1. Selecciona el archivo en el navegador
2. Abre **File Inspector** (Cmd + Option + 1)
3. En **Target Membership**, asegúrate de que **BoopApp** esté marcado

## 4. Si Persisten los Errores

### Error: "Cannot find 'SearchView' in scope"
- Verifica que `SearchView.swift` esté en `BoopApp/BoopApp/Views/`
- Verifica que esté en el target BoopApp

### Error: "Cannot find 'ActivityView' in scope"
- Verifica que `ActivityView.swift` esté en `BoopApp/BoopApp/Views/`
- Verifica que esté en el target BoopApp

### Error: "Cannot find 'SupabaseConfig' in scope"
- Verifica que `SupabaseConfig.swift` esté en `BoopApp/BoopApp/Core/Config/`
- Verifica que esté en el target BoopApp

## 5. Re-agregar Archivos Manualmente (Si es Necesario)

Si los archivos no aparecen en Xcode:

1. En Xcode, haz clic derecho en la carpeta `Views`
2. Selecciona **Add Files to "BoopApp"...**
3. Navega a `boop-ios/BoopApp/BoopApp/Views/`
4. Selecciona `SearchView.swift` y `ActivityView.swift`
5. Asegúrate de que:
   - ✅ **Copy items if needed** esté desmarcado
   - ✅ **Create groups** esté seleccionado
   - ✅ **Add to targets: BoopApp** esté marcado
6. Haz clic en **Add**

Repite para `Core/Config/SupabaseConfig.swift`

## 6. Verificar Versión de Xcode

Asegúrate de tener:
- **Xcode 15.0+**
- **iOS Deployment Target:** iOS 17.0+
- **Swift Version:** 5.9+

## 7. Último Recurso: Re-clonar

Si nada funciona:

```bash
cd /Users/user284318/Documents
rm -rf boop
git clone https://github.com/ytmness/boop.git
cd boop/boop-ios/BoopApp
open BoopApp.xcodeproj
```

Luego en Xcode:
1. **File** > **Packages** > **Resolve Package Versions**
2. Espera a que se descarguen los paquetes
3. **Product** > **Build** (Cmd + B)

