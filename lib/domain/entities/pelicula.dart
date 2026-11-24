class Pelicula {
  final int id;
  final String titulo;
  final String descripcion;
  final int anio;
  final String imageUrl;
  final List<String> generos;
  final double calificacion;

  const Pelicula({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.anio,
    required this.imageUrl,
    required this.generos,
    required this.calificacion,
  });
}
