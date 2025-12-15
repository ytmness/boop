-- ============================================
-- CORREGIR POLÍTICAS RLS PARA LA TABLA EVENTS
-- ============================================
-- Este script asegura que los usuarios autenticados puedan crear eventos

-- Verificar si RLS está activado
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' AND tablename = 'events';

-- Activar RLS si no está activado
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;

-- Eliminar políticas existentes que puedan estar causando conflictos
DROP POLICY IF EXISTS "events_select_public" ON public.events;
DROP POLICY IF EXISTS "events_select_authenticated" ON public.events;
DROP POLICY IF EXISTS "events_insert_authenticated" ON public.events;
DROP POLICY IF EXISTS "events_insert_own" ON public.events;
DROP POLICY IF EXISTS "events_update_own" ON public.events;
DROP POLICY IF EXISTS "events_delete_own" ON public.events;

-- SELECT: Usuarios autenticados pueden ver eventos públicos o sus propios eventos
CREATE POLICY "events_select_authenticated"
ON public.events
FOR SELECT
TO authenticated
USING (
    is_public = true 
    OR created_by = auth.uid()
);

-- SELECT: También permitir lectura pública de eventos públicos (opcional, si quieres feed público)
CREATE POLICY "events_select_public"
ON public.events
FOR SELECT
TO public
USING (is_public = true);

-- INSERT: Usuarios autenticados pueden crear eventos
-- IMPORTANTE: Verificar que created_by coincida con auth.uid()
CREATE POLICY "events_insert_authenticated"
ON public.events
FOR INSERT
TO authenticated
WITH CHECK (
    created_by = auth.uid()
);

-- UPDATE: Solo el creador puede actualizar su evento
CREATE POLICY "events_update_own"
ON public.events
FOR UPDATE
TO authenticated
USING (created_by = auth.uid())
WITH CHECK (created_by = auth.uid());

-- DELETE: Solo el creador puede eliminar su evento
CREATE POLICY "events_delete_own"
ON public.events
FOR DELETE
TO authenticated
USING (created_by = auth.uid());

-- Verificar que las políticas se crearon correctamente
SELECT 
    schemaname,
    tablename,
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE schemaname = 'public' 
  AND tablename = 'events'
ORDER BY cmd, policyname;
