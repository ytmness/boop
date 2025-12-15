-- ============================================
-- VERIFICAR CONDICIÓN DE LA POLÍTICA DE INSERT
-- ============================================

-- Ver la condición completa de la política
SELECT 
    policyname,
    cmd,
    with_check as policy_condition,
    qual as using_condition
FROM pg_policies
WHERE schemaname = 'public' 
  AND tablename = 'events'
  AND cmd = 'INSERT';

-- Si la política no tiene la verificación de perfil, actualizarla
-- Primero verificar si existe la verificación
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM pg_policies 
        WHERE schemaname = 'public' 
          AND tablename = 'events'
          AND cmd = 'INSERT'
          AND with_check LIKE '%profiles%'
    ) THEN
        -- Eliminar y recrear con la verificación de perfil
        DROP POLICY IF EXISTS "events_insert_authenticated" ON public.events;
        
        CREATE POLICY "events_insert_authenticated"
        ON public.events
        FOR INSERT
        TO authenticated
        WITH CHECK (
            auth.uid() IS NOT NULL
            AND created_by = auth.uid()
            AND EXISTS (
                SELECT 1 FROM public.profiles 
                WHERE user_id = auth.uid()
            )
        );
        
        RAISE NOTICE 'Política actualizada con verificación de perfil';
    ELSE
        RAISE NOTICE 'Política ya tiene verificación de perfil';
    END IF;
END $$;

-- Verificar nuevamente
SELECT 
    'Política final' as check_type,
    policyname,
    cmd,
    with_check as policy_condition
FROM pg_policies
WHERE schemaname = 'public' 
  AND tablename = 'events'
  AND cmd = 'INSERT';
