-- Crear buckets de Storage usando la extensión storage
-- Nota: Requiere permisos de administrador

-- Crear bucket para avatares
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'avatars',
    'avatars',
    true,
    5242880,
    ARRAY['image/jpeg', 'image/png', 'image/webp']
)
ON CONFLICT (id) DO NOTHING;

-- Crear bucket para imágenes de eventos
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'event-images',
    'event-images',
    true,
    10485760,
    ARRAY['image/jpeg', 'image/png', 'image/webp']
)
ON CONFLICT (id) DO NOTHING;

-- Crear bucket para memories
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'memories',
    'memories',
    false,
    10485760,
    ARRAY['image/jpeg', 'image/png', 'image/webp', 'video/mp4']
)
ON CONFLICT (id) DO NOTHING;

-- Políticas para el bucket 'avatars'
-- SELECT: Cualquiera puede ver avatares
CREATE POLICY "Avatar images are publicly accessible"
ON storage.objects FOR SELECT
USING (bucket_id = 'avatars');

-- INSERT: Solo usuarios autenticados pueden subir su propio avatar
CREATE POLICY "Users can upload own avatar"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'avatars' AND
    auth.uid()::text = (storage.foldername(name))[1]
);

-- UPDATE: Solo el usuario puede actualizar su propio avatar
CREATE POLICY "Users can update own avatar"
ON storage.objects FOR UPDATE
USING (
    bucket_id = 'avatars' AND
    auth.uid()::text = (storage.foldername(name))[1]
);

-- DELETE: Solo el usuario puede eliminar su propio avatar
CREATE POLICY "Users can delete own avatar"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'avatars' AND
    auth.uid()::text = (storage.foldername(name))[1]
);

-- Políticas para el bucket 'event-images'
-- SELECT: Cualquiera puede ver imágenes de eventos
CREATE POLICY "Event images are publicly accessible"
ON storage.objects FOR SELECT
USING (bucket_id = 'event-images');

-- INSERT: Solo organizadores pueden subir imágenes de eventos
CREATE POLICY "Organizers can upload event images"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'event-images' AND
    EXISTS (
        SELECT 1 FROM public.events
        WHERE id::text = (storage.foldername(name))[1]
        AND created_by = auth.uid()
    )
);

-- UPDATE: Solo organizadores pueden actualizar imágenes de sus eventos
CREATE POLICY "Organizers can update event images"
ON storage.objects FOR UPDATE
USING (
    bucket_id = 'event-images' AND
    EXISTS (
        SELECT 1 FROM public.events
        WHERE id::text = (storage.foldername(name))[1]
        AND created_by = auth.uid()
    )
);

-- DELETE: Solo organizadores pueden eliminar imágenes de sus eventos
CREATE POLICY "Organizers can delete event images"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'event-images' AND
    EXISTS (
        SELECT 1 FROM public.events
        WHERE id::text = (storage.foldername(name))[1]
        AND created_by = auth.uid()
    )
);

-- Políticas para el bucket 'memories'
-- SELECT: Usuarios pueden ver memories de eventos a los que asistieron
CREATE POLICY "Users can view memories from events they attended"
ON storage.objects FOR SELECT
USING (
    bucket_id = 'memories' AND
    (
        -- El usuario subió la memory
        auth.uid()::text = (storage.foldername(name))[1] OR
        -- El usuario tiene un ticket para el evento relacionado
        EXISTS (
            SELECT 1 FROM public.tickets
            WHERE owner_user_id = auth.uid()
            AND event_id::text = (storage.foldername(name))[2]
        )
    )
);

-- INSERT: Usuarios autenticados pueden subir memories
CREATE POLICY "Authenticated users can upload memories"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'memories' AND
    auth.uid() IS NOT NULL
);

-- UPDATE: Solo el usuario que subió la memory puede actualizarla
CREATE POLICY "Users can update own memories"
ON storage.objects FOR UPDATE
USING (
    bucket_id = 'memories' AND
    auth.uid()::text = (storage.foldername(name))[1]
);

-- DELETE: Solo el usuario que subió la memory puede eliminarla
CREATE POLICY "Users can delete own memories"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'memories' AND
    auth.uid()::text = (storage.foldername(name))[1]
);

