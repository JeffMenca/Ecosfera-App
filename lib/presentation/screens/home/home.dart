import 'package:ecosfera/presentation/models/weather_record.dart';
import 'package:ecosfera/presentation/services/services.dart';
import 'package:ecosfera/presentation/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:ecosfera/presentation/Classes/weather_condition_resolver.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';
  const HomeScreen({super.key});

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

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
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

  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoading = true; // Asegúrate de indicar que la carga está en progreso
    });

    try {
      _weatherData = await _apiService.fetchWeatherRecord();
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
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Ecosfera', style: TextStyle(color: Color(0xFFF3F3F3))),
        backgroundColor: const Color(0xFF1B1D1F),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        color: const Color(0xFF1B1D1F),
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
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 50.0,
                          color: Color(0xFFF3F3F3),
                        ),
                      ),
                      const SizedBox(
                          height: 10), // Espacio entre los dos textos
                      Text(
                        weatherCondition,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Color.fromARGB(255, 182, 182, 182),
                        ),
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
                      icon: Icons.ac_unit,
                      data: _weatherData?.humedad != null
                          ? '${double.parse(_weatherData!.humedad).toStringAsFixed(2)}%' // Convierte a double, redondea a dos decimales y agrega el símbolo de porcentaje
                          : 'sin datos',
                      title: 'Humedad'),
                  CustomCard(
                      icon: Icons.wb_sunny,
                      data: _weatherData?.radiacion != null
                          ? '${double.parse(_weatherData!.radiacion).toStringAsFixed(2)} mSv' // Convierte a double, redondea a dos decimales y agrega el símbolo de porcentaje
                          : 'sin datos',
                      title: 'Radiación'),
                  CustomCard(
                      icon: Icons.cloud,
                      data: _weatherData?.precipitacion != null
                          ? '${double.parse(_weatherData!.precipitacion).toStringAsFixed(2)}%' // Convierte a double, redondea a dos decimales y agrega el símbolo de porcentaje
                          : 'sin datos',
                      title: 'Precipitación'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
