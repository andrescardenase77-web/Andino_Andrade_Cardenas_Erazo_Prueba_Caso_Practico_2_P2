import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/reserva.dart';
import '../viewmodels/cine_viewmodel.dart';

class BoletosView extends StatefulWidget {
  const BoletosView({super.key});

  @override
  State<BoletosView> createState() => _BoletosViewState();
}

class _BoletosViewState extends State<BoletosView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CineViewModel>().cargarUltimaReserva();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis boletos')),
      body: Consumer<CineViewModel>(
        builder: (context, viewModel, _) {
          final reserva = viewModel.ultimaReserva;

          if (reserva == null) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.confirmation_number_outlined,
                    size: 72,
                    color: Color(0xFFFF7A1A),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'No hay boletos activos',
                    style: TextStyle(fontSize: 16, color: Color(0xFF9A9AA3)),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Reserva una película para verla aquí',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6E6E77)),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Última reserva guardada',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF7A1A),
                  ),
                ),
                const SizedBox(height: 16),
                _ticket(reserva),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _ticket(Reserva reserva) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6D00), Color(0xFFFFB74D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_movies_rounded,
                    color: Colors.black,
                    size: 40,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      reserva.pelicula.titulo,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.black54, height: 1),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _dato('Fecha', reserva.fecha),
                      _dato('Hora', reserva.hora),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Icon(
                        Icons.event_seat_rounded,
                        color: Colors.black87,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Asientos: ${reserva.asientos}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.notifications_active_rounded,
                        color: Colors.black87,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Recordatorio: ${reserva.recordatorio ? "Sí" : "No"}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.black12,
              child: const Text(
                'CINE APP  •  ENTRADA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dato(String etiqueta, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
