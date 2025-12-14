import 'package:flutter/cupertino.dart';

class MyTicketsScreen extends StatelessWidget {
  const MyTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Mis tickets'),
      ),
      child: SafeArea(
        child: Center(
          child: Text('Lista de tickets\n(Se implementará próximamente)'),
        ),
      ),
    );
  }
}
