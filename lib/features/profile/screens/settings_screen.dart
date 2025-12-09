import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/notifications_settings_screen.dart';
import '../../../routes/route_names.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _darkMode = false;
  String _language = 'es';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Configuración'),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      'Cuenta',
                      [
                        _buildMenuItem(
                          context,
                          'Editar perfil',
                          CupertinoIcons.person,
                          () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => const EditProfileScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      'Preferencias',
                      [
                        _buildSwitchItem(
                          'Modo oscuro',
                          CupertinoIcons.moon,
                          _darkMode,
                          (value) {
                            setState(() => _darkMode = value);
                            // TODO: Implementar cambio de tema
                          },
                        ),
                        _buildPickerItem(
                          'Idioma',
                          CupertinoIcons.globe,
                          _language == 'es' ? 'Español' : 'English',
                          () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (context) => CupertinoActionSheet(
                                actions: [
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      setState(() => _language = 'es');
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Español'),
                                    isDefaultAction: _language == 'es',
                                  ),
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      setState(() => _language = 'en');
                                      Navigator.pop(context);
                                    },
                                    child: const Text('English'),
                                    isDefaultAction: _language == 'en',
                                  ),
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancelar'),
                                  isDestructiveAction: true,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      'Notificaciones',
                      [
                        _buildMenuItem(
                          context,
                          'Configurar notificaciones',
                          CupertinoIcons.bell,
                          () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => const NotificationsSettingsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      'Privacidad',
                      [
                        _buildMenuItem(
                          context,
                          'Permisos',
                          CupertinoIcons.lock,
                          () {
                            // TODO: Implementar configuración de permisos
                          },
                        ),
                        _buildMenuItem(
                          context,
                          'Privacidad de cuenta',
                          CupertinoIcons.eye_slash,
                          () {
                            // TODO: Implementar configuración de privacidad
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      'Soporte',
                      [
                        _buildMenuItem(
                          context,
                          'Ayuda y soporte',
                          CupertinoIcons.question_circle,
                          () {
                            Navigator.pushNamed(context, RouteNames.support);
                          },
                        ),
                      ],
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

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
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

  Widget _buildSwitchItem(
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildPickerItem(
    String title,
    IconData icon,
    String value,
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
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
          const SizedBox(width: 8),
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

