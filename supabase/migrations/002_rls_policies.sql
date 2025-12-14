-- Habilitar Row Level Security en todas las tablas
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.communities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.community_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.community_followers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.event_cohosts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ticket_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tickets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.friends ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.promo_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_devices ENABLE ROW LEVEL SECURITY;

-- Políticas para profiles
-- Los usuarios pueden ver todos los perfiles públicos
DROP POLICY IF EXISTS "Users can view all profiles" ON public.profiles;
CREATE POLICY "Users can view all profiles" ON public.profiles
    FOR SELECT USING (true);

-- Los usuarios solo pueden actualizar su propio perfil
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
CREATE POLICY "Users can update own profile" ON public.profiles
    FOR UPDATE USING (auth.uid() = user_id);

-- Los usuarios pueden insertar su propio perfil al registrarse
DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;
CREATE POLICY "Users can insert own profile" ON public.profiles
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Políticas para communities
-- Todos pueden ver comunidades públicas
DROP POLICY IF EXISTS "Anyone can view communities" ON public.communities;
CREATE POLICY "Anyone can view communities" ON public.communities
    FOR SELECT USING (true);

-- Solo los dueños pueden actualizar su comunidad
DROP POLICY IF EXISTS "Owners can update own community" ON public.communities;
CREATE POLICY "Owners can update own community" ON public.communities
    FOR UPDATE USING (auth.uid() = owner_user_id);

-- Cualquiera puede crear una comunidad
DROP POLICY IF EXISTS "Anyone can create community" ON public.communities;
CREATE POLICY "Anyone can create community" ON public.communities
    FOR INSERT WITH CHECK (auth.uid() = owner_user_id);

-- Políticas para community_members
DROP POLICY IF EXISTS "Anyone can view community members" ON public.community_members;
CREATE POLICY "Anyone can view community members" ON public.community_members
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "Community owners can manage members" ON public.community_members;
CREATE POLICY "Community owners can manage members" ON public.community_members
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.communities
            WHERE id = community_members.community_id
            AND owner_user_id = auth.uid()
        )
    );

-- Políticas para community_followers
DROP POLICY IF EXISTS "Anyone can view followers" ON public.community_followers;
CREATE POLICY "Anyone can view followers" ON public.community_followers
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "Users can follow/unfollow communities" ON public.community_followers;
CREATE POLICY "Users can follow/unfollow communities" ON public.community_followers
    FOR ALL USING (auth.uid() = user_id);

-- Funciones de seguridad para evitar recursión infinita en políticas RLS
-- Estas funciones se ejecutan con SECURITY DEFINER para evitar recursión

-- Función para verificar si un usuario puede ver un evento
CREATE OR REPLACE FUNCTION public.can_view_event(event_id UUID, user_uuid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    event_is_public BOOLEAN;
    event_created_by UUID;
    is_cohost BOOLEAN;
BEGIN
    -- Obtener información del evento sin usar políticas RLS
    SELECT is_public, created_by INTO event_is_public, event_created_by
    FROM public.events
    WHERE id = event_id;
    
    -- Si no existe el evento, retornar false
    IF event_created_by IS NULL THEN
        RETURN FALSE;
    END IF;
    
    -- Si es público o el creador, permitir
    IF event_is_public = true OR event_created_by = user_uuid THEN
        RETURN TRUE;
    END IF;
    
    -- Verificar si es co-host (usuario directo)
    SELECT EXISTS(
        SELECT 1 FROM public.event_cohosts
        WHERE event_cohosts.event_id = can_view_event.event_id
        AND event_cohosts.user_id = user_uuid
    ) INTO is_cohost;
    
    IF is_cohost THEN
        RETURN TRUE;
    END IF;
    
    -- Verificar si es miembro de una comunidad co-host
    SELECT EXISTS(
        SELECT 1 FROM public.event_cohosts ec
        INNER JOIN public.community_members cm ON cm.community_id = ec.community_id
        WHERE ec.event_id = can_view_event.event_id
        AND cm.user_id = user_uuid
        AND ec.community_id IS NOT NULL
    ) INTO is_cohost;
    
    RETURN is_cohost;
END;
$$;

-- Función para verificar si un usuario puede actualizar un evento
CREATE OR REPLACE FUNCTION public.can_update_event(event_id UUID, user_uuid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    event_created_by UUID;
    is_cohost BOOLEAN;
BEGIN
    -- Obtener el creador del evento
    SELECT created_by INTO event_created_by
    FROM public.events
    WHERE id = event_id;
    
    -- Si no existe el evento, retornar false
    IF event_created_by IS NULL THEN
        RETURN FALSE;
    END IF;
    
    -- Si es el creador, permitir
    IF event_created_by = user_uuid THEN
        RETURN TRUE;
    END IF;
    
    -- Verificar si es co-host (usuario directo)
    SELECT EXISTS(
        SELECT 1 FROM public.event_cohosts
        WHERE event_cohosts.event_id = can_update_event.event_id
        AND event_cohosts.user_id = user_uuid
    ) INTO is_cohost;
    
    IF is_cohost THEN
        RETURN TRUE;
    END IF;
    
    -- Verificar si es miembro de una comunidad co-host
    SELECT EXISTS(
        SELECT 1 FROM public.event_cohosts ec
        INNER JOIN public.community_members cm ON cm.community_id = ec.community_id
        WHERE ec.event_id = can_update_event.event_id
        AND cm.user_id = user_uuid
        AND ec.community_id IS NOT NULL
    ) INTO is_cohost;
    
    RETURN is_cohost;
END;
$$;

-- Función para verificar si un usuario puede gestionar co-hosts
CREATE OR REPLACE FUNCTION public.can_manage_cohosts(event_id UUID, user_uuid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    event_created_by UUID;
BEGIN
    -- Obtener el creador del evento directamente sin usar políticas RLS
    SELECT created_by INTO event_created_by
    FROM public.events
    WHERE id = event_id;
    
    -- Solo el creador puede gestionar co-hosts
    RETURN event_created_by = user_uuid;
END;
$$;

-- Otorgar permisos necesarios a las funciones
GRANT EXECUTE ON FUNCTION public.can_view_event(UUID, UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.can_view_event(UUID, UUID) TO anon;
GRANT EXECUTE ON FUNCTION public.can_update_event(UUID, UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.can_manage_cohosts(UUID, UUID) TO authenticated;

-- Políticas para events
-- Todos pueden ver eventos públicos o eventos donde son organizadores
-- Usa funciones de seguridad para evitar recursión infinita
DROP POLICY IF EXISTS "Anyone can view public events" ON public.events;
CREATE POLICY "Anyone can view public events" ON public.events
    FOR SELECT USING (
        is_public = true 
        OR created_by = auth.uid()
        OR public.can_view_event(id, auth.uid())
    );

-- Solo organizadores pueden crear eventos
DROP POLICY IF EXISTS "Organizers can create events" ON public.events;
CREATE POLICY "Organizers can create events" ON public.events
    FOR INSERT WITH CHECK (auth.uid() = created_by);

-- Solo creadores y co-hosts pueden actualizar eventos
-- Usa funciones de seguridad para evitar recursión infinita
DROP POLICY IF EXISTS "Organizers can update events" ON public.events;
CREATE POLICY "Organizers can update events" ON public.events
    FOR UPDATE USING (
        created_by = auth.uid()
        OR public.can_update_event(id, auth.uid())
    );

-- Políticas para event_cohosts
DROP POLICY IF EXISTS "Anyone can view cohosts" ON public.event_cohosts;
CREATE POLICY "Anyone can view cohosts" ON public.event_cohosts
    FOR SELECT USING (true);

-- Usa funciones de seguridad para evitar recursión infinita
DROP POLICY IF EXISTS "Event creators can manage cohosts" ON public.event_cohosts;
CREATE POLICY "Event creators can manage cohosts" ON public.event_cohosts
    FOR ALL USING (
        public.can_manage_cohosts(event_id, auth.uid())
    );

-- Políticas para ticket_types
DROP POLICY IF EXISTS "Anyone can view ticket types for public events" ON public.ticket_types;
CREATE POLICY "Anyone can view ticket types for public events" ON public.ticket_types
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.events
            WHERE id = ticket_types.event_id
            AND (is_public = true OR created_by = auth.uid())
        )
    );

DROP POLICY IF EXISTS "Organizers can manage ticket types" ON public.ticket_types;
CREATE POLICY "Organizers can manage ticket types" ON public.ticket_types
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.events
            WHERE id = ticket_types.event_id
            AND created_by = auth.uid()
        )
    );

-- Políticas para orders
-- Los usuarios solo pueden ver sus propias órdenes
DROP POLICY IF EXISTS "Users can view own orders" ON public.orders;
CREATE POLICY "Users can view own orders" ON public.orders
    FOR SELECT USING (auth.uid() = user_id);

-- Los organizadores pueden ver órdenes de sus eventos
DROP POLICY IF EXISTS "Organizers can view event orders" ON public.orders;
CREATE POLICY "Organizers can view event orders" ON public.orders
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.events
            WHERE id = orders.event_id
            AND created_by = auth.uid()
        )
    );

-- Los usuarios pueden crear sus propias órdenes
DROP POLICY IF EXISTS "Users can create own orders" ON public.orders;
CREATE POLICY "Users can create own orders" ON public.orders
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Políticas para tickets
-- Los usuarios pueden ver sus propios tickets
DROP POLICY IF EXISTS "Users can view own tickets" ON public.tickets;
CREATE POLICY "Users can view own tickets" ON public.tickets
    FOR SELECT USING (auth.uid() = owner_user_id);

-- Los organizadores pueden ver tickets de sus eventos
DROP POLICY IF EXISTS "Organizers can view event tickets" ON public.tickets;
CREATE POLICY "Organizers can view event tickets" ON public.tickets
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.events
            WHERE id = tickets.event_id
            AND created_by = auth.uid()
        )
    );

-- Políticas para friends
-- Los usuarios pueden ver sus propias relaciones de amistad
DROP POLICY IF EXISTS "Users can view own friendships" ON public.friends;
CREATE POLICY "Users can view own friendships" ON public.friends
    FOR SELECT USING (
        auth.uid() = user_id OR auth.uid() = friend_user_id
    );

DROP POLICY IF EXISTS "Users can manage own friendships" ON public.friends;
CREATE POLICY "Users can manage own friendships" ON public.friends
    FOR ALL USING (auth.uid() = user_id);

-- Políticas para posts
-- Todos pueden ver posts públicos
DROP POLICY IF EXISTS "Anyone can view posts" ON public.posts;
CREATE POLICY "Anyone can view posts" ON public.posts
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "Users can create posts" ON public.posts;
CREATE POLICY "Users can create posts" ON public.posts
    FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own posts" ON public.posts;
CREATE POLICY "Users can update own posts" ON public.posts
    FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own posts" ON public.posts;
CREATE POLICY "Users can delete own posts" ON public.posts
    FOR DELETE USING (auth.uid() = user_id);

-- Políticas para promo_codes
DROP POLICY IF EXISTS "Anyone can view promo codes for public events" ON public.promo_codes;
CREATE POLICY "Anyone can view promo codes for public events" ON public.promo_codes
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.events
            WHERE id = promo_codes.event_id
            AND (is_public = true OR created_by = auth.uid())
        )
    );

DROP POLICY IF EXISTS "Organizers can manage promo codes" ON public.promo_codes;
CREATE POLICY "Organizers can manage promo codes" ON public.promo_codes
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.events
            WHERE id = promo_codes.event_id
            AND created_by = auth.uid()
        )
    );

-- Políticas para user_devices
DROP POLICY IF EXISTS "Users can manage own devices" ON public.user_devices;
CREATE POLICY "Users can manage own devices" ON public.user_devices
    FOR ALL USING (auth.uid() = user_id);

