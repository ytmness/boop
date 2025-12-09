# 🚀 Cómo Ejecutar el Demo de BOOP

## Pasos Rápidos

### Opción 1: Usar el Script (Más Fácil)

1. Abre PowerShell en la carpeta del proyecto
2. Ejecuta:
   ```powershell
   .\ejecutar_app.ps1
   ```

### Opción 2: Manual

1. Abre PowerShell en la carpeta del proyecto
2. Ejecuta estos comandos:
   ```powershell
   # Agregar Flutter al PATH (si no está)
   $env:Path += ";C:\Users\PC\flutter\bin"
   
   # Instalar dependencias
   flutter pub get
   
   # Ejecutar en Chrome
   flutter run -d chrome
   ```

## Una vez que la App se Abra

### 1. Iniciar Sesión (Modo Demo)

**Con Teléfono:**
- Ingresa cualquier número (ej: `+1234567890` o `1234567890`)
- Presiona "Enviar código"
- Ingresa **cualquier código de 6 dígitos** (ej: `123456`)
- Presiona "Verificar"

**Con Email:**
- Ingresa cualquier email (ej: `demo@boop.com`)
- Presiona "Enviar código"
- Ingresa **cualquier código de 6 dígitos** (ej: `123456`)
- Presiona "Verificar"

### 2. Explorar la App

Una vez dentro podrás:
- ✅ Ver la pantalla principal (Explore)
- ✅ Ver tu perfil
- ✅ Navegar por todas las pantallas
- ✅ Ver eventos, comunidades, amigos, etc.

## Notas Importantes

- ⚠️ **No necesitas configurar Supabase** - El modo demo funciona automáticamente
- ⚠️ **Los datos son temporales** - Se pierden al cerrar la app
- ⚠️ **Cualquier código OTP funciona** - No necesitas códigos reales

## Solución de Problemas

### Si Chrome no se abre:
```powershell
flutter devices
# Verifica que Chrome aparezca en la lista
```

### Si hay errores de compilación:
```powershell
flutter clean
flutter pub get
flutter run -d chrome
```

### Si Flutter no se encuentra:
Asegúrate de que Flutter esté en el PATH o usa:
```powershell
C:\Users\PC\flutter\bin\flutter run -d chrome
```

