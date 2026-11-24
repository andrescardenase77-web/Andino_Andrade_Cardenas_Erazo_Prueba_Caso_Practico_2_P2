class Reserva {
  final String nombrePelicula;
  final String fecha;
  final String hora;
  final String imagenUrl;

  const Reserva({
    required this.nombrePelicula,
    required this.fecha,
    required this.hora,
    this.imagenUrl = '',
  });
}
