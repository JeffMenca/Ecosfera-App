import 'package:flutter/material.dart';
import 'package:ecosfera/presentation/models/weather_record.dart';
import 'package:ecosfera/presentation/services/services.dart';
import 'package:ecosfera/presentation/widgets/custom_card.dart';
import 'package:ecosfera/presentation/widgets/wind_speed_compass.dart';
import 'package:ecosfera/presentation/widgets/custom_card_separated.dart';
import 'package:ecosfera/presentation/Classes/weather_condition_resolver.dart';

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
    String environment = 'Cunoc';
    if (widget.pageIndex == 1) {
      environment = 'Conce';
    } else if (widget.pageIndex == 2) {
      environment = 'Cantel';
    }
    _fetchWeatherData(environment);
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
      //weatherImageUrl = weatherResolver.resolveWeatherImage(weatherCondition);
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
    Color backgroundColor = const Color(0xFF1B1D1F);
    Color appBarColor = const Color(0xFF1B1D1F);

    if (widget.pageIndex == 1) {
      backgroundColor = const Color.fromARGB(255, 128, 246, 161)!;
      appBarColor = Colors.green[800]!;
    } else if (widget.pageIndex == 2) {
      backgroundColor = Colors.redAccent[100]!;
      appBarColor = Colors.red[800]!;
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ecosfera',
              style: TextStyle(color: Color(0xFFF3F3F3)),
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
        ), // Mostrar fecha debajo del título de la aplicación
        backgroundColor: const Color(0xFF1B1D1F),
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(0), // Altura 0 para evitar la línea debajo
          child: Container(
            padding: EdgeInsets.only(left: 16),
            alignment: Alignment.centerLeft,
            height: 20,
            child: _weatherData != null && _weatherData!.fechaHora != null
                ? Text(
                    _weatherData!.fechaHora!,
                    style: TextStyle(color: Color.fromARGB(255, 193, 193, 193)),
                  )
                : SizedBox.shrink(),
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
                  width: 100.0,
                  height: 100.0,
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
                      icon: 'https://picjj.com/images/2024/05/09/pY2Of.png',
                      data: _weatherData?.humedad != null
                          ? '${double.parse(_weatherData!.humedad).toStringAsFixed(2)}%' // Convierte a double, redondea a dos decimales y agrega el símbolo de porcentaje
                          : 'sin datos',
                      title: 'Humedad'),
                  CustomCard(
                      icon: 'https://picjj.com/images/2024/05/09/pEXHU.png',
                      data: _weatherData?.radiacion != null
                          ? '${double.parse(_weatherData!.radiacion).toStringAsFixed(2)} mSv' // Convierte a double, redondea a dos decimales y agrega el símbolo de porcentaje
                          : 'sin datos',
                      title: 'Radiación'),
                  CustomCard(
                      icon: 'https://picjj.com/images/2024/05/09/pE88f.png',
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
          ],
        ),
      ),
    );
  }
}
