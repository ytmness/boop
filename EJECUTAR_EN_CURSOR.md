# ✅ Cómo Ejecutar la App BOOP en Cursor

## Estado Actual

✅ **Flutter está instalado** en `C:\Users\PC\flutter`  
✅ **Cursor está configurado** para usar Flutter  
✅ **Dependencias instaladas** correctamente  
✅ **Flutter Web habilitado**  

## Ejecutar la App

### Método 1: Desde Cursor (Recomendado)

1. **Abre el archivo `lib/main.dart`**
2. **Haz clic en el botón "Run"** que aparece arriba de la función `main()`
   - O presiona `F5`
3. **Selecciona "Chrome"** como dispositivo
4. La app se abrirá en Chrome automáticamente

### Método 2: Desde la Terminal de Cursor

1. Abre la terminal: `Ctrl + `` (backtick)
2. Ejecuta:
   ```powershell
   flutter run -d chrome
   ```

### Método 3: Usar el Command Palette

1. Presiona `Ctrl + Shift + P`
2. Escribe: `Flutter: Run Flutter`
3. Selecciona "Chrome"

## Controles cuando la App está Corriendo

- `r` - Hot reload (recarga rápida sin perder estado)
- `R` - Hot restart (reinicia la app)
- `q` - Salir de la app
- `h` - Mostrar ayuda

## Solución de Problemas

### Si Cursor no encuentra Flutter

Ya está configurado en `.vscode/settings.json` con la ruta:
```
C:\Users\PC\flutter
```

Si aún no funciona:
1. Presiona `Ctrl + Shift + P`
2. Escribe: `Flutter: Change SDK`
3. Ingresa: `C:\Users\PC\flutter`

### Si hay errores de compilación

```powershell
flutter clean
flutter pub get
flutter run -d chrome
```

### Si Chrome no se abre

Verifica que Chrome esté instalado en:
```
C:\Program Files\Google\Chrome\Application\chrome.exe
```

O ejecuta con Edge:
```powershell
flutter run -d edge
```

## Nota sobre Supabase

La app está configurada para funcionar en **modo demo** sin credenciales de Supabase. Las pantallas se mostrarán pero las funciones que requieren backend (login real, guardar datos) no funcionarán hasta que configures Supabase.

Para configurar Supabase:
1. Crea un proyecto en https://supabase.com
2. Edita `lib/core/config/supabase_config.dart` con tus credenciales

## Próximos Pasos

1. ✅ Ejecuta la app con `F5` o `flutter run -d chrome`
2. Navega por las pantallas para ver cómo se ven
3. Configura Supabase cuando quieras probar funcionalidades completas

¡La app debería estar lista para ejecutarse! 🚀

