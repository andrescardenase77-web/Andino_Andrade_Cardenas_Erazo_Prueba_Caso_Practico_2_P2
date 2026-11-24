import '../../domain/entities/pelicula.dart';
import '../../domain/entities/reserva.dart';
import '../../domain/repositories/pelicula_repository.dart';
import '../datasources/pelicula_api_datasource.dart';
import '../datasources/reserva_local_datasource.dart';

class PeliculaRepositoryImpl implements PeliculaRepository {
  final PeliculaApiDatasource apiDatasource;
  final ReservaLocalDatasource localDatasource;

  PeliculaRepositoryImpl(this.apiDatasource, this.localDatasource);

  @override
  Future<List<Pelicula>> obtenerPeliculas() {
    return apiDatasource.obtenerPeliculas();
  }

  @override
  Future<void> guardarReserva(Reserva reserva) {
    return localDatasource.guardarReserva(reserva);
  }

  @override
  Future<Reserva?> obtenerUltimaReserva() {
    return localDatasource.obtenerUltimaReserva();
  }
}
