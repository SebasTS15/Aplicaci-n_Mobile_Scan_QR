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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: _createCardShape(),
          child: this.child,
      ),
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
    color: const Color(0xFFF8FAFB),
    borderRadius: BorderRadius.circular(18),
    border: Border.all(
      color: const Color(0xFF00BCD4).withOpacity(0.08),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF00BCD4).withOpacity(0.06),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ]
  );
}
