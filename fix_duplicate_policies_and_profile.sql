-- ============================================
-- CORREGIR POLÍTICAS DUPLICADAS Y PERFILES FALTANTES
-- ============================================

-- 1. ELIMINAR POLÍTICAS DUPLICADAS DE INSERT
-- Mantener solo una política clara y simple
DROP POLICY IF EXISTS "Organizers can create events" ON public.events;
DROP POLICY IF EXISTS "events_insert_authenticated" ON public.events;

-- Crear UNA SOLA política de INSERT (simple y clara)
CREATE POLICY "events_insert_authenticated"
ON public.events
FOR INSERT
TO authenticated
WITH CHECK (
    -- Verificar que el usuario está autenticado
    auth.uid() IS NOT NULL
    -- Verificar que created_by coincide con el usuario autenticado
    AND created_by = auth.uid()
    -- Verificar que el usuario tiene perfil (requisito de foreign key)
    AND EXISTS (
        SELECT 1 FROM public.profiles 
        WHERE user_id = auth.uid()
    )
);

-- 2. CREAR PERFILES PARA TODOS LOS USUARIOS QUE NO TIENEN UNO
-- Esto es CRÍTICO porque events.created_by referencia profiles.user_id
INSERT INTO public.profiles (user_id, name, created_at, updated_at)
SELECT 
    u.id,
    COALESCE(
        u.raw_user_meta_data->>'name',
        SPLIT_PART(COALESCE(u.email, u.phone, 'Usuario'), '@', 1),
        'Usuario'
    ) as name,
    COALESCE(u.created_at, NOW()),
    NOW()
FROM auth.users u
WHERE u.id NOT IN (
    SELECT user_id 
    FROM public.profiles 
    WHERE user_id IS NOT NULL
)
ON CONFLICT (user_id) DO NOTHING;

-- 3. VERIFICAR USUARIOS Y SUS PERFILES
SELECT 
    u.id as user_id,
    COALESCE(u.email, u.phone, 'Sin email/teléfono') as identifier,
    CASE 
        WHEN p.user_id IS NOT NULL THEN '✅ Tiene perfil'
        ELSE '❌ NO tiene perfil'
    END as profile_status,
    u.created_at as user_created_at
FROM auth.users u
LEFT JOIN public.profiles p ON p.user_id = u.id
ORDER BY u.created_at DESC
LIMIT 10;

-- 4. VERIFICAR POLÍTICAS FINALES (debe haber solo UNA de INSERT)
SELECT 
    'Políticas de INSERT' as check_type,
    policyname,
    cmd,
    with_check as policy_condition,
    '✅ Política única' as status
FROM pg_policies
WHERE schemaname = 'public' 
  AND tablename = 'events'
  AND cmd = 'INSERT';

-- 5. VERIFICAR QUE RLS ESTÁ ACTIVADO
SELECT 
    'RLS Status' as check_type,
    tablename,
    CASE 
        WHEN rowsecurity THEN '✅ RLS activado'
        ELSE '❌ RLS desactivado'
    END as status
FROM pg_tables 
WHERE schemaname = 'public' AND tablename = 'events';

-- 6. OTORGAR PERMISOS EXPLÍCITOS (por si acaso)
GRANT INSERT ON public.events TO authenticated;
GRANT SELECT ON public.events TO authenticated;
GRANT UPDATE ON public.events TO authenticated;
GRANT DELETE ON public.events TO authenticated;
