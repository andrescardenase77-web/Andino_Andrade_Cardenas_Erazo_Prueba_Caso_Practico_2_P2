import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/cine_repository_impl.dart';
import 'domain/usecases/gestionar_cine_usecase.dart';
import 'presentation/viewmodels/cine_viewmodel.dart';
import 'routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = CineRepositoryImpl();
  final usecase = GestionarCineUseCase(repository);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CineViewModel(usecase),
      child: const CineApp(),
    ),
  );
}

class CineApp extends StatelessWidget {
  const CineApp({super.key});

  @override
  Widget build(BuildContext context) {
    final esquema = ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF6D00),
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFFFF7A1A),
      onPrimary: Colors.black,
      secondary: const Color(0xFFFFB74D),
      surface: const Color(0xFF121216),
      onSurface: Colors.white,
      error: const Color(0xFFFF5252),
    );

    return MaterialApp(
      title: 'Cine App',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.main,
      onGenerateRoute: AppRoutes.generateRoute,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: esquema,
        scaffoldBackgroundColor: const Color(0xFF08080B),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFF0D0D11),
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF16161C),
          surfaceTintColor: Colors.transparent,
          elevation: 8,
          shadowColor: Color(0x66FF6D00),
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Color(0x33FF6D00)),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF0D0D11),
          selectedItemColor: Color(0xFFFF7A1A),
          unselectedItemColor: Color(0xFF8A8A93),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFF6D00),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFF16161C),
          surfaceTintColor: Colors.transparent,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0x66FF6D00)),
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color(0xFFFF7A1A),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0x33FFFFFF),
          thickness: 1,
        ),
      ),
    );
  }
}
