import 'package:flutter/cupertino.dart';

class EventTeamScreen extends StatelessWidget {
  final String eventId;

  const EventTeamScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Equipo'),
      ),
      child: const SafeArea(
        child: Center(
          child: Text('Gestión de equipo\n(Se implementará próximamente)'),
        ),
      ),
    );
  }
}

