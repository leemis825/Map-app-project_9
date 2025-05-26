import 'package:flutter/material.dart';

class NavigateButton extends StatelessWidget {
  const NavigateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'home-navigate-fab',
      backgroundColor: const Color(0xFF1E88E5),
      onPressed: () {
        Navigator.pushNamed(context, '/qr_navigate'); // QR → 경로 안내
      },
      child: const Icon(Icons.navigation),
    );
  }
}
