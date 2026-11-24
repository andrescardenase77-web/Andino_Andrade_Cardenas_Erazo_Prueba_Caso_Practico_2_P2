import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/pelicula_viewmodel.dart';
import '../../routes/app_routes.dart';
import 'splash_view.dart';

class InicioView extends StatefulWidget {
  const InicioView({super.key});

  @override
  State<InicioView> createState() => _InicioViewState();
}

class _InicioViewState extends State<InicioView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<PeliculaViewmodel>().inicializarDatos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PeliculaViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: const LogoCinePro(compacto: true),
        actions: [
          if (vm.indiceNavegacion == 0)
            IconButton(
              tooltip: 'Actualizar cartelera',
              onPressed: () =>
                  context.read<PeliculaViewmodel>().cargarPeliculas(),
              icon: const Icon(Icons.refresh_rounded),
            ),
        ],
      ),
      body: _construirContenidoPestana(vm),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: vm.indiceNavegacion,
        onTap: (indice) =>
            context.read<PeliculaViewmodel>().cambiarIndiceNavegacion(indice),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF111116),
        selectedItemColor: colorNaranjaBrillante,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_creation_outlined),
            activeIcon: Icon(Icons.movie_creation_rounded),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number_outlined),
            activeIcon: Icon(Icons.confirmation_number_rounded),
            label: 'Boletos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_rounded),
            activeIcon: Icon(Icons.notifications_rounded),
            label: 'Avisos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _construirContenidoPestana(PeliculaViewmodel vm) {
    switch (vm.indiceNavegacion) {
      case 0:
        return _construirCartelera(vm);
      case 1:
        return _construirBoletos(vm);
      case 2:
        return const Center(
          child: Text(
            'Sección de avisos vacía',
            style: TextStyle(color: Colors.white54, fontSize: 15),
          ),
        );
      case 3:
        return const Center(
          child: Text(
            'Sección de perfil vacía',
            style: TextStyle(color: Colors.white54, fontSize: 15),
          ),
        );
      default:
        return _construirCartelera(vm);
    }
  }

  Widget _construirCartelera(PeliculaViewmodel vm) {
    if (vm.cargando) {
      return const Center(
        child: CircularProgressIndicator(color: colorNaranjaOscuro),
      );
    }

    if (vm.error.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 54,
                color: colorNaranjaOscuro,
              ),
              const SizedBox(height: 12),
              Text(
                vm.error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 15),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () =>
                    context.read<PeliculaViewmodel>().cargarPeliculas(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Row(
            children: [
              Icon(
                Icons.local_fire_department_rounded,
                color: colorNaranjaBrillante,
                size: 20,
              ),
              SizedBox(width: 6),
              Text(
                'Películas en Cartelera',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: vm.peliculas.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final pelicula = vm.peliculas[index];

              return Card(
                clipBehavior: Clip.antiAlias,
                color: colorNegroTarjeta,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                // InkWell envuelve toda la carta para aceptar tap en cualquier parte
                child: InkWell(
                  splashColor: colorNaranjaOscuro.withValues(alpha: 0.25),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.reserva,
                      arguments: pelicula,
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: pelicula.imagenUrl.isEmpty
                            ? Container(
                                color: const Color(0xFF22222A),
                                child: const Icon(
                                  Icons.movie_rounded,
                                  size: 48,
                                  color: colorNaranjaOscuro,
                                ),
                              )
                            : Image.network(
                                pelicula.imagenUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: colorNaranjaOscuro,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: const Color(0xFF22222A),
                                    child: const Icon(
                                      Icons.movie_rounded,
                                      size: 48,
                                      color: colorNaranjaOscuro,
                                    ),
                                  );
                                },
                              ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: const BoxDecoration(
                          color: colorNegroTarjeta,
                          border: Border(
                            top: BorderSide(
                              color: colorNaranjaOscuro,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          pelicula.titulo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _construirBoletos(PeliculaViewmodel vm) {
    final reserva = vm.ultimaReserva;

    if (reserva == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.confirmation_number_outlined,
                size: 64,
                color: colorNaranjaOscuro,
              ),
              const SizedBox(height: 14),
              const Text(
                'Aún no tienes reservas guardadas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Selecciona una película en Inicio y elige fecha y hora para registrar tu boleto.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => context
                    .read<PeliculaViewmodel>()
                    .cambiarIndiceNavegacion(0),
                icon: const Icon(Icons.movie_filter_rounded),
                label: const Text('Ir a Cartelera'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: colorNegroTarjeta,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: colorNaranjaOscuro, width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorNaranjaOscuro,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'BOLETO RESERVADO',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.verified_rounded,
                        color: colorNaranjaBrillante,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (reserva.imagenUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            reserva.imagenUrl,
                            width: 78,
                            height: 112,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              width: 78,
                              height: 112,
                              color: Colors.black26,
                              child: const Icon(
                                Icons.local_movies_rounded,
                                color: colorNaranjaOscuro,
                              ),
                            ),
                          ),
                        ),
                      if (reserva.imagenUrl.isNotEmpty)
                        const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Película',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              reserva.nombrePelicula,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  size: 16,
                                  color: colorNaranjaBrillante,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Fecha: ${reserva.fecha}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time_filled_rounded,
                                  size: 16,
                                  color: colorNaranjaBrillante,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Hora: ${reserva.hora}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: colorNegroTarjeta,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: colorNaranjaBrillante,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Indicaciones puntuales',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _ItemIndicacion(
                    texto:
                        'Presentarse en el cine al menos 15 minutos antes de la hora de la función.',
                  ),
                  _ItemIndicacion(
                    texto:
                        'Mostrar este comprobante digital en la entrada de la sala para validar su acceso.',
                  ),
                  _ItemIndicacion(
                    texto:
                        'Verificar que la fecha y hora seleccionadas sean correctas antes de asistir.',
                  ),
                  _ItemIndicacion(
                    texto:
                        'Los datos de esta reserva se mantienen guardados en su dispositivo aunque cierre la app.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemIndicacion extends StatelessWidget {
  final String texto;

  const _ItemIndicacion({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Icon(
              Icons.circle,
              size: 7,
              color: colorNaranjaOscuro,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13.5,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
