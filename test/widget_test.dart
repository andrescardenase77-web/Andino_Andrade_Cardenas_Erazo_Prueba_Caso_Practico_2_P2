import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:prueba_caso_practico/data/datasources/pelicula_local_datasource.dart';
import 'package:prueba_caso_practico/data/models/pelicula_model.dart';

void main() {
  test('obtiene y parsea películas desde la API REST', () async {
    final client = MockClient((request) async {
      expect(request.method, 'GET');
      expect(request.url.toString(), 'https://devsapihub.com/api-movies');
      return http.Response(
        jsonEncode([
          {
            'id': 1,
            'title': 'The Shawshank Redemption',
            'description': 'Two imprisoned men bond...',
            'year': 1994,
            'image_url': 'https://devsapihub.com/img-movies/1.jpg',
            'genre': ['Drama'],
            'stars': 5,
          },
        ]),
        200,
      );
    });

    final datasource = PeliculaLocalDatasource(client: client);
    final peliculas = await datasource.getPeliculas();

    expect(peliculas, hasLength(1));
    expect(peliculas.first.titulo, 'The Shawshank Redemption');
    expect(peliculas.first.imageUrl, 'https://devsapihub.com/img-movies/1.jpg');
    expect(peliculas.first.generos, ['Drama']);
    expect(peliculas.first.calificacion, 5.0);
  });

  test('normaliza una URL envuelta en markdown', () {
    final pelicula = PeliculaModel.fromJson({
      'id': 2,
      'title': 'Jumanji',
      'description': 'The gang is back.',
      'year': 2019,
      'image_url':
          '[https://devsapihub.com/img-movies/2.jpg](https://devsapihub.com/img-movies/2.jpg)',
      'genre': ['Adventure', 'Fantasy'],
      'stars': 3.4,
    });

    expect(pelicula.imageUrl, 'https://devsapihub.com/img-movies/2.jpg');
    expect(pelicula.calificacion, 3.4);
  });
}
