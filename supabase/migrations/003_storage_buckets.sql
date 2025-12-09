-- Crear buckets de Storage
-- Nota: Estos comandos deben ejecutarse en el dashboard de Supabase Storage
-- o mediante la API de Storage, no directamente en SQL
-- Este archivo documenta la configuración necesaria

-- Bucket: avatars
-- Configuración:
-- - Public: false (solo accesible con URL firmada o políticas)
-- - File size limit: 5MB
-- - Allowed MIME types: image/jpeg, image/png, image/webp

-- Políticas para avatars:
-- SELECT: Cualquiera puede ver avatares (públicos)
-- INSERT: Solo el usuario autenticado puede subir su propio avatar
-- UPDATE: Solo el usuario autenticado puede actualizar su propio avatar
-- DELETE: Solo el usuario autenticado puede eliminar su propio avatar

-- Bucket: event-images
-- Configuración:
-- - Public: true (imágenes públicas de eventos)
-- - File size limit: 10MB
-- - Allowed MIME types: image/jpeg, image/png, image/webp

-- Políticas para event-images:
-- SELECT: Cualquiera puede ver imágenes de eventos
-- INSERT: Solo organizadores pueden subir imágenes de eventos
-- UPDATE: Solo organizadores pueden actualizar imágenes de sus eventos
-- DELETE: Solo organizadores pueden eliminar imágenes de sus eventos

-- Bucket: memories
-- Configuración:
-- - Public: false (fotos de usuarios en eventos)
-- - File size limit: 10MB
-- - Allowed MIME types: image/jpeg, image/png, image/webp, video/mp4

-- Políticas para memories:
-- SELECT: Usuarios pueden ver memories de eventos a los que asistieron o son amigos
-- INSERT: Usuarios autenticados pueden subir memories
-- UPDATE: Solo el usuario que subió la memory puede actualizarla
-- DELETE: Solo el usuario que subió la memory puede eliminarla

-- NOTA: Las políticas de Storage se configuran en el dashboard de Supabase
-- o mediante la API REST de Storage. Este archivo es solo documentación.

