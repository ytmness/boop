-- Script para corregir problemas de creación de eventos en Supabase
-- Ejecutar en el SQL Editor de Supabase

-- 1. Verificar usuarios sin perfil (esto causa que la creación de eventos falle)
-- Ejecuta esto primero para ver si hay usuarios sin perfil:
SELECT 
    u.id as user_id,
    u.email,
    u.phone,
    CASE WHEN p.user_id IS NULL THEN 'SIN PERFIL' ELSE 'CON PERFIL' END as estado
FROM auth.users u
LEFT JOIN public.profiles p ON p.user_id = u.id
ORDER BY u.created_at DESC;

-- 2. Crear perfiles automáticamente para usuarios que no tienen uno
-- Esto es necesario porque la tabla events tiene una foreign key a profiles(user_id)
INSERT INTO public.profiles (user_id, name, created_at, updated_at)
SELECT 
    u.id,
    COALESCE(
        u.raw_user_meta_data->>'name',
        u.raw_user_meta_data->>'email',
        SPLIT_PART(u.email, '@', 1),
        'Usuario'
    ) as name,
    u.created_at,
    NOW()
FROM auth.users u
WHERE u.id NOT IN (SELECT user_id FROM public.profiles)
ON CONFLICT (user_id) DO NOTHING;

-- 3. Verificar y corregir la política RLS para creación de eventos
-- La política debe permitir que usuarios autenticados creen eventos
DROP POLICY IF EXISTS "Organizers can create events" ON public.events;

CREATE POLICY "Organizers can create events" ON public.events
    FOR INSERT 
    WITH CHECK (
        -- Usuario debe estar autenticado
        auth.uid() IS NOT NULL 
        -- El created_by debe ser el usuario autenticado
        AND auth.uid() = created_by
        -- El usuario debe tener un perfil (verificado por la foreign key, pero lo verificamos explícitamente)
        AND EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE user_id = auth.uid()
        )
    );

-- 4. Verificar que la política se aplicó correctamente
-- Ejecuta esto para ver las políticas activas:
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE tablename = 'events' AND cmd = 'INSERT';

-- 5. Si necesitas hacer una prueba manual de inserción (ejecuta como usuario autenticado):
-- NOTA: Reemplaza 'TU_USER_ID_AQUI' con tu UUID de usuario real
/*
INSERT INTO public.events (
    title,
    start_time,
    created_by,
    is_public,
    status
) VALUES (
    'Evento de prueba',
    NOW() + INTERVAL '1 day',
    auth.uid(), -- Esto debe ser igual a tu user_id
    false,
    'draft'
) RETURNING *;
*/

-- 6. Si sigues teniendo problemas, verifica los permisos de la tabla:
GRANT INSERT ON public.events TO authenticated;
GRANT SELECT ON public.events TO authenticated;
GRANT UPDATE ON public.events TO authenticated;

-- 7. Verificar que RLS está habilitado:
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' AND tablename = 'events';
-- Debe mostrar rowsecurity = true

