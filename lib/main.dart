import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/datasources/pelicula_api_datasource.dart';
import 'data/datasources/reserva_local_datasource.dart';
import 'data/repositories/pelicula_repository_impl.dart';

import 'domain/usecases/obtener_peliculas.dart';
import 'domain/usecases/gestionar_reserva.dart';

import 'presentation/viewmodels/pelicula_viewmodel.dart';
import 'presentation/views/splash_view.dart';
import 'presentation/views/inicio_view.dart';
import 'presentation/views/reserva_view.dart';

import 'routes/app_routes.dart';

void main() {
  final apiDatasource = PeliculaApiDatasource();
  final localDatasource = ReservaLocalDatasource();
  final repository = PeliculaRepositoryImpl(apiDatasource, localDatasource);

  final obtenerPeliculas = ObtenerPeliculas(repository);
  final gestionarReserva = GestionarReserva(repository);

  runApp(
    ChangeNotifierProvider(
      create: (_) => PeliculaViewmodel(obtenerPeliculas, gestionarReserva),
      child: const CineProApp(),
    ),
  );
}

class CineProApp extends StatelessWidget {
  const CineProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CinePro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: colorNegroFondo,
        colorScheme: const ColorScheme.dark(
          primary: colorNaranjaOscuro,
          secondary: colorNaranjaBrillante,
          surface: colorNegroTarjeta,
          onPrimary: Colors.white,
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111116),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorNaranjaOscuro,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashView(),
        AppRoutes.inicio: (_) => const InicioView(),
        AppRoutes.reserva: (_) => const ReservaView(),
      },
    );
  }
}
