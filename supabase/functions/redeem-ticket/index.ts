import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { qrCode } = await req.json()

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

    // Find ticket
    const { data: ticket, error: ticketError } = await supabaseClient
      .from('tickets')
      .select('*, events(*)')
      .eq('qr_code', qrCode)
      .single()

    if (ticketError || !ticket) {
      return new Response(
        JSON.stringify({ valid: false, message: 'Ticket no encontrado' }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 200,
        },
      )
    }

    // Check if already scanned
    if (ticket.is_scanned) {
      return new Response(
        JSON.stringify({ valid: false, message: 'Ticket ya utilizado' }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 200,
        },
      )
    }

    // Mark as scanned
    const { error: updateError } = await supabaseClient
      .from('tickets')
      .update({
        is_scanned: true,
        scanned_at: new Date().toISOString(),
      })
      .eq('id', ticket.id)

    if (updateError) {
      throw new Error(`Failed to mark ticket as scanned: ${updateError.message}`)
    }

    return new Response(
      JSON.stringify({ 
        valid: true, 
        message: 'Ticket válido',
        ticket: {
          id: ticket.id,
          eventTitle: ticket.events?.title,
        }
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      },
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400,
      },
    )
  }
})

