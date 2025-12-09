import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsSettingsScreen extends ConsumerStatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  ConsumerState<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends ConsumerState<NotificationsSettingsScreen> {
  bool _eventReminders = true;
  bool _friendActivity = true;
  bool _communityUpdates = true;
  bool _ticketConfirmations = true;
  bool _promotional = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Notificaciones'),
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
                      'Eventos',
                      [
                        _buildSwitchItem(
                          'Recordatorios de eventos',
                          'Recibe notificaciones cuando se acerca un evento',
                          _eventReminders,
                          (value) {
                            setState(() => _eventReminders = value);
                            // TODO: Guardar preferencia
                          },
                        ),
                        _buildSwitchItem(
                          'Confirmaciones de tickets',
                          'Notificaciones cuando compras o recibes tickets',
                          _ticketConfirmations,
                          (value) {
                            setState(() => _ticketConfirmations = value);
                            // TODO: Guardar preferencia
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      'Social',
                      [
                        _buildSwitchItem(
                          'Actividad de amigos',
                          'Actualizaciones cuando tus amigos hacen algo',
                          _friendActivity,
                          (value) {
                            setState(() => _friendActivity = value);
                            // TODO: Guardar preferencia
                          },
                        ),
                        _buildSwitchItem(
                          'Actualizaciones de comunidades',
                          'Notificaciones de las comunidades que sigues',
                          _communityUpdates,
                          (value) {
                            setState(() => _communityUpdates = value);
                            // TODO: Guardar preferencia
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      'Otros',
                      [
                        _buildSwitchItem(
                          'Promociones',
                          'Ofertas especiales y promociones',
                          _promotional,
                          (value) {
                            setState(() => _promotional = value);
                            // TODO: Guardar preferencia
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

  Widget _buildSwitchItem(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
              ],
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
}

