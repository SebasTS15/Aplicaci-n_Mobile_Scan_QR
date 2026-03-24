import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;

  const CardContainer({
    super.key, 
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: _createCardShape(),
          child: this.child,
      ),
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: Colors.deepPurple.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      )
    ]
  );
}
