import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';

class CustomNavigatorbar extends StatelessWidget {
  const CustomNavigatorbar({super.key});

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF00897B),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          )
        ]
      ),
      child: BottomNavigationBar(
        onTap: (int i) => uiProvider.selectedMenuOpt = i,
        currentIndex: currentIndex,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map, size: 26),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compass_calibration, size: 26),
            label: 'Direcciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pedal_bike, size: 26),
            label: 'Otro',
          ),
        ],
      ),
    );
  }
}
