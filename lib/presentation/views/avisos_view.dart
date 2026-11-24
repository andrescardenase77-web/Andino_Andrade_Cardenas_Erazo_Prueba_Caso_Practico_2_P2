import 'package:flutter/material.dart';

class AvisosView extends StatelessWidget {
  const AvisosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Avisos')),
      body: const Center(
        child: Text(
          'Sin avisos',
          style: TextStyle(fontSize: 16, color: Color(0xFF9A9AA3)),
        ),
      ),
    );
  }
}
