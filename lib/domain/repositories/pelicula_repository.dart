import '../entities/pelicula.dart';
import '../entities/reserva.dart';

abstract class PeliculaRepository {
  Future<List<Pelicula>> obtenerPeliculas();
  Future<void> guardarReserva(Reserva reserva);
  Future<Reserva?> obtenerUltimaReserva();
}
