import '../../domain/entities/pelicula.dart';

class PeliculaModel extends Pelicula {
  const PeliculaModel({
    required super.id,
    required super.titulo,
    required super.descripcion,
    required super.anio,
    required super.imageUrl,
    required super.generos,
    required super.calificacion,
  });

  factory PeliculaModel.fromJson(Map<String, dynamic> json) {
    return PeliculaModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      titulo: json['title'] as String? ?? 'Sin título',
      descripcion: json['description'] as String? ?? '',
      anio: (json['year'] as num?)?.toInt() ?? 0,
      imageUrl: _limpiarUrl(json['image_url'] as String? ?? ''),
      generos: (json['genre'] as List<dynamic>? ?? const <dynamic>[])
          .map((genero) => genero.toString())
          .toList(),
      calificacion: (json['stars'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': titulo,
      'description': descripcion,
      'year': anio,
      'image_url': imageUrl,
      'genre': generos,
      'stars': calificacion,
    };
  }

  static String _limpiarUrl(String valor) {
    final match = RegExp(r'\((https?://[^)]+)\)').firstMatch(valor);
    if (match != null) return match.group(1)!;

    if (valor.startsWith('[') && valor.contains('](')) {
      return valor.substring(1, valor.indexOf(']'));
    }

    return valor;
  }
}
