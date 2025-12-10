-- Configuración de Autenticación
-- NOTA: Este archivo documenta la configuración necesaria en Supabase Dashboard
-- La mayoría de estas configuraciones NO se pueden hacer con SQL
-- Deben configurarse manualmente en el Dashboard de Supabase

-- ============================================
-- CONFIGURACIÓN EN SUPABASE DASHBOARD
-- ============================================
-- 
-- 1. Ve a: Settings > Auth > Email Auth
-- 
-- 2. Configuración recomendada:
--    - Enable email confirmations: ON
--    - Enable email change confirmations: ON
--    - Secure email change: ON
--
-- 3. Para códigos OTP numéricos (en lugar de magic links):
--    - Ve a: Authentication > Email Templates
--    - Selecciona el template "Magic Link" o "OTP"
--    - Cambia el tipo a "OTP" (código numérico de 6 dígitos)
--    - O usa el template "OTP" directamente
--
-- 4. Configuración de redirect URLs:
--    - Ve a: Settings > Auth > URL Configuration
--    - Agrega tus redirect URLs permitidas:
--      * Para desarrollo web: http://localhost:3000
--      * Para producción: https://tu-dominio.com
--      * Para app móvil: boop://auth/callback (o el scheme que uses)
--
-- 5. Configuración de Phone Auth (si usas SMS):
--    - Ve a: Settings > Auth > Phone Auth
--    - Configura un proveedor SMS (Twilio, MessageBird, etc.)
--    - Agrega las credenciales del proveedor
--
-- ============================================
-- POLÍTICAS DE SEGURIDAD (Ya configuradas en 002_rls_policies.sql)
-- ============================================
-- Las políticas RLS ya están configuradas para permitir:
-- - Usuarios pueden crear su propio perfil al registrarse
-- - Usuarios pueden ver todos los perfiles públicos
-- - Usuarios solo pueden editar su propio perfil

-- ============================================
-- FUNCIONES AUXILIARES (Opcional)
-- ============================================

-- Función para crear perfil automáticamente cuando se crea un usuario
-- Esta función se ejecuta automáticamente cuando un usuario se registra
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (user_id, name, email, phone)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'name', NEW.email, 'Usuario'),
    NEW.email,
    NEW.phone
  )
  ON CONFLICT (user_id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger para crear perfil automáticamente
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- TEMPLATE DE EMAIL CON CSS (Para Magic Link)
-- ============================================
-- Copia este HTML en el template de "Magic link" en Supabase Dashboard
-- Ve a: Authentication > Email Templates > Magic Link

/*
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; background-color: #f5f5f7;">
  <table role="presentation" style="width: 100%; border-collapse: collapse;">
    <tr>
      <td style="padding: 40px 20px; text-align: center;">
        <table role="presentation" style="max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 20px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);">
          <!-- Header con gradiente -->
          <tr>
            <td style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px 30px; border-radius: 20px 20px 0 0; text-align: center;">
              <h1 style="margin: 0; color: #ffffff; font-size: 32px; font-weight: 700; letter-spacing: -0.5px;">
                BOOP
              </h1>
              <p style="margin: 10px 0 0 0; color: rgba(255, 255, 255, 0.9); font-size: 16px;">
                Tu código de verificación
              </p>
            </td>
          </tr>
          
          <!-- Contenido principal -->
          <tr>
            <td style="padding: 40px 30px;">
              <h2 style="margin: 0 0 20px 0; color: #1d1d1f; font-size: 24px; font-weight: 600; text-align: center;">
                Iniciar sesión
              </h2>
              
              <p style="margin: 0 0 30px 0; color: #6e6e73; font-size: 16px; line-height: 1.5; text-align: center;">
                Ingresa este código en la app para completar tu inicio de sesión:
              </p>
              
              <!-- Código destacado -->
              <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 16px; padding: 30px; text-align: center; margin: 30px 0;">
                <div style="background-color: rgba(255, 255, 255, 0.2); backdrop-filter: blur(10px); border-radius: 12px; padding: 20px; display: inline-block;">
                  <p style="margin: 0; color: #ffffff; font-size: 36px; font-weight: 700; letter-spacing: 8px; font-family: 'Courier New', monospace;">
                    {{ .Token }}
                  </p>
                </div>
              </div>
              
              <p style="margin: 20px 0 0 0; color: #6e6e73; font-size: 14px; line-height: 1.5; text-align: center;">
                O haz clic en el botón de abajo para iniciar sesión automáticamente:
              </p>
              
              <!-- Botón de acción -->
              <div style="text-align: center; margin: 30px 0;">
                <a href="{{ .ConfirmationURL }}" style="display: inline-block; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: #ffffff; text-decoration: none; padding: 16px 40px; border-radius: 12px; font-size: 16px; font-weight: 600; box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);">
                  Confirmar inicio de sesión
                </a>
              </div>
              
              <p style="margin: 30px 0 0 0; color: #86868b; font-size: 12px; line-height: 1.5; text-align: center;">
                Este código expirará en 1 hora. Si no solicitaste este código, puedes ignorar este correo.
              </p>
            </td>
          </tr>
          
          <!-- Footer -->
          <tr>
            <td style="padding: 30px; background-color: #f5f5f7; border-radius: 0 0 20px 20px; text-align: center;">
              <p style="margin: 0; color: #86868b; font-size: 12px;">
                © 2024 BOOP. Todos los derechos reservados.
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
*/

-- ============================================
-- NOTAS IMPORTANTES
-- ============================================
-- 
-- 1. Los magic links funcionan automáticamente si configuras:
--    - emailRedirectTo en signInWithOtp()
--    - Deep links en tu app (boop://auth/callback)
--
-- 2. Para códigos OTP numéricos, Supabase los envía automáticamente
--    cuando no se especifica emailRedirectTo o cuando se configura
--    el template de email como OTP
--
-- 3. El trigger handle_new_user() crea automáticamente un perfil
--    cuando un usuario se registra, así no necesitas hacerlo manualmente
--    desde la app
--
-- 4. Para usar el template con CSS:
--    - Ve a: Authentication > Email Templates > Magic Link
--    - Copia el HTML de arriba (sin los comentarios /* */)
--    - Pega en el campo "Body" del template
--    - Guarda los cambios

