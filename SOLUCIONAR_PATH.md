# Solucionar: Flutter no está en el PATH

## Problema
Flutter está instalado en `C:\Users\PC\flutter` pero no está en el PATH del sistema, por lo que Cursor no lo encuentra automáticamente.

## Solución Rápida (Ya aplicada)

He configurado Cursor para usar Flutter directamente desde `C:\Users\PC\flutter` mediante el archivo `.vscode/settings.json`.

**✅ Cursor ahora debería encontrar Flutter automáticamente.**

## Solución Permanente: Agregar al PATH del Sistema

Para que Flutter funcione desde cualquier terminal, agrégalo al PATH:

### Opción 1: Desde PowerShell (Como Administrador)

1. Abre PowerShell **como Administrador** (clic derecho → Ejecutar como administrador)
2. Ejecuta:
   ```powershell
   [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Users\PC\flutter\bin", [EnvironmentVariableTarget]::Machine)
   ```
3. Reinicia Cursor

### Opción 2: Desde Configuración de Windows

1. Presiona `Windows + X` → **Sistema**
2. Haz clic en **"Configuración avanzada del sistema"**
3. Haz clic en **"Variables de entorno"**
4. En **"Variables del sistema"**, busca **"Path"** y haz clic en **"Editar"**
5. Haz clic en **"Nuevo"**
6. Agrega: `C:\Users\PC\flutter\bin`
7. Haz clic en **"Aceptar"** en todas las ventanas
8. **Reinicia Cursor**

### Opción 3: Usar el Script Automático

Ejecuta el script `agregar_flutter_path.ps1` **como Administrador**:

```powershell
# Abre PowerShell como Administrador, luego:
cd C:\Users\PC\Desktop\BOOP
.\agregar_flutter_path.ps1
```

## Verificar que Funciona

Después de reiniciar Cursor:

1. Abre la terminal en Cursor: `Ctrl + `` (backtick)
2. Ejecuta:
   ```powershell
   flutter doctor
   ```
3. Deberías ver que Flutter está correctamente configurado

## Ejecutar la App

Ahora puedes ejecutar la app:

```powershell
flutter run -d chrome
```

O desde Cursor:
- Abre `lib/main.dart`
- Presiona `F5` o haz clic en el botón "Run"
- Selecciona "Chrome" como dispositivo

## Nota Importante

**No necesitas Android Studio ni Visual Studio** para ejecutar la app en Chrome (web). Los warnings sobre Android y Visual Studio son normales si solo quieres desarrollar para web.

