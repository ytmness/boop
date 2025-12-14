import 'package:flutter/cupertino.dart';

class LoadingSpinner extends StatelessWidget {
  final double? radius;
  final Color? color;

  const LoadingSpinner({
    super.key,
    this.radius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      radius: radius ?? 10,
      color: color,
    );
  }
}

