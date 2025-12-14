import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/communities_provider.dart';
import '../../../shared/widgets/community_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../../routes/route_names.dart';

class CommunitiesScreen extends ConsumerWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final profileAsync = ref.watch(currentProfileProvider);
    final city = profileAsync.valueOrNull?.city;

    final communitiesAsync = ref.watch(
      communitiesByCityProvider({
        'city': city,
        'limit': 20,
      }),
    );

    final followedCommunitiesAsync = user != null
        ? ref.watch(userFollowedCommunitiesProvider(user.id))
        : null;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Comunidades'),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                ref.invalidate(communitiesByCityProvider({
                  'city': city,
                  'limit': 20,
                }));
                if (user != null) {
                  ref.invalidate(userFollowedCommunitiesProvider(user.id));
                }
              },
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (followedCommunitiesAsync != null) ...[
                      const SectionHeader(title: 'Mis comunidades'),
                      const SizedBox(height: 16),
                      followedCommunitiesAsync.when(
                        data: (communities) => communities.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'No sigues ninguna comunidad',
                                  style: TextStyle(
                                    color: CupertinoColors.secondaryLabel,
                                  ),
                                ),
                              )
                            : Column(
                                children: communities.map((community) {
                                  return CommunityCard(
                                    community: community,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteNames.communityDetailPath(community.id),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                        loading: () => const CupertinoActivityIndicator(),
                        error: (error, stack) => Text('Error: $error'),
                      ),
                      const SizedBox(height: 32),
                    ],
                    const SectionHeader(title: 'Explorar comunidades'),
                    const SizedBox(height: 16),
                    communitiesAsync.when(
                      data: (communities) => communities.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'No hay comunidades disponibles',
                                style: TextStyle(
                                  color: CupertinoColors.secondaryLabel,
                                ),
                              ),
                            )
                          : Column(
                              children: communities.map((community) {
                                return CommunityCard(
                                  community: community,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.communityDetailPath(community.id),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                      loading: () => const CupertinoActivityIndicator(),
                      error: (error, stack) => Text('Error: $error'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

