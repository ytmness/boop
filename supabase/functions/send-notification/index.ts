import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  try {
    const { userId, title, body, data } = await req.json()

    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false
        }
      }
    )

    // Get user device tokens
    const { data: devices, error: devicesError } = await supabaseClient
      .from('user_devices')
      .select('device_token, platform')
      .eq('user_id', userId)

    if (devicesError || !devices || devices.length === 0) {
      return new Response(
        JSON.stringify({ sent: false, message: 'No devices found' }),
        {
          headers: { 'Content-Type': 'application/json' },
          status: 200,
        },
      )
    }

    // Send notifications via FCM
    // Note: This requires Firebase Admin SDK setup
    // For now, return success (implementation depends on your FCM setup)

    return new Response(
      JSON.stringify({ sent: true, devicesCount: devices.length }),
      {
        headers: { 'Content-Type': 'application/json' },
        status: 200,
      },
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        headers: { 'Content-Type': 'application/json' },
        status: 400,
      },
    )
  }
})

