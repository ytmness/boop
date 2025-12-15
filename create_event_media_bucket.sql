-- ============================================
-- CREAR BUCKET 'event-media' PARA FOTOS Y VIDEOS
-- ============================================

-- Crear bucket para media de eventos (fotos y videos)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'event-media',
    'event-media',
    true,  -- Público para que las imágenes sean accesibles
    52428800,  -- 50MB límite (para videos)
    ARRAY[
        'image/jpeg', 
        'image/png', 
        'image/webp', 
        'image/heic',
        'video/mp4', 
        'video/quicktime',
        'video/x-msvideo'
    ]
)
ON CONFLICT (id) DO UPDATE
SET 
    file_size_limit = 52428800,
    allowed_mime_types = ARRAY[
        'image/jpeg', 
        'image/png', 
        'image/webp', 
        'image/heic',
        'video/mp4', 
        'video/quicktime',
        'video/x-msvideo'
    ];

-- ============================================
-- POLÍTICAS RLS PARA EL BUCKET 'event-media'
-- ============================================

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
