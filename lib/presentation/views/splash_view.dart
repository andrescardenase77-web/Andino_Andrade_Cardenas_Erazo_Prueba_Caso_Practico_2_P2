import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

// Colores principales de la identidad visual CinePro (Negro y Naranja Oscuro)
const Color colorNegroFondo = Color(0xFF0B0B0E);
const Color colorNegroTarjeta = Color(0xFF17171D);
const Color colorNaranjaOscuro = Color(0xFFE65100);
const Color colorNaranjaBrillante = Color(0xFFFF6D00);

// Widget reutilizable del logo atractivo "CinePro" (modo completo para Splash y compacto para AppBar)
class LogoCinePro extends StatelessWidget {
  final bool compacto;

  const LogoCinePro({super.key, this.compacto = false});

  @override
  Widget build(BuildContext context) {
    if (compacto) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [colorNaranjaOscuro, Color(0xFFBF360C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.movie_filter_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Cine',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(width: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: colorNaranjaOscuro,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              'PRO',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 13,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 144,
          height: 144,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorNegroTarjeta,
            border: Border.all(color: colorNaranjaOscuro, width: 3),
            boxShadow: [
              BoxShadow(
                color: colorNaranjaOscuro.withValues(alpha: 0.45),
                blurRadius: 30,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 116,
                height: 116,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorNaranjaBrillante.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
              ),
              const Icon(
                Icons.local_movies_rounded,
                size: 68,
                color: colorNaranjaBrillante,
              ),
              Positioned(
                bottom: 22,
                right: 24,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: colorNaranjaOscuro,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Cine',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [colorNaranjaBrillante, colorNaranjaOscuro],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: colorNaranjaOscuro.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'Pro',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController controladorAnimacion;
  late Animation<double> animacionOpacidad;
  late Animation<double> animacionEscala;

  @override
  void initState() {
    super.initState();

    // Animación reutilizada del proyecto de Galería de Fotografías
    controladorAnimacion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animacionOpacidad = CurvedAnimation(
      parent: controladorAnimacion,
      curve: Curves.easeInOut,
    );

    animacionEscala = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: controladorAnimacion,
        curve: Curves.easeOutCubic,
      ),
    );

    controladorAnimacion.forward();
  }

  @override
  void dispose() {
    controladorAnimacion.dispose();
    super.dispose();
  }

  void irACartelera() {
    Navigator.pushReplacementNamed(context, AppRoutes.inicio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A0D06),
              colorNegroFondo,
              Color(0xFF050507),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                ScaleTransition(
                  scale: animacionEscala,
                  child: FadeTransition(
                    opacity: animacionOpacidad,
                    child: const Column(
                      children: [
                        LogoCinePro(),
                        SizedBox(height: 14),
                        Text(
                          'Tu experiencia de cine y boletos al instante',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                FadeTransition(
                  opacity: animacionOpacidad,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colorNaranjaOscuro.withValues(alpha: 0.45),
                              blurRadius: 16,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: irACartelera,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(18),
                            backgroundColor: colorNaranjaOscuro,
                            foregroundColor: Colors.white,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Ingresar',
                        style: TextStyle(
                          color: colorNaranjaBrillante,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
