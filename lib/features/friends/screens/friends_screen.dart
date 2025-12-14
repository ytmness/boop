import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/friends_provider.dart';
import '../../../shared/widgets/profile_avatar.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../routes/route_names.dart';

class FriendsScreen extends ConsumerWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Amigos'),
        ),
        child: Center(child: Text('Debes iniciar sesión')),
      );
    }

    final friendsAsync = ref.watch(friendsProvider(user.id));
    final pendingRequestsAsync = ref.watch(pendingRequestsProvider(user.id));

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Amigos'),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                ref.invalidate(friendsProvider(user.id));
                ref.invalidate(pendingRequestsProvider(user.id));
              },
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.friends);
                        // TODO: Navegar a solicitudes pendientes
                      },
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.person_add),
                          const SizedBox(width: 8),
                          const Text('Solicitudes pendientes'),
                          const Spacer(),
                          pendingRequestsAsync.when(
                            data: (requests) => requests.isEmpty
                                ? const SizedBox.shrink()
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.systemRed,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${requests.length}',
                                      style: const TextStyle(
                                        color: CupertinoColors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                          ),
                          const Icon(
                            CupertinoIcons.chevron_right,
                            size: 18,
                            color: CupertinoColors.secondaryLabel,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Mis amigos',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    friendsAsync.when(
                      data: (friends) => friends.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text(
                                'No tienes amigos aún',
                                style: TextStyle(
                                  color: CupertinoColors.secondaryLabel,
                                ),
                              ),
                            )
                          : Column(
                              children: friends.map((friend) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.secondarySystemBackground,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      ProfileAvatar(
                                        imageUrl: friend.avatarUrl,
                                        name: friend.name,
                                        radius: 30,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          friend.name ?? 'Usuario',
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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

