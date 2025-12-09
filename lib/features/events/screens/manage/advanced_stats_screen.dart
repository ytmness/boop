import 'package:flutter/cupertino.dart';

class AdvancedStatsScreen extends StatelessWidget {
  final String eventId;

  const AdvancedStatsScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Estadísticas avanzadas'),
      ),
      child: const SafeArea(
        child: Center(
          child: Text('Estadísticas avanzadas\n(Se implementará próximamente)'),
        ),
      ),
    );
  }
}

