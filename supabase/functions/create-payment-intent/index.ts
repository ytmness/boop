import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { eventId, userId, ticketTypeId, quantity, promoCode } = await req.json()

    // Create Supabase client
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

    // Verify user is authenticated
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      throw new Error('No authorization header')
    }

    // Get ticket type details
    const { data: ticketType, error: ticketError } = await supabaseClient
      .from('ticket_types')
      .select('*')
      .eq('id', ticketTypeId)
      .single()

    if (ticketError || !ticketType) {
      throw new Error('Ticket type not found')
    }

    // Check availability
    if (ticketType.quantity_sold + quantity > ticketType.quantity_total) {
      throw new Error('Not enough tickets available')
    }

    // Calculate amount
    let amount = ticketType.price * quantity

    // Apply promo code if provided
    if (promoCode) {
      const { data: promo, error: promoError } = await supabaseClient
        .from('promo_codes')
        .select('*')
        .eq('code', promoCode)
        .eq('event_id', eventId)
        .single()

      if (!promoError && promo) {
        if (promo.uses < (promo.max_uses || 999999) && 
            (!promo.expires_at || new Date(promo.expires_at) > new Date())) {
          if (promo.discount_type === 'percent') {
            amount = amount * (1 - promo.discount_value / 100)
          } else {
            amount = amount - promo.discount_value
          }
          amount = Math.max(0, amount)
        }
      }
    }

    // Create Stripe Payment Intent
    const stripeSecretKey = Deno.env.get('STRIPE_SECRET_KEY')
    if (!stripeSecretKey) {
      throw new Error('Stripe secret key not configured')
    }

    const response = await fetch('https://api.stripe.com/v1/payment_intents', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${stripeSecretKey}`,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: new URLSearchParams({
        amount: Math.round(amount * 100).toString(), // Convert to cents
        currency: ticketType.currency || 'usd',
        metadata: JSON.stringify({
          eventId,
          userId,
          ticketTypeId,
          quantity,
        }),
      }),
    })

    const paymentIntent = await response.json()

    if (!response.ok) {
      throw new Error(paymentIntent.error?.message || 'Failed to create payment intent')
    }

    return new Response(
      JSON.stringify({ clientSecret: paymentIntent.client_secret }),
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

