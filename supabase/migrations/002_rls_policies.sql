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
CREATE POLICY "Users can view all profiles" ON public.profiles
    FOR SELECT USING (true);

-- Los usuarios solo pueden actualizar su propio perfil
CREATE POLICY "Users can update own profile" ON public.profiles
    FOR UPDATE USING (auth.uid() = user_id);

-- Los usuarios pueden insertar su propio perfil al registrarse
CREATE POLICY "Users can insert own profile" ON public.profiles
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Políticas para communities
-- Todos pueden ver comunidades públicas
CREATE POLICY "Anyone can view communities" ON public.communities
    FOR SELECT USING (true);

-- Solo los dueños pueden actualizar su comunidad
CREATE POLICY "Owners can update own community" ON public.communities
    FOR UPDATE USING (auth.uid() = owner_user_id);

-- Cualquiera puede crear una comunidad
CREATE POLICY "Anyone can create community" ON public.communities
    FOR INSERT WITH CHECK (auth.uid() = owner_user_id);

-- Políticas para community_members
CREATE POLICY "Anyone can view community members" ON public.community_members
    FOR SELECT USING (true);

CREATE POLICY "Community owners can manage members" ON public.community_members
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.communities
            WHERE id = community_members.community_id
            AND owner_user_id = auth.uid()
        )
    );

-- Políticas para community_followers
CREATE POLICY "Anyone can view followers" ON public.community_followers
    FOR SELECT USING (true);

CREATE POLICY "Users can follow/unfollow communities" ON public.community_followers
    FOR ALL USING (auth.uid() = user_id);

-- Políticas para events
-- Todos pueden ver eventos públicos o eventos donde son organizadores
CREATE POLICY "Anyone can view public events" ON public.events
    FOR SELECT USING (
        is_public = true OR
        created_by = auth.uid() OR
        EXISTS (
            SELECT 1 FROM public.event_cohosts
            WHERE event_id = events.id
            AND (user_id = auth.uid() OR community_id IN (
                SELECT community_id FROM public.community_members
                WHERE user_id = auth.uid()
            ))
        )
    );

-- Solo organizadores pueden crear eventos
CREATE POLICY "Organizers can create events" ON public.events
    FOR INSERT WITH CHECK (auth.uid() = created_by);

-- Solo creadores y co-hosts pueden actualizar eventos
CREATE POLICY "Organizers can update events" ON public.events
    FOR UPDATE USING (
        created_by = auth.uid() OR
        EXISTS (
            SELECT 1 FROM public.event_cohosts
            WHERE event_id = events.id
            AND (user_id = auth.uid() OR community_id IN (
                SELECT community_id FROM public.community_members
                WHERE user_id = auth.uid()
            ))
        )
    );

-- Políticas para event_cohosts
CREATE POLICY "Anyone can view cohosts" ON public.event_cohosts
    FOR SELECT USING (true);

CREATE POLICY "Event creators can manage cohosts" ON public.event_cohosts
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.events
            WHERE id = event_cohosts.event_id
            AND created_by = auth.uid()
        )
    );

-- Políticas para ticket_types
CREATE POLICY "Anyone can view ticket types for public events" ON public.ticket_types
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.events
            WHERE id = ticket_types.event_id
            AND (is_public = true OR created_by = auth.uid())
        )
    );

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
CREATE POLICY "Users can view own orders" ON public.orders
    FOR SELECT USING (auth.uid() = user_id);

-- Los organizadores pueden ver órdenes de sus eventos
CREATE POLICY "Organizers can view event orders" ON public.orders
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.events
            WHERE id = orders.event_id
            AND created_by = auth.uid()
        )
    );

-- Los usuarios pueden crear sus propias órdenes
CREATE POLICY "Users can create own orders" ON public.orders
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Políticas para tickets
-- Los usuarios pueden ver sus propios tickets
CREATE POLICY "Users can view own tickets" ON public.tickets
    FOR SELECT USING (auth.uid() = owner_user_id);

-- Los organizadores pueden ver tickets de sus eventos
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
CREATE POLICY "Users can view own friendships" ON public.friends
    FOR SELECT USING (
        auth.uid() = user_id OR auth.uid() = friend_user_id
    );

CREATE POLICY "Users can manage own friendships" ON public.friends
    FOR ALL USING (auth.uid() = user_id);

-- Políticas para posts
-- Todos pueden ver posts públicos
CREATE POLICY "Anyone can view posts" ON public.posts
    FOR SELECT USING (true);

CREATE POLICY "Users can create posts" ON public.posts
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own posts" ON public.posts
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own posts" ON public.posts
    FOR DELETE USING (auth.uid() = user_id);

-- Políticas para promo_codes
CREATE POLICY "Anyone can view promo codes for public events" ON public.promo_codes
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.events
            WHERE id = promo_codes.event_id
            AND (is_public = true OR created_by = auth.uid())
        )
    );

CREATE POLICY "Organizers can manage promo codes" ON public.promo_codes
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.events
            WHERE id = promo_codes.event_id
            AND created_by = auth.uid()
        )
    );

-- Políticas para user_devices
CREATE POLICY "Users can manage own devices" ON public.user_devices
    FOR ALL USING (auth.uid() = user_id);

