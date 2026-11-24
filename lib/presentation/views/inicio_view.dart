import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/pelicula.dart';
import '../../routes/app_routes.dart';
import '../viewmodels/cine_viewmodel.dart';

class InicioView extends StatelessWidget {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartelera de Cine'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.local_movies_outlined, color: Color(0xFFFF7A1A)),
          ),
        ],
      ),
      body: Consumer<CineViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.cargando && viewModel.peliculas.isEmpty) {
            return _estadoCarga();
          }

          if (viewModel.error != null && viewModel.peliculas.isEmpty) {
            return _estadoError(viewModel.error!, viewModel.cargarPeliculas);
          }

          return RefreshIndicator(
            color: const Color(0xFFFF7A1A),
            backgroundColor: const Color(0xFF16161C),
            onRefresh: viewModel.cargarPeliculas,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.peliculas.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.62,
              ),
              itemBuilder: (context, index) {
                return _tarjetaPelicula(context, viewModel.peliculas[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _estadoCarga() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(strokeWidth: 3),
          SizedBox(height: 16),
          Text(
            'Cargando cartelera...',
            style: TextStyle(color: Color(0xFF9A9AA3)),
          ),
        ],
      ),
    );
  }

  Widget _estadoError(String mensaje, VoidCallback reintentar) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: Color(0xFFFF7A1A),
            ),
            const SizedBox(height: 16),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF9A9AA3)),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: reintentar,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaPelicula(BuildContext context, Pelicula pelicula) {
    return Hero(
      tag: 'pelicula-${pelicula.id}',
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      pelicula.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      },
                      errorBuilder: (_, _, _) => Container(
                        color: const Color(0xFF1C1C22),
                        child: const Icon(
                          Icons.movie_rounded,
                          size: 56,
                          color: Color(0xFFFF7A1A),
                        ),
                      ),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xB3000000)],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: _calificacion(pelicula.calificacion),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 14),
                child: Column(
                  children: [
                    Text(
                      pelicula.titulo,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${pelicula.anio}  •  ${pelicula.generos.take(2).join(', ')}',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFFF9E45),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _calificacion(double valor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xD9000000),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x99FF7A1A)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFB74D)),
          const SizedBox(width: 4),
          Text(
            valor.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
