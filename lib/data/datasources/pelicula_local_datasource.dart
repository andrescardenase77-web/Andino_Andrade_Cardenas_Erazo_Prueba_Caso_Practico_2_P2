import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pelicula_model.dart';
import '../models/reserva_model.dart';

class PeliculaLocalDatasource {
  static const String _urlApi = 'https://devsapihub.com/api-movies';
  static const String _ultimaReservaKey = 'ultima_reserva';

  final http.Client _client;

  PeliculaLocalDatasource({http.Client? client})
      : _client = client ?? http.Client();

  Future<List<PeliculaModel>> getPeliculas() async {
    final response = await _client
        .get(Uri.parse(_urlApi))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Error HTTP ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Formato de respuesta inválido');
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(PeliculaModel.fromJson)
        .toList();
  }

  Future<void> guardarUltimaReserva(ReservaModel reserva) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ultimaReservaKey, jsonEncode(reserva.toMap()));
  }

  Future<ReservaModel?> leerUltimaReserva() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_ultimaReservaKey);
    if (raw == null) return null;

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return ReservaModel.fromMap(map);
    } catch (_) {
      return null;
    }
  }
}
