import '../../domain/entities/pelicula.dart';

class PeliculaModel extends Pelicula {
  const PeliculaModel({
    required super.id,
    required super.titulo,
    required super.descripcion,
    required super.anio,
    required super.imagenUrl,
    required super.genero,
  });

  factory PeliculaModel.fromJson(Map<String, dynamic> json) {
    final listaGeneros = json['genre'] as List<dynamic>?;
    final generoTexto = (listaGeneros != null && listaGeneros.isNotEmpty)
        ? listaGeneros.map((g) => g.toString()).join(', ')
        : 'General';

    return PeliculaModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      titulo: json['title']?.toString() ?? 'Sin título',
      descripcion: json['description']?.toString() ?? 'Sin descripción disponible.',
      anio: (json['year'] as num?)?.toInt() ?? 0,
      imagenUrl: json['image_url']?.toString() ?? '',
      genero: generoTexto,
    );
  }
}
