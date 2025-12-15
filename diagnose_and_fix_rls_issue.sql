-- ============================================
-- DIAGNÓSTICO Y CORRECCIÓN DE ERROR RLS AL CREAR EVENTOS
-- ============================================
-- Ejecuta este script en el SQL Editor de Supabase

-- 1. VERIFICAR SI EL USUARIO ACTUAL TIENE PERFIL
SELECT 
    'Usuario actual' as check_type,
    auth.uid() as user_id,
    CASE 
        WHEN EXISTS (SELECT 1 FROM public.profiles WHERE user_id = auth.uid()) 
        THEN '✅ Tiene perfil' 
        ELSE '❌ NO tiene perfil' 
    END as status;

-- 2. VERIFICAR POLÍTICAS RLS ACTUALES PARA EVENTS
SELECT 
    'Políticas RLS de events' as check_type,
    policyname,
    cmd,
    CASE 
        WHEN cmd = 'INSERT' THEN '✅ Política de INSERT encontrada'
        ELSE 'Política de ' || cmd
    END as status,
    with_check as policy_condition
FROM pg_policies
WHERE schemaname = 'public' 
  AND tablename = 'events'
  AND cmd = 'INSERT';

-- 3. CREAR PERFIL PARA USUARIOS SIN PERFIL (si es necesario)
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
WHERE u.id NOT IN (SELECT user_id FROM public.profiles WHERE user_id IS NOT NULL)
ON CONFLICT (user_id) DO NOTHING;

-- 4. ELIMINAR Y RECREAR POLÍTICA DE INSERT PARA EVENTS
-- Asegurar que sea simple y funcione correctamente
DROP POLICY IF EXISTS "Organizers can create events" ON public.events;
DROP POLICY IF EXISTS "events_insert_authenticated" ON public.events;
DROP POLICY IF EXISTS "events_insert_own" ON public.events;

-- Política simple: cualquier usuario autenticado puede crear eventos
-- siempre que created_by = auth.uid()
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

-- 5. VERIFICAR QUE LA POLÍTICA SE CREÓ CORRECTAMENTE
SELECT 
    'Verificación final' as check_type,
    policyname,
    cmd,
    '✅ Política creada correctamente' as status
FROM pg_policies
WHERE schemaname = 'public' 
  AND tablename = 'events'
  AND cmd = 'INSERT';

-- 6. TEST: Intentar crear un evento de prueba (descomenta para probar)
-- NOTA: Esto solo funcionará si estás autenticado
/*
INSERT INTO public.events (
    title,
    description,
    start_time,
    city,
    address,
    status,
    is_public,
    created_by
) VALUES (
    'Evento de prueba',
    'Este es un evento de prueba para verificar RLS',
    NOW() + INTERVAL '1 day',
    'Ciudad de prueba',
    'Dirección de prueba',
    'draft',
    false,
    auth.uid()
) RETURNING id, title, created_by;
*/
