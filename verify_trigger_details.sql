-- ============================================
-- VERIFICACIÓN COMPLETA DEL TRIGGER
-- ============================================
-- Ejecuta estas consultas para verificar que todo está correcto

-- 1. VERIFICAR la definición de la función (debe usar los campos correctos)
SELECT 
    routine_name,
    routine_definition
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_name = 'handle_new_user';

-- 2. VERIFICAR usuarios sin perfil (debe ser 0)
SELECT 
    COUNT(*) as total_usuarios,
    COUNT(p.user_id) as usuarios_con_perfil,
    COUNT(*) - COUNT(p.user_id) as usuarios_sin_perfil
FROM auth.users u
LEFT JOIN public.profiles p ON p.user_id = u.id;

-- 3. LISTAR usuarios sin perfil (si hay alguno)
SELECT 
    u.id as user_id,
    u.email,
    u.created_at as fecha_registro,
    '❌ SIN PERFIL - Necesita crearse manualmente' as estado
FROM auth.users u
LEFT JOIN public.profiles p ON p.user_id = u.id
WHERE p.user_id IS NULL
ORDER BY u.created_at DESC;

-- 4. VERIFICAR estructura de la tabla profiles (para confirmar campos)
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name = 'profiles'
ORDER BY ordinal_position;

-- ============================================
-- SI HAY USUARIOS SIN PERFIL, EJECUTA ESTO:
-- ============================================
-- (Solo si el paso 3 mostró usuarios sin perfil)

-- Crear perfiles para usuarios existentes sin perfil
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
-- VERIFICAR QUE LA FUNCIÓN USA LOS CAMPOS CORRECTOS
-- ============================================
-- Si la función tiene campos incorrectos (email, phone), ejecuta esto:

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
