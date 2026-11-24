import 'package:flutter/foundation.dart';

import '../../../domain/entities/pelicula.dart';
import '../../../domain/entities/reserva.dart';
import '../../../domain/usecases/gestionar_cine_usecase.dart';

class CineViewModel extends ChangeNotifier {
  final GestionarCineUseCase _usecase;

  CineViewModel(this._usecase) {
    cargarPeliculas();
    cargarUltimaReserva();
  }

  List<Pelicula> _peliculas = const [];
  List<Pelicula> get peliculas => _peliculas;

  Reserva? _ultimaReserva;
  Reserva? get ultimaReserva => _ultimaReserva;

  bool _cargando = false;
  bool get cargando => _cargando;

  String? _error;
  String? get error => _error;

  Future<void> cargarPeliculas() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _peliculas = await _usecase.obtenerPeliculas();
    } catch (_) {
      _peliculas = const [];
      _error = 'No se pudo cargar la cartelera. Revisa tu conexión.';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> cargarUltimaReserva() async {
    _ultimaReserva = await _usecase.leerUltimaReserva();
    notifyListeners();
  }

  Future<void> guardarReserva(Reserva reserva) async {
    await _usecase.guardarUltimaReserva(reserva);
    _ultimaReserva = reserva;
    notifyListeners();
  }
}
