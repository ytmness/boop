# Guía Completa: Instalar Flutter en Windows

## Paso 1: Descargar Flutter SDK

1. Ve a: **https://docs.flutter.dev/get-started/install/windows**
2. Haz clic en "Download Flutter SDK"
3. Descarga el archivo ZIP (aproximadamente 1.5 GB)

## Paso 2: Extraer Flutter

1. Crea una carpeta `C:\src` (si no existe)
2. Extrae el contenido del ZIP a `C:\src\flutter`
   - La ruta final debe ser: `C:\src\flutter\bin\flutter.bat`

## Paso 3: Agregar Flutter al PATH

### Método 1: Desde Configuración de Windows (Recomendado)

1. Presiona `Windows + X` y selecciona "Sistema"
2. Haz clic en "Configuración avanzada del sistema"
3. Haz clic en "Variables de entorno"
4. En "Variables del sistema", busca "Path" y haz clic en "Editar"
5. Haz clic en "Nuevo"
6. Agrega: `C:\src\flutter\bin`
7. Haz clic en "Aceptar" en todas las ventanas

### Método 2: Desde PowerShell (Como Administrador)

```powershell
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\src\flutter\bin", [EnvironmentVariableTarget]::Machine)
```

## Paso 4: Reiniciar PowerShell

**IMPORTANTE:** Cierra y vuelve a abrir PowerShell para que los cambios surtan efecto.

## Paso 5: Verificar Instalación

Abre una **nueva** ventana de PowerShell y ejecuta:

```powershell
flutter doctor
```

Deberías ver información sobre Flutter. Si hay problemas, `flutter doctor` te dirá qué falta.

## Paso 6: Habilitar Flutter Web (Opcional pero Recomendado)

```powershell
flutter config --enable-web
```

## Paso 7: Ejecutar la App BOOP

```powershell
cd C:\Users\PC\Desktop\BOOP
flutter pub get
flutter run -d chrome
```

---

## Solución de Problemas

### Si "flutter" sigue sin reconocerse:

1. Verifica que la ruta sea correcta: `C:\src\flutter\bin\flutter.bat` debe existir
2. Reinicia completamente PowerShell (cierra todas las ventanas)
3. Verifica el PATH:
   ```powershell
   $env:Path -split ';' | Select-String flutter
   ```
4. Si no aparece, vuelve a agregarlo al PATH

### Si falta Git:

Flutter requiere Git. Descárgalo de: https://git-scm.com/download/win

### Si hay problemas con Android/iOS:

Para solo ver la app en el navegador, no necesitas Android Studio ni Xcode. Solo ejecuta:
```powershell
flutter run -d chrome
```

---

## Alternativa Rápida: Usar VS Code

1. Instala VS Code: https://code.visualstudio.com/
2. Instala la extensión "Flutter" en VS Code
3. Abre la carpeta `C:\Users\PC\Desktop\BOOP` en VS Code
4. VS Code detectará Flutter y te ayudará a instalarlo automáticamente

