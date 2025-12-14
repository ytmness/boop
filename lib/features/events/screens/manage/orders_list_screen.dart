import 'package:flutter/cupertino.dart';

class OrdersListScreen extends StatelessWidget {
  final String eventId;

  const OrdersListScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Órdenes'),
      ),
      child: SafeArea(
        child: Center(
          child: Text('Lista de órdenes\n(Se implementará en Fase 5)'),
        ),
      ),
    );
  }
}
