import '../entities/pelicula.dart';
import '../entities/reserva.dart';
import '../repositories/cine_repository.dart';

class GestionarCineUseCase {
  final CineRepository _repository;

  const GestionarCineUseCase(this._repository);

  Future<List<Pelicula>> obtenerPeliculas() => _repository.obtenerPeliculas();

  Future<void> guardarUltimaReserva(Reserva reserva) =>
      _repository.guardarUltimaReserva(reserva);

  Future<Reserva?> leerUltimaReserva() => _repository.leerUltimaReserva();
}
