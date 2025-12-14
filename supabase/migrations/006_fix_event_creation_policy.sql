-- Script para verificar y corregir políticas de creación de eventos
-- Ejecutar en el SQL Editor de Supabase

-- 1. Verificar que la política de creación existe y es correcta
-- La política actual requiere que auth.uid() = created_by
-- Esto debería funcionar, pero vamos a asegurarnos de que está bien configurada

-- Primero, verificar si hay algún problema con la política actual
DROP POLICY IF EXISTS "Organizers can create events" ON public.events;

-- Crear política más permisiva para debugging (temporal)
-- Permite a cualquier usuario autenticado crear eventos
CREATE POLICY "Organizers can create events" ON public.events
    FOR INSERT 
    WITH CHECK (
        auth.uid() IS NOT NULL 
        AND auth.uid() = created_by
        -- Verificar que el usuario tenga un perfil
        AND EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE user_id = auth.uid()
        )
    );

-- También asegurémonos de que la tabla profiles tenga los datos necesarios
-- Si un usuario no tiene perfil, la creación de eventos fallará
-- porque created_by referencia a profiles(user_id)

-- Verificar usuarios sin perfil (esto puede causar problemas)
-- SELECT auth.uid() as user_id, 
--        EXISTS(SELECT 1 FROM public.profiles WHERE user_id = auth.uid()) as has_profile
-- FROM auth.users;

-- Si necesitas crear perfiles automáticamente para usuarios existentes:
-- INSERT INTO public.profiles (user_id, name, created_at, updated_at)
-- SELECT id, COALESCE(raw_user_meta_data->>'name', raw_user_meta_data->>'email', 'Usuario'), NOW(), NOW()
-- FROM auth.users
-- WHERE id NOT IN (SELECT user_id FROM public.profiles)
-- ON CONFLICT (user_id) DO NOTHING;

-- Nota: La política requiere que:
-- 1. El usuario esté autenticado (auth.uid() IS NOT NULL)
-- 2. El created_by sea igual al auth.uid()
-- 3. El usuario tenga un perfil en la tabla profiles

