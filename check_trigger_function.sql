-- ============================================
-- VERIFICAR Y CORREGIR LA FUNCIÓN DEL TRIGGER
-- ============================================

-- 1. VER la definición actual de la función
SELECT 
    routine_name,
    routine_definition
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_name = 'handle_new_user';

-- ============================================
-- ACTUALIZAR LA FUNCIÓN CON LOS CAMPOS CORRECTOS
-- ============================================
-- Ejecuta esto para asegurarte de que la función usa los campos correctos
-- (sin email ni phone, que no existen en tu tabla)

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

-- ============================================
-- VERIFICAR QUE SE ACTUALIZÓ CORRECTAMENTE
-- ============================================
-- Ejecuta esto después para confirmar

SELECT 
    routine_name,
    CASE 
        WHEN routine_definition LIKE '%email%' AND routine_definition NOT LIKE '%SPLIT_PART(NEW.email%' THEN '❌ ERROR: Intenta insertar email en profiles'
        WHEN routine_definition LIKE '%phone%' THEN '❌ ERROR: Intenta insertar phone en profiles'
        WHEN routine_definition LIKE '%user_id%' AND routine_definition LIKE '%name%' THEN '✅ CORRECTO: Usa los campos correctos'
        ELSE '⚠️ REVISAR: Verificar manualmente'
    END as estado
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_name = 'handle_new_user';
