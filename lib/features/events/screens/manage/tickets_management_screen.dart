import 'package:flutter/cupertino.dart';

class TicketsManagementScreen extends StatelessWidget {
  final String eventId;

  const TicketsManagementScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Tickets'),
      ),
      child: SafeArea(
        child: Center(
          child: Text('Gestión de tickets\n(Se implementará en Fase 5)'),
        ),
      ),
    );
  }
}
