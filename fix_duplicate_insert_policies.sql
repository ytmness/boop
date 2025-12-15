-- ============================================
-- LIMPIAR POLÍTICAS DUPLICADAS DE INSERT
-- ============================================
-- Este script elimina la política duplicada y deja solo una política correcta

-- 1. Ver políticas actuales de INSERT
SELECT 
    policyname,
    cmd,
    roles,
    with_check as policy_condition
FROM pg_policies
WHERE schemaname = 'public' 
  AND tablename = 'events'
  AND cmd = 'INSERT';

-- 2. Eliminar la política más simple (events_insert_own)
-- Mantener solo la que verifica perfil para mayor seguridad
DROP POLICY IF EXISTS "events_insert_own" ON public.events;

-- 3. Verificar que solo queda una política de INSERT
SELECT 
    'Políticas después de limpieza' as status,
    policyname,
    cmd,
    roles,
    with_check as policy_condition
FROM pg_policies
WHERE schemaname = 'public' 
  AND tablename = 'events'
  AND cmd = 'INSERT';

-- 4. Verificar usuarios sin perfil (esto causará fallos en INSERT)
SELECT 
    u.id as user_id,
    u.email,
    CASE 
        WHEN EXISTS (SELECT 1 FROM public.profiles WHERE user_id = u.id) 
        THEN '✅ Tiene perfil' 
        ELSE '❌ NO tiene perfil - NO PODRÁ CREAR EVENTOS' 
    END as profile_status
FROM auth.users u
WHERE u.id IN (
    SELECT DISTINCT id FROM auth.users
)
ORDER BY profile_status DESC;

-- 5. Crear perfiles para usuarios que no tienen (si es necesario)
-- Descomenta esto si quieres crear perfiles automáticamente:
/*
INSERT INTO public.profiles (user_id, name, is_verified, created_at, updated_at)
SELECT 
    u.id,
    COALESCE(
        u.raw_user_meta_data->>'name',
        SPLIT_PART(COALESCE(u.email, 'Usuario'), '@', 1),
        'Usuario'
    ) as name,
    false as is_verified,
    COALESCE(u.created_at, NOW()) as created_at,
    NOW() as updated_at
FROM auth.users u
WHERE u.id NOT IN (SELECT user_id FROM public.profiles WHERE user_id IS NOT NULL)
ON CONFLICT (user_id) DO NOTHING;
*/
