import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/pelicula.dart';
import '../../../domain/entities/reserva.dart';
import '../viewmodels/cine_viewmodel.dart';

const Color _naranja = Color(0xFFFF7A1A);
const Color _naranjaSuave = Color(0xFFFF9E45);

class ReservaView extends StatefulWidget {
  const ReservaView({super.key});

  @override
  State<ReservaView> createState() => _ReservaViewState();
}

class _ReservaViewState extends State<ReservaView> {
  static const List<String> _opcionesAsientos = ['A1, A2', 'B3, B4', 'C1, C2'];

  DateTime _fecha = DateTime.now();
  TimeOfDay _hora = TimeOfDay.now();
  String _asientos = 'A1, A2';
  bool _recordatorio = false;

  Pelicula? _obtenerPelicula() {
    final argumentos = ModalRoute.of(context)!.settings.arguments;
    return argumentos is Pelicula ? argumentos : null;
  }

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

  Future<void> _elegirFecha() async {
    final ahora = DateTime.now();
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(ahora.year),
      lastDate: DateTime(ahora.year + 2),
      helpText: 'Selecciona la fecha',
    );
    if (fecha != null && mounted) {
      setState(() => _fecha = fecha);
    }
  }

  Future<void> _elegirHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: _hora,
      helpText: 'Selecciona la hora',
    );
    if (hora != null && mounted) {
      setState(() => _hora = hora);
    }
  }

  Future<void> _reservar() async {
    final pelicula = _obtenerPelicula();
    if (pelicula == null) return;

    final viewModel = context.read<CineViewModel>();
    final reserva = Reserva(
      pelicula: pelicula,
      fecha: _formatearFecha(_fecha),
      hora: _formatearHora(_hora),
      asientos: _asientos,
      recordatorio: _recordatorio,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(strokeWidth: 3),
            SizedBox(height: 16),
            Text(
              'Registrando compra...',
              style: TextStyle(color: Color(0xFF9A9AA3)),
            ),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 900));
    await viewModel.guardarReserva(reserva);

    if (!mounted) return;
    Navigator.of(context).pop();

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: _naranja),
            SizedBox(width: 10),
            Text('Compra confirmada'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _filaResumen('Película', reserva.pelicula.titulo),
            _filaResumen('Fecha', reserva.fecha),
            _filaResumen('Hora', reserva.hora),
            _filaResumen('Asientos', reserva.asientos),
            _filaResumen(
              'Recordatorio',
              reserva.recordatorio ? 'Sí, 10 min antes' : 'No',
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  Widget _filaResumen(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            etiqueta,
            style: const TextStyle(color: Color(0xFF9A9AA3), fontSize: 13),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              valor,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pelicula = _obtenerPelicula();

    if (pelicula == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reserva')),
        body: const Center(
          child: Text(
            'No se seleccionó una película.',
            style: TextStyle(color: Color(0xFF9A9AA3)),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Reservar película')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _cabecera(pelicula),
            const SizedBox(height: 24),
            _opcion(
              icono: Icons.calendar_month_rounded,
              titulo: 'Fecha',
              valor: _formatearFecha(_fecha),
              onTap: _elegirFecha,
            ),
            const SizedBox(height: 12),
            _opcion(
              icono: Icons.access_time_rounded,
              titulo: 'Hora',
              valor: _formatearHora(_hora),
              onTap: _elegirHora,
            ),
            const SizedBox(height: 12),
            _asientosCard(),
            const SizedBox(height: 12),
            _recordatorioCard(),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _reservar,
              child: const Text('Reservar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cabecera(Pelicula pelicula) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'pelicula-${pelicula.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  pelicula.imageUrl,
                  width: 84,
                  height: 116,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 84,
                    height: 116,
                    color: const Color(0xFF1C1C22),
                    child: const Icon(
                      Icons.movie_rounded,
                      color: _naranja,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pelicula.titulo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${pelicula.anio}  •  ${pelicula.generos.join(', ')}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: _naranjaSuave,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: Color(0xFFFFB74D),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${pelicula.calificacion.toStringAsFixed(1)} / 5',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pelicula.descripcion,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9A9AA3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _opcion({
    required IconData icono,
    required String titulo,
    required String valor,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF2A1A12),
          child: Icon(icono, color: _naranja),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontSize: 13, color: Color(0xFF9A9AA3)),
        ),
        subtitle: Text(
          valor,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: _naranja),
        onTap: onTap,
      ),
    );
  }

  Widget _asientosCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF2A1A12),
              child: Icon(Icons.event_seat_rounded, color: _naranja),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Asientos',
                style: TextStyle(fontSize: 13, color: Color(0xFF9A9AA3)),
              ),
            ),
            DropdownButton<String>(
              value: _asientos,
              dropdownColor: const Color(0xFF1C1C22),
              icon: const Icon(Icons.arrow_drop_down_rounded, color: _naranja),
              items: _opcionesAsientos
                  .map(
                    (opcion) => DropdownMenuItem(
                      value: opcion,
                      child: Text(opcion),
                    ),
                  )
                  .toList(),
              onChanged: (valor) {
                if (valor != null) {
                  setState(() => _asientos = valor);
                }
              },
              underline: const SizedBox.shrink(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recordatorioCard() {
    return Card(
      child: SwitchListTile(
        secondary: const CircleAvatar(
          backgroundColor: Color(0xFF2A1A12),
          child: Icon(
            Icons.notifications_active_rounded,
            color: _naranja,
          ),
        ),
        title: const Text(
          'Notificar 10 minutos antes',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: const Text(
          'Recibe un recordatorio de tu reserva',
          style: TextStyle(color: Color(0xFF9A9AA3)),
        ),
        value: _recordatorio,
        onChanged: (valor) => setState(() => _recordatorio = valor),
      ),
    );
  }
}
