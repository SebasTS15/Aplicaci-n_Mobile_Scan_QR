import 'package:flutter/material.dart';

class AuthBackgroundV2 extends StatelessWidget {
  final Widget child;

  const AuthBackgroundV2({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
    );
  }
}
