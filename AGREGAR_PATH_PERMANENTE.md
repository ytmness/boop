# Agregar Flutter al PATH Permanentemente

## Problema
Flutter está instalado pero no está en el PATH del sistema, por lo que no funciona desde PowerShell directamente.

## Solución Temporal (Ya aplicada)

He creado el script `ejecutar_app.ps1` que agrega Flutter al PATH automáticamente cada vez que lo ejecutas.

**Para ejecutar la app, simplemente usa:**
```powershell
.\ejecutar_app.ps1
```

## Solución Permanente: Agregar al PATH del Sistema

Para que Flutter funcione desde cualquier terminal sin scripts:

### Opción 1: Desde PowerShell (Como Administrador) ⭐ RECOMENDADO

1. **Abre PowerShell como Administrador:**
   - Clic derecho en PowerShell → "Ejecutar como administrador"

2. **Ejecuta este comando:**
   ```powershell
   [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Users\PC\flutter\bin", [EnvironmentVariableTarget]::Machine)
   ```

3. **Reinicia Cursor** completamente

4. **Verifica:**
   ```powershell
   flutter --version
   ```

### Opción 2: Desde Configuración de Windows

1. Presiona `Windows + X` → **Sistema**
2. Haz clic en **"Configuración avanzada del sistema"**
3. Haz clic en **"Variables de entorno"**
4. En **"Variables del sistema"**, busca **"Path"** y haz clic en **"Editar"**
5. Haz clic en **"Nuevo"**
6. Agrega: `C:\Users\PC\flutter\bin`
7. Haz clic en **"Aceptar"** en todas las ventanas
8. **Reinicia Cursor** completamente

### Opción 3: Usar el Script Automático (Como Administrador)

1. Abre PowerShell **como Administrador**
2. Ejecuta:
   ```powershell
   cd C:\Users\PC\Desktop\BOOP
   .\agregar_flutter_path.ps1
   ```
3. Reinicia Cursor

## Verificar que Funciona

Después de agregar al PATH y reiniciar Cursor:

1. Abre una **nueva** terminal en Cursor
2. Ejecuta:
   ```powershell
   flutter --version
   ```
3. Deberías ver la versión de Flutter sin errores

## Ejecutar la App

Una vez agregado al PATH permanentemente:

```powershell
cd C:\Users\PC\Desktop\BOOP
flutter pub get
flutter run -d chrome
```

O simplemente usa el script:
```powershell
.\ejecutar_app.ps1
```

## Nota Importante

**Cursor ya está configurado** para usar Flutter directamente (en `.vscode/settings.json`), así que puedes ejecutar la app desde Cursor usando `F5` o el botón "Run" sin necesidad de agregar al PATH. 

El PATH solo es necesario si quieres usar `flutter` desde la terminal directamente.

