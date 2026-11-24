import '../../domain/entities/pelicula.dart';
import '../../domain/entities/reserva.dart';
import '../../domain/repositories/cine_repository.dart';
import '../datasources/pelicula_local_datasource.dart';
import '../models/reserva_model.dart';

class CineRepositoryImpl implements CineRepository {
  final PeliculaLocalDatasource _datasource;

  CineRepositoryImpl({PeliculaLocalDatasource? datasource})
      : _datasource = datasource ?? PeliculaLocalDatasource();

  @override
  Future<List<Pelicula>> obtenerPeliculas() => _datasource.getPeliculas();

  @override
  Future<void> guardarUltimaReserva(Reserva reserva) {
    return _datasource.guardarUltimaReserva(ReservaModel.fromEntity(reserva));
  }

  @override
  Future<Reserva?> leerUltimaReserva() => _datasource.leerUltimaReserva();
}
