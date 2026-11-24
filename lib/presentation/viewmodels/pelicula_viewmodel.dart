import 'package:flutter/material.dart';
import '../../domain/entities/pelicula.dart';
import '../../domain/entities/reserva.dart';
import '../../domain/usecases/obtener_peliculas.dart';
import '../../domain/usecases/gestionar_reserva.dart';

class PeliculaViewmodel extends ChangeNotifier {
  final ObtenerPeliculas obtenerPeliculas;
  final GestionarReserva gestionarReserva;

  PeliculaViewmodel(this.obtenerPeliculas, this.gestionarReserva);

  List<Pelicula> peliculas = [];
  bool cargando = false;
  String error = '';
  int indiceNavegacion = 0;
  Reserva? ultimaReserva;

  Future<void> inicializarDatos() async {
    await cargarReservaGuardada();
    if (peliculas.isEmpty) {
      await cargarPeliculas();
    }
  }

  Future<void> cargarPeliculas() async {
    cargando = true;
    error = '';
    notifyListeners();

    try {
      peliculas = await obtenerPeliculas.ejecutar();
    } catch (e) {
      error = 'No se pudieron cargar las películas desde la API.';
    }

    cargando = false;
    notifyListeners();
  }

  Future<void> cargarReservaGuardada() async {
    ultimaReserva = await gestionarReserva.obtenerUltima();
    notifyListeners();
  }

  Future<void> guardarNuevaReserva({
    required Pelicula pelicula,
    required String fecha,
    required String hora,
  }) async {
    final nueva = Reserva(
      nombrePelicula: pelicula.titulo,
      fecha: fecha,
      hora: hora,
      imagenUrl: pelicula.imagenUrl,
    );
    await gestionarReserva.guardar(nueva);
    ultimaReserva = nueva;
    indiceNavegacion = 1; // Mostrar pestaña Boletos con la reserva realizada
    notifyListeners();
  }

  void cambiarIndiceNavegacion(int indice) {
    indiceNavegacion = indice;
    notifyListeners();
  }
}
