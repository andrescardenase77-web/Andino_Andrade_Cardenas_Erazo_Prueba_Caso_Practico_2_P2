import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/pelicula.dart';
import '../viewmodels/pelicula_viewmodel.dart';
import 'splash_view.dart';

class ReservaView extends StatefulWidget {
  const ReservaView({super.key});

  @override
  State<ReservaView> createState() => _ReservaViewState();
}

class _ReservaViewState extends State<ReservaView> {
  DateTime? _fechaSeleccionada;
  TimeOfDay? _horaSeleccionada;

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  String _formatearHora(TimeOfDay hora) {
    final h = hora.hour.toString().padLeft(2, '0');
    final m = hora.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _seleccionarFecha() async {
    final hoy = DateTime.now();
    final seleccion = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada ?? hoy,
      firstDate: hoy,
      lastDate: hoy.add(const Duration(days: 90)),
    );

    if (seleccion != null) {
      setState(() {
        _fechaSeleccionada = seleccion;
      });
    }
  }

  Future<void> _seleccionarHora() async {
    final seleccion = await showTimePicker(
      context: context,
      initialTime: _horaSeleccionada ?? const TimeOfDay(hour: 19, minute: 30),
    );

    if (seleccion != null) {
      setState(() {
        _horaSeleccionada = seleccion;
      });
    }
  }

  Future<void> _guardarReserva(Pelicula pelicula) async {
    if (_fechaSeleccionada == null || _horaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona la fecha y la hora de la función.'),
          backgroundColor: colorNaranjaOscuro,
        ),
      );
      return;
    }

    final fechaTexto = _formatearFecha(_fechaSeleccionada!);
    final horaTexto = _formatearHora(_horaSeleccionada!);

    await context.read<PeliculaViewmodel>().guardarNuevaReserva(
          pelicula: pelicula,
          fecha: fechaTexto,
          hora: horaTexto,
        );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reserva guardada: ${pelicula.titulo} ($fechaTexto - $horaTexto)'),
        backgroundColor: colorNaranjaOscuro,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Recibir la película seleccionada mediante arguments en ruta nombrada
    final pelicula = ModalRoute.of(context)!.settings.arguments as Pelicula;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserva de Boletos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tarjeta con información detallada de la película: nombre, año, género y descripción
            Card(
              color: colorNegroTarjeta,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 230,
                    width: double.infinity,
                    child: pelicula.imagenUrl.isEmpty
                        ? Container(
                            color: const Color(0xFF22222A),
                            child: const Icon(
                              Icons.local_movies_rounded,
                              size: 64,
                              color: colorNaranjaOscuro,
                            ),
                          )
                        : Image.network(
                            pelicula.imagenUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              color: const Color(0xFF22222A),
                              child: const Icon(
                                Icons.local_movies_rounded,
                                size: 64,
                                color: colorNaranjaOscuro,
                              ),
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pelicula.titulo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: colorNaranjaOscuro,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Año: ${pelicula.anio}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.09),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: colorNaranjaBrillante.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Género: ${pelicula.genero}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Descripción',
                          style: TextStyle(
                            color: colorNaranjaBrillante,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          pelicula.descripcion,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Selección de fecha y hora con DatePicker y TimePicker
            Card(
              color: colorNegroTarjeta,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Configurar función',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    OutlinedButton.icon(
                      onPressed: _seleccionarFecha,
                      icon: const Icon(
                        Icons.calendar_month_rounded,
                        color: colorNaranjaBrillante,
                      ),
                      label: Text(
                        _fechaSeleccionada == null
                            ? 'Seleccionar fecha de la función'
                            : 'Fecha seleccionada: ${_formatearFecha(_fechaSeleccionada!)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: colorNaranjaOscuro),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _seleccionarHora,
                      icon: const Icon(
                        Icons.schedule_rounded,
                        color: colorNaranjaBrillante,
                      ),
                      label: Text(
                        _horaSeleccionada == null
                            ? 'Seleccionar hora de la función'
                            : 'Hora seleccionada: ${_formatearHora(_horaSeleccionada!)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: colorNaranjaOscuro),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: () => _guardarReserva(pelicula),
                      icon: const Icon(Icons.save_rounded),
                      label: const Text(
                        'Guardar Reserva',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorNaranjaOscuro,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
