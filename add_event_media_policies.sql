-- ============================================
-- AGREGAR POLÍTICAS RLS AL BUCKET 'event-media'
-- ============================================
-- Este script agrega las políticas necesarias al bucket existente

-- Eliminar políticas existentes si las hay (por si acaso)
DROP POLICY IF EXISTS "Event media is publicly accessible" ON storage.objects;
DROP POLICY IF EXISTS "Users can upload media to own events" ON storage.objects;
DROP POLICY IF EXISTS "Users can update media of own events" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete media of own events" ON storage.objects;

-- SELECT: Cualquiera puede ver media de eventos públicos
CREATE POLICY "Event media is publicly accessible"
ON storage.objects FOR SELECT
USING (bucket_id = 'event-media');

-- INSERT: Solo usuarios autenticados pueden subir media a eventos que crearon
CREATE POLICY "Users can upload media to own events"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'event-media' AND
    EXISTS (
        SELECT 1 FROM public.events e
        WHERE e.id::text = (storage.foldername(name))[1]
          AND e.created_by = auth.uid()
    )
);

-- UPDATE: Solo el creador del evento puede actualizar media
CREATE POLICY "Users can update media of own events"
ON storage.objects FOR UPDATE
TO authenticated
USING (
    bucket_id = 'event-media' AND
    EXISTS (
        SELECT 1 FROM public.events e
        WHERE e.id::text = (storage.foldername(name))[1]
          AND e.created_by = auth.uid()
    )
);

-- DELETE: Solo el creador del evento puede eliminar media
CREATE POLICY "Users can delete media of own events"
ON storage.objects FOR DELETE
TO authenticated
USING (
    bucket_id = 'event-media' AND
    EXISTS (
        SELECT 1 FROM public.events e
        WHERE e.id::text = (storage.foldername(name))[1]
          AND e.created_by = auth.uid()
    )
);

-- Verificar que las políticas se crearon correctamente
SELECT 
    policyname,
    cmd,
    CASE 
        WHEN cmd = 'SELECT' THEN '✅ Lectura pública'
        WHEN cmd = 'INSERT' THEN '✅ Subida solo por creador del evento'
        WHEN cmd = 'UPDATE' THEN '✅ Actualización solo por creador'
        WHEN cmd = 'DELETE' THEN '✅ Eliminación solo por creador'
        ELSE cmd
    END AS descripcion
FROM pg_policies
WHERE schemaname = 'storage' 
  AND tablename = 'objects'
  AND policyname LIKE '%event%media%'
ORDER BY cmd;
