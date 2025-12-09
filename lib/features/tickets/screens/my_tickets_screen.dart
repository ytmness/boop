import 'package:flutter/cupertino.dart';

class MyTicketsScreen extends StatelessWidget {
  const MyTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Mis tickets'),
      ),
      child: const SafeArea(
        child: Center(
          child: Text('Lista de tickets\n(Se implementará próximamente)'),
        ),
      ),
    );
  }
}

