# Configurar Flutter en Cursor

## Paso 1: Instalar Flutter SDK (Si aún no lo tienes)

### Opción A: Instalación Manual

1. **Descarga Flutter:**
   - Ve a: https://docs.flutter.dev/get-started/install/windows
   - Descarga el SDK de Flutter (ZIP)

2. **Extrae Flutter:**
   - Crea la carpeta `C:\src` si no existe
   - Extrae el contenido del ZIP a `C:\src\flutter`
   - La ruta debe ser: `C:\src\flutter\bin\flutter.bat`

3. **Agrega al PATH:**
   - Presiona `Windows + X` → Sistema
   - Variables de entorno → Editar PATH
   - Agrega: `C:\src\flutter\bin`
   - **Reinicia Cursor** después de esto

### Opción B: Usar el instalador de Flutter (Más fácil)

1. Descarga el instalador desde: https://docs.flutter.dev/get-started/install/windows
2. Ejecuta el instalador y sigue las instrucciones
3. El instalador configurará todo automáticamente

## Paso 2: Instalar Extensiones en Cursor

1. **Abre Cursor**
2. **Ve a Extensiones:**
   - Presiona `Ctrl + Shift + X` o haz clic en el ícono de extensiones en la barra lateral

3. **Instala estas extensiones:**
   - **Flutter** (por Dart Code) - Busca "Flutter" y instala la oficial
   - **Dart** (se instala automáticamente con Flutter)

4. **Reinicia Cursor** después de instalar las extensiones

## Paso 3: Configurar Flutter en Cursor

1. **Abre la carpeta del proyecto:**
   - En Cursor: `File` → `Open Folder`
   - Selecciona: `C:\Users\PC\Desktop\BOOP`

2. **Verifica que Cursor detecte Flutter:**
   - Abre la terminal integrada: `Ctrl + `` (backtick) o `Terminal` → `New Terminal`
   - Ejecuta: `flutter doctor`
   - Si Flutter está instalado correctamente, verás información del SDK

3. **Si Cursor no encuentra Flutter:**
   - Presiona `Ctrl + Shift + P` (o `F1`)
   - Escribe: `Flutter: Change SDK`
   - Selecciona la ruta: `C:\src\flutter`

## Paso 4: Instalar Dependencias

En la terminal de Cursor (en la carpeta del proyecto):

```powershell
flutter pub get
```

## Paso 5: Ejecutar la App

### Opción 1: Desde la Terminal

```powershell
flutter run -d chrome
```

### Opción 2: Desde la Interfaz de Cursor

1. **Abre el archivo `lib/main.dart`**
2. **Haz clic en el botón "Run"** que aparece arriba del `main()` o presiona `F5`
3. **Selecciona el dispositivo:**
   - Si tienes Chrome instalado, selecciona "Chrome"
   - O selecciona otro dispositivo disponible

### Opción 3: Usar el Command Palette

1. Presiona `Ctrl + Shift + P`
2. Escribe: `Flutter: Run Flutter`
3. Selecciona el dispositivo (Chrome para web)

## Paso 6: Configurar para Desarrollo

### Hot Reload (Recarga Rápida)

Cuando la app esté corriendo:
- Presiona `r` en la terminal para hot reload
- Presiona `R` para hot restart
- Presiona `q` para salir

### Debugging

1. Coloca breakpoints haciendo clic en el margen izquierdo del código
2. Presiona `F5` para iniciar en modo debug
3. La app se pausará en los breakpoints

## Solución de Problemas

### Cursor no encuentra Flutter

1. Verifica que Flutter esté en el PATH:
   ```powershell
   flutter doctor
   ```

2. Si no funciona, configura la ruta manualmente:
   - `Ctrl + Shift + P` → `Flutter: Change SDK`
   - Ingresa: `C:\src\flutter`

### Error "No devices found"

Para ejecutar en Chrome (web):
```powershell
flutter config --enable-web
flutter run -d chrome
```

### Error al instalar dependencias

```powershell
flutter clean
flutter pub get
```

### La extensión de Flutter no aparece

1. Reinicia Cursor completamente
2. Verifica que estés en la carpeta del proyecto Flutter
3. Abre cualquier archivo `.dart` para activar la extensión

## Atajos Útiles en Cursor

- `Ctrl + Shift + P` - Command Palette
- `F5` - Ejecutar/Debug
- `Ctrl + F5` - Ejecutar sin debug
- `Ctrl + `` - Terminal integrada
- `r` - Hot reload (cuando la app está corriendo)
- `R` - Hot restart
- `q` - Salir de la app

## Verificación Final

Para verificar que todo está configurado:

1. Abre `lib/main.dart`
2. Deberías ver un botón "Run" arriba de `main()`
3. Al hacer clic, debería ejecutarse la app

Si ves errores, compártelos y te ayudo a solucionarlos.

