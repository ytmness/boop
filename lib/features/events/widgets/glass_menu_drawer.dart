import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/branding/branding.dart';
import '../../../shared/components/glass/glass_container.dart';
import '../../../shared/widgets/profile_avatar.dart';
import '../../../routes/route_names.dart';
import '../../profile/providers/profile_provider.dart';
import '../../auth/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlassMenuDrawer extends ConsumerWidget {
  final VoidCallback onClose;
  final dynamic user;

  const GlassMenuDrawer({
    super.key,
    required this.onClose,
    this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);
    final authService = ref.watch(authServiceProvider);
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return GlassContainer(
      borderRadius: 0,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: SafeArea(
        child: Column(
          children: [
            // Header del menú
            Padding(
              padding: const EdgeInsets.all(Branding.spacingM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menú',
                    style: TextStyle(
                      fontSize: Branding.fontSizeTitle2,
                      fontWeight: Branding.weightBold,
                      color: isDark
                          ? CupertinoColors.white
                          : CupertinoColors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Branding.radiusSmall,
                        ),
                        color: isDark
                            ? CupertinoColors.white.withOpacity(0.1)
                            : CupertinoColors.black.withOpacity(0.05),
                      ),
                      child: Icon(
                        CupertinoIcons.xmark,
                        size: 18,
                        color: isDark
                            ? CupertinoColors.white
                            : CupertinoColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              color: CupertinoColors.separator,
            ),
            // Perfil del usuario
            Padding(
              padding: const EdgeInsets.all(Branding.spacingM),
              child: profileAsync.when(
                data: (profile) {
                  if (profile == null) {
                    return const SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: () {
                      onClose();
                      Navigator.pushNamed(context, RouteNames.profile);
                    },
                    child: Row(
                      children: [
                        ProfileAvatar(
                          imageUrl: profile.avatarUrl,
                          name: profile.name,
                          radius: 32,
                          showBorder: true,
                        ),
                        const SizedBox(width: Branding.spacingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.name ?? 'Usuario',
                                style: TextStyle(
                                  fontSize: Branding.fontSizeHeadline,
                                  fontWeight: Branding.weightSemibold,
                                  color: isDark
                                      ? CupertinoColors.white
                                      : CupertinoColors.black,
                                ),
                              ),
                              if (profile.city != null) ...[
                                const SizedBox(height: Branding.spacingXS),
                                Text(
                                  profile.city!,
                                  style: TextStyle(
                                    fontSize: Branding.fontSizeCaption1,
                                    color: isDark
                                        ? CupertinoColors.white.withOpacity(0.6)
                                        : CupertinoColors.black
                                            .withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Icon(
                          CupertinoIcons.chevron_right,
                          size: 18,
                          color: isDark
                              ? CupertinoColors.white.withOpacity(0.5)
                              : CupertinoColors.black.withOpacity(0.4),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(Branding.spacingM),
                  child: CupertinoActivityIndicator(),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
            const Divider(
              height: 1,
              color: CupertinoColors.separator,
            ),
            // Opciones del menú
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: Branding.spacingS,
                ),
                children: [
                  _buildMenuItem(
                    context,
                    icon: CupertinoIcons.calendar,
                    title: 'Mis eventos',
                    onTap: () {
                      onClose();
                      Navigator.pushNamed(context, RouteNames.myEvents);
                    },
                    isDark: isDark,
                  ),
                  _buildMenuItem(
                    context,
                    icon: CupertinoIcons.search,
                    title: 'Buscar',
                    onTap: () {
                      onClose();
                      Navigator.pushNamed(context, RouteNames.search);
                    },
                    isDark: isDark,
                  ),
                  _buildMenuItem(
                    context,
                    icon: CupertinoIcons.bell,
                    title: 'Actividad',
                    onTap: () {
                      onClose();
                      Navigator.pushNamed(context, RouteNames.activity);
                    },
                    isDark: isDark,
                  ),
                  _buildMenuItem(
                    context,
                    icon: CupertinoIcons.group,
                    title: 'Comunidades',
                    onTap: () {
                      onClose();
                      Navigator.pushNamed(context, RouteNames.communities);
                    },
                    isDark: isDark,
                  ),
                  _buildMenuItem(
                    context,
                    icon: CupertinoIcons.person_2,
                    title: 'Amigos',
                    onTap: () {
                      onClose();
                      Navigator.pushNamed(context, RouteNames.friends);
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(height: Branding.spacingM),
                  const Divider(
                    height: 1,
                    color: CupertinoColors.separator,
                  ),
                  const SizedBox(height: Branding.spacingM),
                  _buildMenuItem(
                    context,
                    icon: CupertinoIcons.settings,
                    title: 'Configuración',
                    onTap: () {
                      onClose();
                      Navigator.pushNamed(context, RouteNames.settings);
                    },
                    isDark: isDark,
                  ),
                  _buildMenuItem(
                    context,
                    icon: CupertinoIcons.question_circle,
                    title: 'Ayuda y soporte',
                    onTap: () {
                      onClose();
                      Navigator.pushNamed(context, RouteNames.support);
                    },
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            // Botón de cerrar sesión
            Padding(
              padding: const EdgeInsets.all(Branding.spacingM),
              child: GestureDetector(
                onTap: () async {
                  final shouldLogout = await showCupertinoDialog<bool>(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Cerrar sesión'),
                      content: const Text(
                        '¿Estás seguro de que quieres cerrar sesión?',
                      ),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('Cancelar'),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          child: const Text('Cerrar sesión'),
                          onPressed: () => Navigator.pop(context, true),
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
                child: GlassContainer(
                  borderRadius: Branding.radiusMedium,
                  padding: const EdgeInsets.all(Branding.spacingM),
                  backgroundColor: CupertinoColors.destructiveRed
                      .withOpacity(isDark ? 0.2 : 0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.square_arrow_right,
                        color: CupertinoColors.destructiveRed,
                        size: 20,
                      ),
                      const SizedBox(width: Branding.spacingS),
                      Text(
                        'Cerrar sesión',
                        style: TextStyle(
                          fontSize: Branding.fontSizeHeadline,
                          fontWeight: Branding.weightSemibold,
                          color: CupertinoColors.destructiveRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: Branding.spacingM,
          vertical: Branding.spacingXS,
        ),
        child: GlassContainer(
          borderRadius: Branding.radiusMedium,
          padding: const EdgeInsets.all(Branding.spacingM),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: isDark
                    ? CupertinoColors.white.withOpacity(0.9)
                    : CupertinoColors.black.withOpacity(0.8),
              ),
              const SizedBox(width: Branding.spacingM),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: Branding.fontSizeBody,
                    fontWeight: Branding.weightMedium,
                    color:
                        isDark ? CupertinoColors.white : CupertinoColors.black,
                  ),
                ),
              ),
              Icon(
                CupertinoIcons.chevron_right,
                size: 18,
                color: isDark
                    ? CupertinoColors.white.withOpacity(0.5)
                    : CupertinoColors.black.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
