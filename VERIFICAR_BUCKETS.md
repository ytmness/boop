# Cómo Verificar Buckets de Storage en Supabase

## Método 1: Desde el Dashboard (Visual)

1. **Accede a tu proyecto en Supabase Dashboard**
   - Ve a: https://supabase.com/dashboard
   - Selecciona tu proyecto

2. **Navega a Storage**
   - En el menú lateral izquierdo, haz clic en **"Storage"**
   - Verás una lista de todos los buckets existentes

3. **Verifica si existe `event-media`**
   - Busca en la lista el bucket llamado **"event-media"**
   - Si no aparece, necesitas crearlo

## Método 2: Desde SQL Editor (Más Detallado)

1. **Abre el SQL Editor**
   - En el dashboard, ve a **"SQL Editor"** en el menú lateral

2. **Ejecuta el script de verificación**
   - Copia y pega el contenido de `check_storage_buckets.sql`
   - Haz clic en **"Run"** o presiona `Ctrl+Enter`

3. **Revisa los resultados**
   - Verás una tabla con todos los buckets y sus configuraciones
   - Busca la fila con `id = 'event-media'`

## Método 3: Crear el Bucket si No Existe

Si el bucket `event-media` no existe, ejecuta el script SQL:

1. **Abre SQL Editor**
2. **Ejecuta `create_event_media_bucket.sql`**
   - Este script crea el bucket con las configuraciones correctas
   - También configura las políticas RLS necesarias

## Buckets Actuales en el Proyecto

Según la documentación existente, estos buckets ya deberían existir:

- ✅ `avatars` - Para avatares de usuario
- ✅ `event-images` - Para imágenes de eventos (una sola imagen)
- ✅ `memories` - Para fotos/videos de eventos
- ❓ `event-media` - **NUEVO** - Para múltiples fotos/videos por evento

## Estructura del Bucket `event-media`

- **Nombre**: `event-media`
- **Visibilidad**: Público (para que las imágenes sean accesibles)
- **Límite de tamaño**: 50MB (para soportar videos)
- **Tipos MIME permitidos**:
  - `image/jpeg`
  - `image/png`
  - `image/webp`
  - `image/heic`
  - `video/mp4`
  - `video/quicktime`
  - `video/x-msvideo`

- **Estructura de carpetas**: `events/{event_id}/media/{filename}`

## Verificación Rápida con SQL

Ejecuta esta query simple para verificar:

```sql
SELECT id, name, public, file_size_limit 
FROM storage.buckets 
WHERE id = 'event-media';
```

Si no devuelve ninguna fila, el bucket no existe y debes crearlo.
