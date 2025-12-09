import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../routes/route_names.dart';
import '../../../shared/widgets/profile_avatar.dart';
import '../providers/profile_provider.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);
    final authService = ref.watch(authServiceProvider);
    final user = authService.currentUser;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Perfil'),
      ),
      child: SafeArea(
        child: profileAsync.when(
          data: (profile) {
            if (profile == null) {
              return const Center(child: Text('Error al cargar perfil'));
            }

            return CustomScrollView(
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    ref.invalidate(currentProfileProvider);
                  },
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        ProfileAvatar(
                          imageUrl: profile.avatarUrl,
                          name: profile.name,
                          radius: 50,
                          showBorder: true,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          profile.name ?? 'Usuario',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            profile.bio!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: CupertinoColors.secondaryLabel,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        if (profile.city != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                CupertinoIcons.location,
                                size: 16,
                                color: CupertinoColors.secondaryLabel,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                profile.city!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: CupertinoColors.secondaryLabel,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              user?.email != null
                                  ? CupertinoIcons.mail
                                  : CupertinoIcons.phone,
                              size: 16,
                              color: CupertinoColors.secondaryLabel,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              user?.email ?? user?.phone ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                            if (profile.isVerified) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                CupertinoIcons.check_mark_circled_solid,
                                size: 16,
                                color: CupertinoColors.systemGreen,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 32),
                        _buildSection(
                          context,
                          'Configuración',
                          [
                            _buildMenuItem(
                              context,
                              'Editar perfil',
                              CupertinoIcons.person,
                              () {
                                Navigator.pushNamed(
                                    context, RouteNames.settings);
                              },
                            ),
                            _buildMenuItem(
                              context,
                              'Notificaciones',
                              CupertinoIcons.bell,
                              () {
                                // TODO: Navegar a configuración de notificaciones
                              },
                            ),
                            _buildMenuItem(
                              context,
                              'Privacidad',
                              CupertinoIcons.lock,
                              () {
                                // TODO: Navegar a configuración de privacidad
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSection(
                          context,
                          'Comunidad',
                          [
                            _buildMenuItem(
                              context,
                              'Mis comunidades',
                              CupertinoIcons.group,
                              () {
                                Navigator.pushNamed(
                                    context, RouteNames.communities);
                              },
                            ),
                            _buildMenuItem(
                              context,
                              'Amigos',
                              CupertinoIcons.person_2,
                              () {
                                Navigator.pushNamed(
                                    context, RouteNames.friends);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        CupertinoButton(
                          color: CupertinoColors.destructiveRed,
                          onPressed: () async {
                            final shouldLogout =
                                await showCupertinoDialog<bool>(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: const Text('Cerrar sesión'),
                                content: const Text(
                                    '¿Estás seguro de que quieres cerrar sesión?'),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text('Cancelar'),
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    child: const Text('Cerrar sesión'),
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                  ),
                                ],
                              ),
                            );

                            if (shouldLogout == true) {
                              await authService.signOut();
                              if (context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RouteNames.onboarding,
                                  (route) => false,
                                );
                              }
                            }
                          },
                          child: const Text('Cerrar sesión'),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CupertinoActivityIndicator(),
          ),
          error: (error, stack) => Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: CupertinoColors.secondarySystemBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onPressed: onTap,
      child: Row(
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 17),
            ),
          ),
          const Icon(
            CupertinoIcons.chevron_right,
            size: 18,
            color: CupertinoColors.secondaryLabel,
          ),
        ],
      ),
    );
  }
}
