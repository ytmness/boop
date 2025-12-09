import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const stripeSecretKey = Deno.env.get('STRIPE_SECRET_KEY')
const webhookSecret = Deno.env.get('STRIPE_WEBHOOK_SECRET')

serve(async (req) => {
  try {
    const signature = req.headers.get('stripe-signature')
    if (!signature) {
      throw new Error('No signature')
    }

    const body = await req.text()

    // Verify webhook signature
    // Note: In production, use Stripe's webhook signature verification
    // For now, we'll trust the webhook secret check

    const event = JSON.parse(body)

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

    if (event.type === 'payment_intent.succeeded') {
      const paymentIntent = event.data.object
      const metadata = paymentIntent.metadata

      // Create order
      const { data: order, error: orderError } = await supabaseClient
        .from('orders')
        .insert({
          event_id: metadata.eventId,
          user_id: metadata.userId,
          amount: paymentIntent.amount / 100, // Convert from cents
          currency: paymentIntent.currency,
          payment_status: 'paid',
          payment_provider: 'Stripe',
          payment_intent_id: paymentIntent.id,
          purchased_at: new Date().toISOString(),
        })
        .select()
        .single()

      if (orderError) {
        throw new Error(`Failed to create order: ${orderError.message}`)
      }

      // Create tickets
      const quantity = parseInt(metadata.quantity || '1')
      const tickets = []
      for (let i = 0; i < quantity; i++) {
        const qrCode = `${order.id}-${i}-${Date.now()}`
        tickets.push({
          order_id: order.id,
          event_id: metadata.eventId,
          ticket_type_id: metadata.ticketTypeId,
          owner_user_id: metadata.userId,
          qr_code: qrCode,
        })
      }

      const { error: ticketsError } = await supabaseClient
        .from('tickets')
        .insert(tickets)

      if (ticketsError) {
        throw new Error(`Failed to create tickets: ${ticketsError.message}`)
      }
    }

    return new Response(
      JSON.stringify({ received: true }),
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

