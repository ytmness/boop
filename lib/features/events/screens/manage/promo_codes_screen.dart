import 'package:flutter/cupertino.dart';

class PromoCodesScreen extends StatelessWidget {
  final String eventId;

  const PromoCodesScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Códigos promocionales'),
      ),
      child: const SafeArea(
        child: Center(
          child: Text('Gestión de códigos promocionales\n(Se implementará próximamente)'),
        ),
      ),
    );
  }
}

