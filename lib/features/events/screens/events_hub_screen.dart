import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import '../../../core/branding/branding.dart';
import '../../../shared/widgets/blurred_video_background.dart';
import '../../../shared/components/cards/glass_event_card.dart';
import '../../../shared/components/glass/glass_container.dart';
import '../../../shared/components/navigation/glass_bottom_nav_bar.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/empty_events_placeholder.dart';
import '../../../routes/route_names.dart';
import '../../profile/providers/profile_provider.dart';
import '../../events/providers/events_provider.dart';
import '../../../shared/widgets/profile_avatar.dart';

class EventsHubScreen extends ConsumerStatefulWidget {
  const EventsHubScreen({super.key});

  @override
  ConsumerState<EventsHubScreen> createState() => _EventsHubScreenState();
}

class _EventsHubScreenState extends ConsumerState<EventsHubScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Ya estamos en eventos
        break;
      case 1:
        Navigator.pushNamed(context, RouteNames.search);
        break;
      case 2:
        Navigator.pushNamed(context, RouteNames.createEvent);
        break;
      case 3:
        Navigator.pushNamed(context, RouteNames.activity);
        break;
      case 4:
        Navigator.pushNamed(context, RouteNames.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlurredVideoBackground(
        child: SafeArea(
          top: false,
          bottom: false,
          child: Column(
            children: [
              Expanded(child: EventsHubScreenContent()),
              GlassBottomNavBar(
                currentIndex: _currentIndex,
                onTap: _onNavTap,
                items: const [
                  BottomNavItem(
                    icon: CupertinoIcons.home,
                    activeIcon: CupertinoIcons.house_fill,
                    label: 'Inicio',
                  ),
                  BottomNavItem(
                    icon: CupertinoIcons.search,
                    activeIcon: CupertinoIcons.search,
                    label: 'Buscar',
                  ),
                  BottomNavItem(
                    icon: CupertinoIcons.add_circled,
                    activeIcon: CupertinoIcons.add_circled_solid,
                    label: 'Crear',
                  ),
                  BottomNavItem(
                    icon: CupertinoIcons.bell,
                    activeIcon: CupertinoIcons.bell_fill,
                    label: 'Actividad',
                  ),
                  BottomNavItem(
                    icon: CupertinoIcons.person,
                    activeIcon: CupertinoIcons.person_fill,
                    label: 'Perfil',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Contenido del hub de eventos sin el bottom nav bar (para usar en tabs)
class EventsHubScreenContent extends ConsumerWidget {
  const EventsHubScreenContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);
    final city = profileAsync.valueOrNull?.city;

    // Usar un provider estable para evitar recreaciones innecesarias
    final eventsAsync = ref.watch(
      publicEventsProvider(
        EventsQueryParams(
          city: city,
          limit: 20,
          offset: 0,
        ),
      ),
    );

    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Branding.spacingM,
              Branding.spacingL,
              Branding.spacingM,
              Branding.spacingM,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar del usuario
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'BOOP',
                      style: TextStyle(
                        fontSize: Branding.fontSizeTitle1,
                        fontWeight: Branding.weightBold,
                        letterSpacing: -0.5,
                        color: isDark
                            ? CupertinoColors.white
                            : CupertinoColors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteNames.profile,
                        );
                      },
                      child: profileAsync.when(
                        data: (profile) => GlassContainer(
                          borderRadius: Branding.radiusRound,
                          padding: EdgeInsets.zero,
                          child: ProfileAvatar(
                            imageUrl: profile?.avatarUrl,
                            name: profile?.name,
                            radius: 24,
                            showBorder: false,
                          ),
                        ),
                        loading: () => GlassContainer(
                          width: 48,
                          height: 48,
                          borderRadius: Branding.radiusRound,
                          padding: EdgeInsets.zero,
                          child: const Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
                        error: (_, __) => GlassContainer(
                          width: 48,
                          height: 48,
                          borderRadius: Branding.radiusRound,
                          padding: EdgeInsets.zero,
                          child: Icon(
                            CupertinoIcons.person,
                            color: isDark
                                ? CupertinoColors.white
                                : CupertinoColors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Branding.spacingXL),
                // Título de bienvenida
                Text(
                  'Descubre eventos',
                  style: TextStyle(
                    fontSize: Branding.fontSizeLargeTitle,
                    fontWeight: Branding.weightBold,
                    letterSpacing: -0.8,
                    color:
                        isDark ? CupertinoColors.white : CupertinoColors.black,
                  ),
                ),
                const SizedBox(height: Branding.spacingS),
                Text(
                  city != null
                      ? 'Eventos cerca de ti en $city'
                      : 'Explora eventos increíbles',
                  style: TextStyle(
                    fontSize: Branding.fontSizeSubhead,
                    color: isDark
                        ? CupertinoColors.white.withOpacity(0.7)
                        : CupertinoColors.black.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Lista de eventos
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            ref.invalidate(publicEventsProvider(
              EventsQueryParams(
                city: city,
                limit: 20,
                offset: 0,
              ),
            ));
            ref.invalidate(currentProfileProvider);
          },
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Branding.spacingM,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Eventos destacados'),
                const SizedBox(height: Branding.spacingM),
                eventsAsync.when(
                  data: (events) {
                    if (events.isEmpty) {
                      return EmptyEventsPlaceholder(
                        city: city,
                        onCreateEvent: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.createEvent,
                          );
                        },
                      );
                    }
                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: events.map((event) {
                        return GlassEventCard(
                          key: ValueKey(event.id),
                          event: event,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.eventDetailPath(event.id),
                            );
                          },
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(Branding.spacingXL),
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(
                        Branding.spacingXL,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            CupertinoIcons.exclamationmark_triangle,
                            color: CupertinoColors.systemRed,
                            size: 48,
                          ),
                          const SizedBox(height: Branding.spacingM),
                          Text(
                            'Error al cargar eventos',
                            style: TextStyle(
                              color: CupertinoColors.systemRed,
                              fontSize: Branding.fontSizeHeadline,
                              fontWeight: Branding.weightSemibold,
                            ),
                          ),
                          const SizedBox(height: Branding.spacingS),
                          Text(
                            error.toString(),
                            style: TextStyle(
                              color: CupertinoColors.secondaryLabel,
                              fontSize: Branding.fontSizeBody,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Branding.spacingXL +
                      MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
