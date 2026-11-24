import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/reserva.dart';

class ReservaLocalDatasource {
  static const String _keyPelicula = 'ultima_reserva_pelicula';
  static const String _keyFecha = 'ultima_reserva_fecha';
  static const String _keyHora = 'ultima_reserva_hora';
  static const String _keyImagen = 'ultima_reserva_imagen';

  Future<void> guardarReserva(Reserva reserva) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPelicula, reserva.nombrePelicula);
    await prefs.setString(_keyFecha, reserva.fecha);
    await prefs.setString(_keyHora, reserva.hora);
    await prefs.setString(_keyImagen, reserva.imagenUrl);
  }

  Future<Reserva?> obtenerUltimaReserva() async {
    final prefs = await SharedPreferences.getInstance();
    final nombre = prefs.getString(_keyPelicula);
    final fecha = prefs.getString(_keyFecha);
    final hora = prefs.getString(_keyHora);
    final imagen = prefs.getString(_keyImagen) ?? '';

    if (nombre != null &&
        nombre.isNotEmpty &&
        fecha != null &&
        hora != null) {
      return Reserva(
        nombrePelicula: nombre,
        fecha: fecha,
        hora: hora,
        imagenUrl: imagen,
      );
    }
    return null;
  }
}
