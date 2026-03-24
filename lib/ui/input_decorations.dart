import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
    required String hintText,
    required String labelText,
    IconData? prefixIcon
  }) {
    return InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF00897B)
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF00897B),
            width: 2
          )
        ),
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.grey
        ),
        prefixIcon: prefixIcon != null 
          ? Icon( prefixIcon, color: const Color(0xFF00897B) )
          : null
      );
  }  
}
