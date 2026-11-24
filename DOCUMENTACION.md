# Cine App — Documentación técnica

## Resumen general

**Cine App** es una aplicación Flutter que muestra una cartelera de películas obtenida desde la API REST `https://devsapihub.com/api-movies`, permite seleccionar una película, elegir fecha, hora, asientos y recordatorio, y guarda la última reserva para mostrarla en la pestaña **Boletos** incluso después de cerrar y reabrir la app.

La interfaz usa **Material 3** con paleta **negro / naranja**, tarjetas redondeadas y un `BottomNavigationBar` con cuatro pestañas: **Inicio, Boletos, Avisos y Perfil**.

La lógica está organizada con **MVVM** y **Clean Architecture**:

- La **vista** solo muestra pantallas y escucha el estado.
- El **ViewModel** guarda el estado y avisa cuando cambia.
- El **caso de uso** contiene la acción concreta.
- El **repositorio** decide de dónde vienen los datos.
- El **datasource** habla con la API y con `SharedPreferences`.

> Nota: en la lista de requisitos `SharedPreferences` aparece dos veces; en el proyecto está implementado una sola vez, en el datasource.

---

## Mapa rápido de requisitos

| Requisito | Archivo y línea | Qué hace en pocas palabras |
|---|---|---|
| `GridView` | `lib/presentation/views/inicio_view.dart:37` | Muestra las películas en 2 columnas. |
| `BottomNavigationBar` | `lib/presentation/views/main_screen.dart:52` | Barra inferior con 4 pestañas. |
| Rutas nombradas | `lib/routes/app_routes.dart:7`, `:11`; `lib/main.dart:43` | Navegación con nombres como `/reserva`. |
| `arguments` | `inicio_view.dart:112`; `reserva_view.dart:27` | Envía y recibe la película seleccionada. |
| `Provider` | `lib/main.dart:16`; `inicio_view.dart:23`; `boletos_view.dart:29` | Reparte el ViewModel y escucha cambios. |
| `ChangeNotifier` | `lib/presentation/viewmodels/cine_viewmodel.dart:7` | Avisa a la UI cuando hay datos nuevos. |
| `DatePicker` | `lib/presentation/views/reserva_view.dart:45` | Abre el calendario. |
| `TimePicker` | `lib/presentation/views/reserva_view.dart:58` | Abre el reloj. |
| `SharedPreferences` | `lib/data/datasources/pelicula_local_datasource.dart:39`, `:40`, `:45` | Guarda y lee la última reserva. |
| MVVM | `lib/presentation/`, `lib/domain/`, `lib/data/` | Separa vista, estado y datos. |
| Clean Architecture | `lib/data/`, `lib/domain/`, `lib/presentation/`, `lib/routes/` | Separa la app en capas. |

---

## 1. GridView

### Dónde se usa
`lib/presentation/views/inicio_view.dart:37`

### Cómo se usa

```dart
child: GridView.builder(
  padding: const EdgeInsets.all(16),
  itemCount: viewModel.peliculas.length,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 14,
    mainAxisSpacing: 14,
    childAspectRatio: 0.62,
  ),
  itemBuilder: (context, index) {
    return _tarjetaPelicula(context, viewModel.peliculas[index]);
  },
),
```

### Explicación breve
`GridView.builder` crea una cuadrícula de **2 columnas**. Por cada película que viene del ViewModel, construye una tarjeta con imagen, título, año, género y calificación. Se usa `builder` porque la lista puede crecer sin cargar todo de golpe.

---

## 2. BottomNavigationBar

### Dónde se usa
`lib/presentation/views/main_screen.dart:52`

### Cómo se usa

```dart
bottomNavigationBar: BottomNavigationBar(
  currentIndex: _indice,
  onTap: (indice) => setState(() => _indice = indice),
  items: _items,
),
```

### Explicación breve
Es la barra inferior de 4 botones. La variable `_indice` dice qué pestaña está activa. Al tocar un botón, `setState` cambia el índice y el `Scaffold` muestra otra vista:

```dart
body: _vistas[_indice],
```

Las vistas están en `main_screen.dart:18`:

```dart
static const List<Widget> _vistas = [
  InicioView(),
  BoletosView(),
  AvisosView(),
  PerfilView(),
];
```

---

## 3. Rutas nombradas

### Dónde se usa
- Definición: `lib/routes/app_routes.dart:7` a `:23`
- Registro en la app: `lib/main.dart:43`

### Cómo se usa

```dart
static const String main = '/';
static const String inicio = '/inicio';
static const String reserva = '/reserva';
```

```dart
static Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case inicio:
    case main:
      return MaterialPageRoute(
        builder: (_) => const MainScreen(),
        settings: settings,
      );
    case reserva:
      return MaterialPageRoute(
        builder: (_) => const ReservaView(),
        settings: settings,
      );
    default:
      return MaterialPageRoute(
        builder: (_) => const MainScreen(),
        settings: settings,
      );
  }
}
```

En `lib/main.dart:43`:

```dart
initialRoute: AppRoutes.main,
onGenerateRoute: AppRoutes.generateRoute,
```

### Explicación breve
En vez de escribir pantallas directamente, se usan nombres: `/` para la principal y `/reserva` para reservar. `MaterialApp` pregunta a `generateRoute` qué pantalla crear según el nombre.

---

## 4. Paso de parámetros mediante `arguments`

### Dónde se usa
- Envío: `lib/presentation/views/inicio_view.dart:109`
- Recepción: `lib/presentation/views/reserva_view.dart:27`

### Cómo se envía

```dart
Navigator.pushNamed(
  context,
  AppRoutes.reserva,
  arguments: pelicula,
);
```

### Cómo se recibe

```dart
Pelicula? _obtenerPelicula() {
  final argumentos = ModalRoute.of(context)!.settings.arguments;
  return argumentos is Pelicula ? argumentos : null;
}
```

### Explicación breve
Al tocar una tarjeta se envía el objeto `Pelicula` completo como `arguments`. La pantalla `ReservaView` lo lee con `ModalRoute.of(context)!.settings.arguments` y, si es una película, muestra su imagen, título, descripción, año, género y calificación.

---

## 5. Provider

### Dónde se usa
- Registro: `lib/main.dart:16`
- Consumo: `lib/presentation/views/inicio_view.dart:23` y `lib/presentation/views/boletos_view.dart:29`

### Cómo se usa

```dart
runApp(
  ChangeNotifierProvider(
    create: (_) => CineViewModel(usecase),
    child: const CineApp(),
  ),
);
```

En las vistas:

```dart
body: Consumer<CineViewModel>(
  builder: (context, viewModel, _) {
    ...
  },
),
```

### Explicación breve
`Provider` pone el `CineViewModel` disponible para toda la app. Las vistas usan `Consumer<CineViewModel>` para escucharlo. Cuando el ViewModel cambia, `Consumer` reconstruye solo esa parte de la pantalla.

---

## 6. ChangeNotifier

### Dónde se usa
`lib/presentation/viewmodels/cine_viewmodel.dart:7`

### Cómo se usa

```dart
class CineViewModel extends ChangeNotifier {
  final GestionarCineUseCase _usecase;

  CineViewModel(this._usecase) {
    cargarPeliculas();
    cargarUltimaReserva();
  }
  ...
}
```

Los avisos a la UI están en `cine_viewmodel.dart:30`, `:39`, `:45` y `:51`:

```dart
notifyListeners();
```

### Explicación breve
`ChangeNotifier` es la parte reactiva del ViewModel. Cuando termina de cargar películas, leer la reserva o guardar una nueva, llama a `notifyListeners()`. Eso le dice a `Provider`: “hay datos nuevos, actualiza la pantalla”.

Métodos principales:

- `cargarPeliculas()` (`cine_viewmodel.dart:27`): pide la cartelera al caso de uso.
- `cargarUltimaReserva()` (`cine_viewmodel.dart:43`): lee la reserva guardada.
- `guardarReserva(reserva)` (`cine_viewmodel.dart:48`): guarda la reserva y actualiza el estado.

---

## 7. DatePicker

### Dónde se usa
`lib/presentation/views/reserva_view.dart:45`

### Cómo se usa

```dart
final fecha = await showDatePicker(
  context: context,
  initialDate: _fecha,
  firstDate: DateTime(ahora.year),
  lastDate: DateTime(ahora.year + 2),
  helpText: 'Selecciona la fecha',
);
if (fecha != null && mounted) {
  setState(() => _fecha = fecha);
}
```

### Explicación breve
Al tocar la tarjeta “Fecha”, se abre el calendario de Material 3. Si el usuario elige una fecha, se guarda en `_fecha` con `setState` y se muestra formateada como `dd/mm/aaaa`.

---

## 8. TimePicker

### Dónde se usa
`lib/presentation/views/reserva_view.dart:58`

### Cómo se usa

```dart
final hora = await showTimePicker(
  context: context,
  initialTime: _hora,
  helpText: 'Selecciona la hora',
);
if (hora != null && mounted) {
  setState(() => _hora = hora);
}
```

### Explicación breve
Igual que el calendario, pero para la hora. Devuelve un `TimeOfDay` y se muestra como `HH:mm`. El tema naranja del `MaterialApp` también colorea este diálogo.

---

## 9. SharedPreferences

### Dónde se usa
`lib/data/datasources/pelicula_local_datasource.dart`

### Cómo se usa

Clave:

```dart
static const String _ultimaReservaKey = 'ultima_reserva';
```

Guardar (`pelicula_local_datasource.dart:39`):

```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setString(_ultimaReservaKey, jsonEncode(reserva.toMap()));
```

Leer (`pelicula_local_datasource.dart:44`):

```dart
final prefs = await SharedPreferences.getInstance();
final raw = prefs.getString(_ultimaReservaKey);
if (raw == null) return null;
```

Convertir de JSON a objeto:

```dart
final map = jsonDecode(raw) as Map<String, dynamic>;
return ReservaModel.fromMap(map);
```

### Explicación breve
`SharedPreferences` es como una pequeña memoria permanente del teléfono. Aquí guarda la última reserva como texto JSON. Por eso, al cerrar la app y volver a abrirla, la pestaña **Boletos** sigue mostrando el ticket.

La vista de boletos además fuerza una lectura al entrar (`boletos_view.dart:18`):

```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  if (mounted) {
    context.read<CineViewModel>().cargarUltimaReserva();
  }
});
```

---

## 10. Consumo de la API REST

### Dónde se usa
`lib/data/datasources/pelicula_local_datasource.dart:10` y `:20`

### Cómo se usa

```dart
static const String _urlApi = 'https://devsapihub.com/api-movies';

final response = await _client
    .get(Uri.parse(_urlApi))
    .timeout(const Duration(seconds: 15));
```

Después se decodifica la respuesta:

```dart
final decoded = jsonDecode(response.body);
return decoded
    .whereType<Map<String, dynamic>>()
    .map(PeliculaModel.fromJson)
    .toList();
```

### Explicación breve
Antes había un array fijo de películas; ahora el datasource hace un `GET` con el paquete `http`. Cada objeto JSON se convierte en `PeliculaModel` con `fromJson`, que mapea:

| JSON de la API | Campo en Dart |
|---|---|
| `id` | `id` |
| `title` | `titulo` |
| `description` | `descripcion` |
| `year` | `anio` |
| `image_url` | `imageUrl` |
| `genre` | `generos` |
| `stars` | `calificacion` |

El permiso de internet está en `android/app/src/main/AndroidManifest.xml:2`.

---

## 11. MVVM

### Dónde está cada parte

| Parte MVVM | Ubicación |
|---|---|
| **Model** | `lib/domain/entities/pelicula.dart:1`, `lib/domain/entities/reserva.dart:3`, `lib/data/models/pelicula_model.dart:3`, `lib/data/models/reserva_model.dart:4` |
| **View** | `lib/presentation/views/` (`inicio_view.dart:8`, `reserva_view.dart:11`, `boletos_view.dart:7`, `main_screen.dart:8`, `avisos_view.dart:3`, `perfil_view.dart:3`) |
| **ViewModel** | `lib/presentation/viewmodels/cine_viewmodel.dart:7` |

### Cómo se usa

La vista no llama a la API ni a SharedPreferences directamente. Solo hace:

```dart
final viewModel = context.read<CineViewModel>();
await viewModel.guardarReserva(reserva);
```

o escucha con `Consumer`:

```dart
Consumer<CineViewModel>(
  builder: (context, viewModel, _) {
    final reserva = viewModel.ultimaReserva;
    ...
  },
)
```

### Explicación breve
MVVM evita que las pantallas tengan lógica pesada. La vista pregunta y muestra; el ViewModel decide y avisa. Por eso `ReservaView` puede concentrarse en fecha, hora, asientos y diálogos, sin saber si los datos vienen de red o de memoria local.

---

## 12. Clean Architecture

### Capas y ubicación

```text
lib/
├── data/
│   ├── datasources/pelicula_local_datasource.dart   ← API + SharedPreferences
│   ├── models/                                      ← JSON ↔ objetos
│   └── repositories/cine_repository_impl.dart       ← implementación
├── domain/
│   ├── entities/                                    ← Pelicula, Reserva
│   ├── repositories/cine_repository.dart            ← contrato
│   └── usecases/gestionar_cine_usecase.dart         ← acciones
├── presentation/
│   ├── viewmodels/cine_viewmodel.dart               ← estado
│   └── views/                                       ← pantallas
└── routes/app_routes.dart                           ← navegación
```

### Cómo se usa el flujo

```text
InicioView / ReservaView / BoletosView
        ↓ Consumer / context.read
CineViewModel
        ↓
GestionarCineUseCase
        ↓
CineRepository (interfaz)
        ↓
CineRepositoryImpl
        ↓
PeliculaLocalDatasource
        ↓
API REST  +  SharedPreferences
```

Clases clave:

- Contrato: `lib/domain/repositories/cine_repository.dart:4`
- Implementación: `lib/data/repositories/cine_repository_impl.dart:7`
- Caso de uso: `lib/domain/usecases/gestionar_cine_usecase.dart:5`
- Datasource: `lib/data/datasources/pelicula_local_datasource.dart:9`

### Explicación breve
Clean Architecture separa responsabilidades. Si mañana cambias la API o cambias SharedPreferences por otra base de datos, las pantallas no se tocan: solo cambias la capa `data`. El ViewModel tampoco conoce `http`: solo conoce al caso de uso.

---

## 13. Tema negro / naranja

### Dónde se usa
`lib/main.dart:28`

### Cómo se usa

```dart
final esquema = ColorScheme.fromSeed(
  seedColor: const Color(0xFFFF6D00),
  brightness: Brightness.dark,
).copyWith(
  primary: const Color(0xFFFF7A1A),
  onPrimary: Colors.black,
  secondary: const Color(0xFFFFB74D),
  surface: const Color(0xFF121216),
  onSurface: Colors.white,
);
```

Además se configuran `appBarTheme`, `cardTheme`, `bottomNavigationBarTheme`, `filledButtonTheme`, `dialogTheme` y `progressIndicatorTheme` para que todo el app tenga el mismo estilo cine oscuro.

### Explicación breve
El color naranja es el acento principal; el fondo es casi negro (`#08080B`). Las tarjetas son gris oscuro con borde naranja tenue, y los botones/diálogos/progreso usan naranja para destacar sobre el fondo oscuro.

---

## 14. Resumen final en una frase

**En `lib/presentation/views/` están las pantallas, en `lib/presentation/viewmodels/` está el estado, en `lib/domain/` están las reglas, en `lib/data/` están la API y SharedPreferences, y en `lib/routes/` está la navegación con rutas nombradas y `arguments`.**

---

## Comandos para verificar

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Estado actual: `flutter analyze` sin issues y `flutter test` con 2 pruebas superadas.
