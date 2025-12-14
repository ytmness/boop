import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../events/providers/events_provider.dart';
import '../../../shared/components/cards/glass_event_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/empty_events_placeholder.dart';
import '../../../routes/route_names.dart';
import '../../profile/providers/profile_provider.dart';
import '../../../core/branding/branding.dart';
import '../../../shared/widgets/blurred_video_background.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

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

    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: BlurredVideoBackground(
        child: SafeArea(
          top: false,
          child: CustomScrollView(
            slivers: [
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
                  padding: const EdgeInsets.all(Branding.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'Eventos destacados'),
                      const SizedBox(height: Branding.spacingM),
                      eventsAsync.when(
                        data: (events) {
                          debugPrint(
                              '✅ eventsAsync.when data - ${events.length} eventos');
                          if (events.isNotEmpty) {
                            debugPrint(
                                '📋 Primer evento: ${events.first.title} (ID: ${events.first.id})');
                          }
                          if (events.isEmpty) {
                            debugPrint('⚠️ Lista de eventos vacía');
                            return EmptyEventsPlaceholder(city: city);
                          }
                          debugPrint(
                              '🎨 Renderizando ListView con ${events.length} eventos');
                          return ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: events.map((event) {
                              debugPrint(
                                  '🎨 Creando GlassEventCard para: ${event.title}');
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
                        loading: () {
                          debugPrint('⏳ eventsAsync.when loading');
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(Branding.spacingXL),
                              child: CupertinoActivityIndicator(),
                            ),
                          );
                        },
                        error: (error, stack) {
                          debugPrint('❌ eventsAsync.when error: $error');
                          debugPrint('❌ Stack: $stack');
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(Branding.spacingXL),
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
                                    style: const TextStyle(
                                      color: CupertinoColors.systemRed,
                                      fontSize: Branding.fontSizeHeadline,
                                      fontWeight: Branding.weightSemibold,
                                    ),
                                  ),
                                  const SizedBox(height: Branding.spacingS),
                                  Text(
                                    error.toString(),
                                    style: const TextStyle(
                                      color: CupertinoColors.secondaryLabel,
                                      fontSize: Branding.fontSizeBody,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
