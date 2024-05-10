import 'package:flutter/material.dart';
import 'package:ecosfera/presentation/models/weather_record.dart';
import 'package:ecosfera/presentation/services/services.dart';
import 'package:ecosfera/presentation/widgets/custom_card.dart';
import 'package:ecosfera/presentation/widgets/wind_speed_compass.dart';
import 'package:ecosfera/presentation/widgets/custom_card_separated.dart';
import 'package:ecosfera/presentation/Classes/weather_condition_resolver.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPageView(),
    );
  }
}

class MainPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return HomeScreen(
            key: UniqueKey(),
            pageIndex: index,
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';
  final int pageIndex;

  const HomeScreen({super.key, this.pageIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? mapController;
  List<LatLng> locations = [];

  String temperature = 'Sin datos';
  String weatherCondition = "Desconocido";
  String weatherImageUrl =
      'https://cdn-icons-png.freepik.com/512/263/263884.png';
  WeatherConditionResolver weatherResolver = WeatherConditionResolver();

  final ApiService _apiService = ApiService();
  WeatherRecord? _weatherData;
  bool _isLoading = true;
  String? _error;
  String? _dateTimeString;

  @override
  void initState() {
    super.initState();
    locations = [
      LatLng(14.8461641, -91.5385392),
      LatLng(14.856629, -91.621573),
      LatLng(14.809332, -91.450807)
    ];
    String environment = 'Cunoc';
    LatLng _center = const LatLng(14.8461641, -91.5385392);
    if (widget.pageIndex == 1) {
      environment = 'Conce';
      _center = const LatLng(14.856629, -91.621573);
    } else if (widget.pageIndex == 2) {
      environment = 'Cantel';
      _center = const LatLng(14.809332, -91.450807);
    }
    _fetchWeatherData(environment);
    updateMapLocation();
  }
void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (mounted) {
      updateMapLocation();  // Ensure widget is still in tree
    }
  }

  void updateMapLocation() {
    if (mapController != null && locations.isNotEmpty) {
      mapController!
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: locations[widget.pageIndex],
        zoom: 11.0,
      )));
    }
  }

   @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageIndex != widget.pageIndex && mapController != null) {
      updateMapLocation();  // Update location safely
    }
  }

  double? tryParseDouble(String? value) {
    if (value == null) return null;
    double? result;
    try {
      result = double.parse(value);
    } catch (e) {
      result = null;
    }
    return result;
  }

  Future<void> _fetchWeatherData(String enviroment) async {
    setState(() {
      _isLoading = true; // Asegúrate de indicar que la carga está en progreso
    });

    try {
      _weatherData = await _apiService.fetchWeatherRecord(enviroment);
      temperature = "${_weatherData?.temperatura.toStringAsFixed(2)}°";
      // Convertimos los valores de tipo String? a double?
      double? humidity = tryParseDouble(_weatherData?.humedad);
      double? radiation = tryParseDouble(_weatherData?.radiacion);
      double? precipitation = tryParseDouble(_weatherData?.precipitacion);

      // Aquí obtenemos la condición del clima usando la instancia de WeatherConditionResolver
      weatherCondition = weatherResolver.resolveWeatherCondition(
          _weatherData?.temperatura ?? 0, humidity, radiation, precipitation);

      // Ahora obtenemos la URL de la imagen correspondiente a la condición del clima
      weatherImageUrl = weatherResolver.resolveWeatherImage(weatherCondition);
    } catch (e) {
      _error = e.toString();
      print(_error);
      temperature = 'Sin datos';
      weatherCondition = 'Error'; // Provee un mensaje de error más específico
    }

    setState(() {
      _isLoading = false; // Finaliza la carga y actualiza la UI
    });
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFF1E2123);
    Color appBarColor = const Color(0xFF1B1D1F);

    if (widget.pageIndex == 1) {
      backgroundColor = const Color(0xFF1A1E23)!;
      appBarColor = const Color(0xFF1B1D1F)!;
    } else if (widget.pageIndex == 2) {
      backgroundColor = const Color(0xFF1B2128)!;
      appBarColor = const Color(0xFF1B1D1F)!;
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
            100.0), // Ajusta la altura del AppBar según sea necesario
        child: AppBar(
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Image.network(
                    'https://picjj.com/images/2024/05/10/FxCbv.png',
                    fit: BoxFit.contain,
                    width: 200.0,
                    height: 200.0,
                  ),
                ),
                if (_dateTimeString != null)
                  Text(
                    _dateTimeString!,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 204, 204, 204),
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          backgroundColor: const Color(0xFF1B1D1F),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(
                0), // Altura 0 para evitar la línea debajo
            child: Container(
              margin: const EdgeInsets.only(top: 10,bottom: 15),
              padding: const EdgeInsets.only(left: 30),
              alignment: Alignment.centerLeft,
              height: 20,
              child: _weatherData != null && _weatherData!.fechaHora != null
                  ? Text(
                      _weatherData!.fechaHora!,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 193, 193, 193),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        color: backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        temperature,
                        style: const TextStyle(
                            fontSize: 50.0, color: Colors.white),
                      ),
                      const SizedBox(
                          height: 10), // Espacio entre los dos textos
                      Text(
                        weatherCondition,
                        style:
                            TextStyle(fontSize: 15.0, color: Colors.grey[350]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20), // Espacio entre los dos elementos
                Image.network(
                  weatherImageUrl,
                  fit: BoxFit.contain,
                  width: 110.0,
                  height: 110.0,
                ),
              ],
            ),
            const SizedBox(height: 20), // Espacio entre los dos elementos

            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 20), // Agregar padding solo en Y
              decoration: BoxDecoration(
                color: const Color(0xFF20232A), // Color de fondo
                borderRadius:
                    BorderRadius.circular(10), // Opcional: bordes redondeados
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomCard(
                      icon: 'https://picjj.com/images/2024/05/10/FQHHH.gif',
                      data: _weatherData?.humedad != null
                          ? '${double.parse(_weatherData!.humedad).toStringAsFixed(2)}%' // Convierte a double, redondea a dos decimales y agrega el símbolo de porcentaje
                          : 'sin datos',
                      title: 'Humedad'),
                  CustomCard(
                      icon: 'https://picjj.com/images/2024/05/10/FI0rP.gif',
                      data: _weatherData?.radiacion != null
                          ? '${double.parse(_weatherData!.radiacion).toStringAsFixed(2)} mSv' // Convierte a double, redondea a dos decimales y agrega el símbolo de porcentaje
                          : 'sin datos',
                      title: 'Radiación'),
                  CustomCard(
                      icon: 'https://picjj.com/images/2024/05/10/FO7MD.gif',
                      data: _weatherData?.precipitacion != null
                          ? '${double.parse(_weatherData!.precipitacion).toStringAsFixed(2)}%' // Convierte a double, redondea a dos decimales y agrega el símbolo de porcentaje
                          : 'sin datos',
                      title: 'Precipitación'),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: CustomCardSeparated(
                      icon: 'https://picjj.com/images/2024/05/09/pAJJI.png',
                      data: _weatherData?.suelo1 != null
                          ? '${double.parse(_weatherData!.humedad).toStringAsFixed(2)}%'
                          : 'sin datos',
                      title: 'Suelo 1',
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: CustomCardSeparated(
                      icon: 'https://picjj.com/images/2024/05/09/pADQ2.png',
                      data: _weatherData?.suelo2 != null
                          ? '${double.parse(_weatherData!.humedad).toStringAsFixed(2)}%'
                          : 'sin datos',
                      title: 'Suelo 2',
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: CustomCardSeparated(
                      icon: 'https://picjj.com/images/2024/05/09/pARE1.png',
                      data: _weatherData?.suelo3 != null
                          ? '${double.parse(_weatherData!.humedad).toStringAsFixed(2)}%'
                          : 'sin datos',
                      title: 'Suelo 3',
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 20), // Agregar padding solo en Y
              decoration: BoxDecoration(
                color: const Color(0xFF20232A), // Color de fondo
                borderRadius:
                    BorderRadius.circular(10), // Opcional: bordes redondeados
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centrar los elementos del Row
                children: [
                  WindSpeedCompass(
                    windDirectionDegrees: _weatherData?.direccion ?? 0,
                    windSpeed: _weatherData?.velocidad ?? 0,
                  ),
                ],
              ),
            ),
            Container(
              height: 100.0, // Altura del contenedor del mapa
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: locations.isNotEmpty ? locations[widget.pageIndex] : LatLng(0, 0),
                  zoom: 11.0,
                ),
                markers: {
                  if (locations.isNotEmpty)
                    Marker(
                      markerId: MarkerId('marker_${widget.pageIndex}'),
                      position: locations[widget.pageIndex],
                    ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
