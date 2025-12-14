# Agregar Dependencia de Supabase a Xcode

## Pasos para agregar Supabase Swift Package

1. **Abre el proyecto en Xcode:**
   - Abre `boop-ios/BoopApp/BoopApp.xcodeproj` en Xcode

2. **Agrega el paquete de Supabase:**
   - En Xcode, ve a: **File** > **Add Package Dependencies...**
   - O haz clic derecho en el proyecto en el navegador y selecciona **Add Package Dependencies...**

3. **Ingresa la URL del paquete:**
   - En el campo de búsqueda, ingresa:
   ```
   https://github.com/supabase/supabase-swift
   ```

4. **Selecciona la versión:**
   - Selecciona **Up to Next Major Version**
   - Versión mínima: `2.0.0` o la última versión disponible
   - Haz clic en **Add Package**

5. **Selecciona los productos:**
   - Marca **Supabase** en la lista de productos
   - Asegúrate de que el target **BoopApp** esté seleccionado
   - Haz clic en **Add Package**

6. **Verifica la instalación:**
   - En el navegador del proyecto, deberías ver **Package Dependencies** con `supabase-swift`
   - Intenta compilar el proyecto (Cmd + B)

## Verificación

Después de agregar el paquete, el error "Unable to find module dependency: 'Supabase'" debería desaparecer.

Si aún hay problemas:
- Limpia el build: **Product** > **Clean Build Folder** (Shift + Cmd + K)
- Cierra y vuelve a abrir Xcode
- Vuelve a compilar

