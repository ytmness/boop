-- ============================================
-- CREAR TABLA EVENT_MEDIA Y POLICIES
-- ============================================

-- Tabla para múltiples fotos/videos por evento
CREATE TABLE IF NOT EXISTS public.event_media (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  event_id uuid NOT NULL REFERENCES public.events(id) ON DELETE CASCADE,
  type text NOT NULL CHECK (type IN ('image','video')),
  url text NOT NULL,
  thumbnail_url text,
  sort_order int DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

-- Índice para búsquedas rápidas
CREATE INDEX IF NOT EXISTS event_media_event_id_idx ON public.event_media(event_id);

-- RLS para event_media
ALTER TABLE public.event_media ENABLE ROW LEVEL SECURITY;

-- SELECT: usuarios autenticados pueden ver media de eventos públicos o propios
CREATE POLICY "media_select_auth"
ON public.event_media
FOR SELECT 
TO authenticated
USING (true);

-- INSERT/UPDATE/DELETE: solo el creador del evento
CREATE POLICY "media_write_owner"
ON public.event_media
FOR ALL 
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.events e
    WHERE e.id = event_media.event_id
      AND e.created_by = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.events e
    WHERE e.id = event_media.event_id
      AND e.created_by = auth.uid()
  )
);

-- ============================================
-- RLS PARA TICKET_TYPES
-- ============================================

-- Activar RLS si no está activado
ALTER TABLE public.ticket_types ENABLE ROW LEVEL SECURITY;

-- SELECT: usuarios autenticados pueden ver
DROP POLICY IF EXISTS "ticket_types_select_auth" ON public.ticket_types;
CREATE POLICY "ticket_types_select_auth"
ON public.ticket_types
FOR SELECT 
TO authenticated
USING (true);

-- INSERT/UPDATE/DELETE: solo el creador del evento
DROP POLICY IF EXISTS "ticket_types_write_owner" ON public.ticket_types;
CREATE POLICY "ticket_types_write_owner"
ON public.ticket_types
FOR ALL 
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.events e
    WHERE e.id = ticket_types.event_id
      AND e.created_by = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.events e
    WHERE e.id = ticket_types.event_id
      AND e.created_by = auth.uid()
  )
);

-- ============================================
-- FUNCIÓN RPC PARA COMPRA DE BOLETOS (TRANSACCIONAL)
-- ============================================

CREATE OR REPLACE FUNCTION public.purchase_tickets(
  p_event_id uuid,
  p_ticket_type_id uuid,
  p_quantity integer,
  p_user_id uuid
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_ticket_type record;
  v_order_id uuid;
  v_qr_code text;
  v_ticket_id uuid;
  v_result jsonb;
BEGIN
  -- Validar que el usuario esté autenticado
  IF p_user_id IS NULL OR p_user_id != auth.uid() THEN
    RAISE EXCEPTION 'Usuario no autenticado';
  END IF;

  -- Obtener información del ticket type
  SELECT * INTO v_ticket_type
  FROM public.ticket_types
  WHERE id = p_ticket_type_id
    AND event_id = p_event_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Tipo de boleto no encontrado';
  END IF;

  -- Validar disponibilidad
  IF (v_ticket_type.quantity_sold + p_quantity) > v_ticket_type.quantity_total THEN
    RAISE EXCEPTION 'No hay suficientes boletos disponibles';
  END IF;

  -- Validar límite por usuario
  IF v_ticket_type.max_per_user IS NOT NULL AND p_quantity > v_ticket_type.max_per_user THEN
    RAISE EXCEPTION 'Excede el límite de boletos por usuario';
  END IF;

  -- Validar fechas de venta
  IF v_ticket_type.sales_start IS NOT NULL AND NOW() < v_ticket_type.sales_start THEN
    RAISE EXCEPTION 'La venta aún no ha comenzado';
  END IF;

  IF v_ticket_type.sales_end IS NOT NULL AND NOW() > v_ticket_type.sales_end THEN
    RAISE EXCEPTION 'La venta ha terminado';
  END IF;

  -- Crear orden
  INSERT INTO public.orders (
    event_id,
    user_id,
    amount,
    currency,
    payment_status,
    payment_provider
  )
  VALUES (
    p_event_id,
    p_user_id,
    v_ticket_type.price * p_quantity,
    v_ticket_type.currency,
    'pending',
    'Stripe'
  )
  RETURNING id INTO v_order_id;

  -- Crear tickets y actualizar cantidad vendida
  FOR i IN 1..p_quantity LOOP
    -- Generar QR code único
    v_qr_code := p_event_id::text || '-' || p_ticket_type_id::text || '-' || p_user_id::text || '-' || i || '-' || gen_random_uuid()::text;
    
    -- Crear ticket
    INSERT INTO public.tickets (
      order_id,
      event_id,
      ticket_type_id,
      owner_user_id,
      qr_code
    )
    VALUES (
      v_order_id,
      p_event_id,
      p_ticket_type_id,
      p_user_id,
      v_qr_code
    )
    RETURNING id INTO v_ticket_id;
  END LOOP;

  -- Actualizar cantidad vendida
  UPDATE public.ticket_types
  SET quantity_sold = quantity_sold + p_quantity,
      updated_at = NOW()
  WHERE id = p_ticket_type_id;

  -- Retornar resultado
  v_result := jsonb_build_object(
    'order_id', v_order_id,
    'tickets_purchased', p_quantity,
    'total_amount', v_ticket_type.price * p_quantity,
    'currency', v_ticket_type.currency
  );

  RETURN v_result;
END;
$$;

-- Permitir ejecución a usuarios autenticados
GRANT EXECUTE ON FUNCTION public.purchase_tickets TO authenticated;
