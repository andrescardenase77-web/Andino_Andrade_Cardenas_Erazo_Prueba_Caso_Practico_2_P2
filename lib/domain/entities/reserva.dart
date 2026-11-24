import 'pelicula.dart';

class Reserva {
  final Pelicula pelicula;
  final String fecha;
  final String hora;
  final String asientos;
  final bool recordatorio;

  const Reserva({
    required this.pelicula,
    required this.fecha,
    required this.hora,
    required this.asientos,
    required this.recordatorio,
  });
}
