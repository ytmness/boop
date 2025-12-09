import 'package:flutter/cupertino.dart';

class AdvancedStatsScreen extends StatelessWidget {
  final String eventId;

  const AdvancedStatsScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Estadísticas avanzadas'),
      ),
      child: SafeArea(
        child: Center(
          child: Text('Estadísticas avanzadas\n(Se implementará próximamente)'),
        ),
      ),
    );
  }
}
