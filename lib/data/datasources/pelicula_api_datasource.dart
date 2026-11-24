import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pelicula_model.dart';

class PeliculaApiDatasource {
  final String url = 'https://devsapihub.com/api-movies';

  Future<List<PeliculaModel>> obtenerPeliculas() async {
    final respuesta = await http.get(Uri.parse(url));

    if (respuesta.statusCode == 200) {
      final List<dynamic> datos = jsonDecode(utf8.decode(respuesta.bodyBytes));

      // Traer únicamente las 10 primeras películas para evitar paginación
      return datos
          .take(10)
          .map((item) => PeliculaModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Error al cargar las películas desde la API');
  }
}
