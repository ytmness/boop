# Configuración de Supabase Storage

Este documento describe cómo configurar los buckets de Storage en Supabase.

## Buckets Requeridos

### 1. avatars
- **Visibilidad**: Privado (requiere autenticación)
- **Límite de tamaño**: 5MB
- **Tipos MIME permitidos**: image/jpeg, image/png, image/webp
- **Ruta**: `avatars/{user_id}/{filename}`

**Políticas RLS**:
- SELECT: Público (cualquiera puede ver avatares)
- INSERT: Usuarios autenticados pueden subir solo a su propia carpeta
- UPDATE: Usuarios autenticados pueden actualizar solo sus propios avatares
- DELETE: Usuarios autenticados pueden eliminar solo sus propios avatares

### 2. event-images
- **Visibilidad**: Público
- **Límite de tamaño**: 10MB
- **Tipos MIME permitidos**: image/jpeg, image/png, image/webp
- **Ruta**: `event-images/{event_id}/{filename}`

**Políticas RLS**:
- SELECT: Público
- INSERT: Solo organizadores (usuarios con eventos creados)
- UPDATE: Solo organizadores del evento correspondiente
- DELETE: Solo organizadores del evento correspondiente

### 3. memories
- **Visibilidad**: Privado
- **Límite de tamaño**: 10MB
- **Tipos MIME permitidos**: image/jpeg, image/png, image/webp, video/mp4
- **Ruta**: `memories/{user_id}/{event_id}/{filename}`

**Políticas RLS**:
- SELECT: Usuarios pueden ver memories de eventos a los que asistieron o de sus amigos
- INSERT: Usuarios autenticados
- UPDATE: Solo el usuario que subió la memory
- DELETE: Solo el usuario que subió la memory

## Configuración en Supabase Dashboard

1. Ve a Storage en el dashboard de Supabase
2. Crea cada bucket con las configuraciones mencionadas
3. Configura las políticas RLS en la pestaña "Policies" de cada bucket
4. Asegúrate de que las políticas coincidan con las descritas arriba

## Ejemplo de Política SQL para avatars (INSERT)

```sql
CREATE POLICY "Users can upload own avatar"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'avatars' AND
  (storage.foldername(name))[1] = auth.uid()::text
);
```

## Ejemplo de Política SQL para event-images (INSERT)

```sql
CREATE POLICY "Organizers can upload event images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'event-images' AND
  EXISTS (
    SELECT 1 FROM public.events
    WHERE id::text = (storage.foldername(name))[1]
    AND created_by = auth.uid()
  )
);
```

