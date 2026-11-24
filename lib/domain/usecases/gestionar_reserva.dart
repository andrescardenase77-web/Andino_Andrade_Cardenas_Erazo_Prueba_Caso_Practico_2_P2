import '../entities/reserva.dart';
import '../repositories/pelicula_repository.dart';

class GestionarReserva {
  final PeliculaRepository repository;

  GestionarReserva(this.repository);

  Future<void> guardar(Reserva reserva) {
    return repository.guardarReserva(reserva);
  }

  Future<Reserva?> obtenerUltima() {
    return repository.obtenerUltimaReserva();
  }
}
