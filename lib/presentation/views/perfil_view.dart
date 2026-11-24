import 'package:flutter/material.dart';

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: const Center(
        child: Text(
          'Perfil de usuario',
          style: TextStyle(fontSize: 16, color: Color(0xFF9A9AA3)),
        ),
      ),
    );
  }
}
