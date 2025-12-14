-- Función para incrementar vistas de eventos
CREATE OR REPLACE FUNCTION increment_event_views(event_id UUID)
RETURNS void AS $$
BEGIN
    UPDATE public.events
    SET views_count = views_count + 1
    WHERE id = event_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

