import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:proy_cine_app/data/datasources/reserva_local_datasource.dart';
import 'package:proy_cine_app/domain/entities/pelicula.dart';
import 'package:proy_cine_app/domain/entities/reserva.dart';
import 'package:proy_cine_app/domain/repositories/pelicula_repository.dart';
import 'package:proy_cine_app/domain/usecases/gestionar_reserva.dart';
import 'package:proy_cine_app/domain/usecases/obtener_peliculas.dart';
import 'package:proy_cine_app/main.dart';
import 'package:proy_cine_app/presentation/viewmodels/pelicula_viewmodel.dart';

class _FakePeliculaRepository implements PeliculaRepository {
  final ReservaLocalDatasource localDatasource;

  _FakePeliculaRepository(this.localDatasource);

  @override
  Future<List<Pelicula>> obtenerPeliculas() async {
    return List.generate(
      10,
      (i) => Pelicula(
        id: i + 1,
        titulo: 'Película Demo ${i + 1}',
        descripcion: 'Sinopsis de prueba para la película ${i + 1}.',
        anio: 2024,
        imagenUrl: '',
        genero: 'Acción, Aventura',
      ),
    );
  }

  @override
  Future<void> guardarReserva(Reserva reserva) {
    return localDatasource.guardarReserva(reserva);
  }

  @override
  Future<Reserva?> obtenerUltimaReserva() {
    return localDatasource.obtenerUltimaReserva();
  }
}

void main() {
  testWidgets(
    'CinePro muestra splash, cartelera de 10 películas, detalle y persistencia en Boletos',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final local = ReservaLocalDatasource();
      final repo = _FakePeliculaRepository(local);
      final vm = PeliculaViewmodel(
        ObtenerPeliculas(repo),
        GestionarReserva(repo),
      );

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: vm,
          child: const CineProApp(),
        ),
      );

      // Verifica logo CinePro en Splash
      expect(find.text('Cine'), findsOneWidget);
      expect(find.text('Pro'), findsOneWidget);

      // Avanzar a Inicio
      await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
      await tester.pumpAndSettle();

      // Verifica BottomNavigationBar con las 4 secciones
      expect(find.text('Inicio'), findsOneWidget);
      expect(find.text('Boletos'), findsOneWidget);
      expect(find.text('Avisos'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);

      // Verifica películas en el GridView y tap sobre la carta
      expect(find.text('Película Demo 1'), findsOneWidget);
      await tester.tap(find.text('Película Demo 1'));
      await tester.pumpAndSettle();

      // Verifica datos en ReservaView (nombre, año, género y descripción)
      expect(find.text('Reserva de Boletos'), findsOneWidget);
      expect(find.text('Año: 2024'), findsOneWidget);
      expect(find.text('Género: Acción, Aventura'), findsOneWidget);
      expect(
        find.text('Sinopsis de prueba para la película 1.'),
        findsOneWidget,
      );

      // Guardar reserva mediante ViewModel + SharedPreferences
      await vm.guardarNuevaReserva(
        pelicula: vm.peliculas.first,
        fecha: '28/11/2026',
        hora: '20:00',
      );
      Navigator.of(tester.element(find.text('Reserva de Boletos'))).pop();
      await tester.pumpAndSettle();

      // Verifica sección Boletos e indicaciones puntuales
      expect(find.text('BOLETO RESERVADO'), findsOneWidget);
      expect(find.text('Fecha: 28/11/2026'), findsOneWidget);
      expect(find.text('Hora: 20:00'), findsOneWidget);
      expect(find.text('Indicaciones puntuales'), findsOneWidget);

      // Verifica que SharedPreferences persiste tras crear un nuevo ViewModel
      final nuevoVm = PeliculaViewmodel(
        ObtenerPeliculas(repo),
        GestionarReserva(repo),
      );
      await nuevoVm.cargarReservaGuardada();
      expect(nuevoVm.ultimaReserva?.nombrePelicula, 'Película Demo 1');
      expect(nuevoVm.ultimaReserva?.fecha, '28/11/2026');
      expect(nuevoVm.ultimaReserva?.hora, '20:00');
    },
  );
}
