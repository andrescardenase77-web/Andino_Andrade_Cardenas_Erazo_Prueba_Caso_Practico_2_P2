import 'package:flutter/material.dart';

import '../presentation/views/main_screen.dart';
import '../presentation/views/reserva_view.dart';

class AppRoutes {
  static const String main = '/';
  static const String inicio = '/inicio';
  static const String reserva = '/reserva';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case inicio:
      case main:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
          settings: settings,
        );
      case reserva:
        return MaterialPageRoute(
          builder: (_) => const ReservaView(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
          settings: settings,
        );
    }
  }
}
