import 'package:flutter/material.dart';

import 'avisos_view.dart';
import 'boletos_view.dart';
import 'inicio_view.dart';
import 'perfil_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _indice = 0;

  static const List<Widget> _vistas = [
    InicioView(),
    BoletosView(),
    AvisosView(),
    PerfilView(),
  ];

  static const List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home_rounded),
      label: 'Inicio',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.confirmation_number_outlined),
      activeIcon: Icon(Icons.confirmation_number_rounded),
      label: 'Boletos',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications_none_rounded),
      activeIcon: Icon(Icons.notifications_active_rounded),
      label: 'Avisos',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline_rounded),
      activeIcon: Icon(Icons.person_rounded),
      label: 'Perfil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _vistas[_indice],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indice,
        onTap: (indice) => setState(() => _indice = indice),
        items: _items,
      ),
    );
  }
}
