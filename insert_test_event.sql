-- ============================================
-- Script para insertar un evento de prueba
-- Ejecutar en Supabase SQL Editor
-- ============================================

-- Obtener el user_id del primer usuario disponible
-- Si quieres usar un usuario específico, reemplaza la consulta con:
-- SELECT id FROM auth.users WHERE email = 'tu-email@ejemplo.com' LIMIT 1;

WITH user_data AS (
    SELECT id as user_id 
    FROM auth.users 
    ORDER BY created_at DESC 
    LIMIT 1
)
-- Asegurarse de que existe un perfil
INSERT INTO public.profiles (user_id, name)
SELECT user_id, 'Usuario de Prueba'
FROM user_data
ON CONFLICT (user_id) DO NOTHING;

-- Insertar evento de prueba
WITH user_data AS (
    SELECT id as user_id 
    FROM auth.users 
    ORDER BY created_at DESC 
    LIMIT 1
)
INSERT INTO public.events (
    title,
    description,
    start_time,
    end_time,
    city,
    address,
    status,
    is_public,
    created_by,
    timezone
)
SELECT 
    'Concierto de Prueba BOOP',
    'Este es un evento de prueba para verificar que la aplicación carga eventos correctamente. ¡Ven y disfruta de la música en vivo!',
    NOW() + INTERVAL '7 days', -- Evento en 7 días
    NOW() + INTERVAL '7 days' + INTERVAL '3 hours', -- Dura 3 horas
    'Madrid',
    'Calle Gran Vía 1, Madrid, España',
    'published',
    true,
    user_id,
    'Europe/Madrid'
FROM user_data;

-- Verificar que el evento se creó correctamente
SELECT 
    id,
    title,
    city,
    status,
    is_public,
    start_time,
    created_by,
    created_at
FROM public.events
WHERE title = 'Concierto de Prueba BOOP'
ORDER BY created_at DESC
LIMIT 1;

