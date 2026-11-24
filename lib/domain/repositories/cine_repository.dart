import '../entities/pelicula.dart';
import '../entities/reserva.dart';

abstract class CineRepository {
  Future<List<Pelicula>> obtenerPeliculas();

  Future<void> guardarUltimaReserva(Reserva reserva);

  Future<Reserva?> leerUltimaReserva();
}
