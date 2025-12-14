-- ============================================
-- VERIFICAR Y CREAR TRIGGER PARA PROFILES
-- ============================================
-- Ejecuta este script en el SQL Editor de Supabase
-- para verificar si existe el trigger y crearlo/actualizarlo si es necesario

-- 1. VERIFICAR si el trigger existe
SELECT 
    trigger_name,
    event_manipulation,
    event_object_table,
    action_statement,
    action_timing
FROM information_schema.triggers
WHERE trigger_name = 'on_auth_user_created'
AND event_object_table = 'users'
AND event_object_schema = 'auth';

-- 2. VERIFICAR si la función existe
SELECT 
    routine_name,
    routine_type,
    routine_definition
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_name = 'handle_new_user';

-- 3. VERIFICAR usuarios sin perfil (problema común)
SELECT 
    u.id as user_id,
    u.email,
    CASE WHEN p.user_id IS NULL THEN '❌ SIN PERFIL' ELSE '✅ CON PERFIL' END as estado
FROM auth.users u
LEFT JOIN public.profiles p ON p.user_id = u.id
ORDER BY u.created_at DESC
LIMIT 10;

-- ============================================
-- CREAR/ACTUALIZAR FUNCIÓN Y TRIGGER
-- ============================================
-- Ejecuta esto si el trigger no existe o necesita actualizarse

-- Función para crear perfil automáticamente
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (
    user_id, 
    name, 
    avatar_url, 
    bio, 
    city, 
    is_verified,
    created_at,
    updated_at
  )
  VALUES (
    NEW.id,
    COALESCE(
      NEW.raw_user_meta_data->>'name',
      SPLIT_PART(NEW.email, '@', 1),
      'Usuario'
    ),
    NULL, -- avatar_url
    NULL, -- bio
    NULL, -- city
    false, -- is_verified
    NOW(), -- created_at
    NOW()  -- updated_at
  )
  ON CONFLICT (user_id) DO NOTHING;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Eliminar trigger si existe (para recrearlo)
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Crear trigger
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW 
  EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- CREAR PERFILES PARA USUARIOS EXISTENTES SIN PERFIL
-- ============================================
-- Ejecuta esto si hay usuarios que ya se registraron antes del trigger

INSERT INTO public.profiles (
    user_id, 
    name, 
    avatar_url, 
    bio, 
    city, 
    is_verified,
    created_at,
    updated_at
)
SELECT 
    u.id,
    COALESCE(
        u.raw_user_meta_data->>'name',
        SPLIT_PART(u.email, '@', 1),
        'Usuario'
    ) as name,
    NULL as avatar_url,
    NULL as bio,
    NULL as city,
    false as is_verified,
    u.created_at,
    NOW() as updated_at
FROM auth.users u
WHERE u.id NOT IN (SELECT user_id FROM public.profiles)
ON CONFLICT (user_id) DO NOTHING;

-- ============================================
-- VERIFICAR RESULTADO
-- ============================================
-- Ejecuta esto después para confirmar que todo está bien

-- Verificar que todos los usuarios tienen perfil
SELECT 
    COUNT(*) as total_usuarios,
    COUNT(p.user_id) as usuarios_con_perfil,
    COUNT(*) - COUNT(p.user_id) as usuarios_sin_perfil
FROM auth.users u
LEFT JOIN public.profiles p ON p.user_id = u.id;

-- Verificar que el trigger está activo
SELECT 
    '✅ Trigger activo' as estado,
    trigger_name,
    event_object_table
FROM information_schema.triggers
WHERE trigger_name = 'on_auth_user_created';
