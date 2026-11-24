import '../../domain/entities/reserva.dart';
import 'pelicula_model.dart';

class ReservaModel extends Reserva {
  const ReservaModel({
    required super.pelicula,
    required super.fecha,
    required super.hora,
    required super.asientos,
    required super.recordatorio,
  });

  factory ReservaModel.fromEntity(Reserva reserva) {
    return ReservaModel(
      pelicula: reserva.pelicula,
      fecha: reserva.fecha,
      hora: reserva.hora,
      asientos: reserva.asientos,
      recordatorio: reserva.recordatorio,
    );
  }

  factory ReservaModel.fromMap(Map<String, dynamic> map) {
    return ReservaModel(
      pelicula: PeliculaModel.fromJson(map['pelicula'] as Map<String, dynamic>),
      fecha: map['fecha'] as String,
      hora: map['hora'] as String,
      asientos: map['asientos'] as String,
      recordatorio: map['recordatorio'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pelicula': {
        'id': pelicula.id,
        'title': pelicula.titulo,
        'description': pelicula.descripcion,
        'year': pelicula.anio,
        'image_url': pelicula.imageUrl,
        'genre': pelicula.generos,
        'stars': pelicula.calificacion,
      },
      'fecha': fecha,
      'hora': hora,
      'asientos': asientos,
      'recordatorio': recordatorio,
    };
  }
}
