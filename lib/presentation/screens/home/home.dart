import 'package:flutter/material.dart';
import 'package:ecosfera/presentation/models/weather_record.dart';
import 'package:ecosfera/presentation/services/services.dart';
import 'package:ecosfera/presentation/widgets/custom_card.dart';

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
  String weatherCondition = 'Tormentas';
  String imageUrl = 'https://cdn-icons-png.freepik.com/512/263/263884.png';

  final ApiService _apiService = ApiService();
  WeatherRecord? _weatherData;
  bool _isLoading = true;
  String? _error;

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
  
  Future<void> _fetchWeatherData(String environment) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var fetchedData = await _apiService.fetchWeatherRecord(environment);
      if (fetchedData != null) {
        setState(() {
          _weatherData = fetchedData;
          temperature = "${_weatherData!.temperatura.toStringAsFixed(2)}°";
          weatherCondition = environment;
          _isLoading = false;
        });
      } else {
        throw Exception('Received null data from the API');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        print(_error);
        temperature = 'Sin datos';
        weatherCondition = 'Error';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Color(0xFF1B1D1F); 
    Color appBarColor = Color(0xFF1B1D1F); 

    if (widget.pageIndex == 1) {
      backgroundColor = const Color.fromARGB(255, 128, 246, 161)!;
      appBarColor = Colors.green[800]!;
    } else if (widget.pageIndex == 2) {
      backgroundColor = Colors.redAccent[100]!;
      appBarColor = Colors.red[800]!;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Ecosfera - Página ${widget.pageIndex + 1}'),
        backgroundColor: appBarColor,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
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
                        style: TextStyle(fontSize: 50.0, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        weatherCondition,
                        style: TextStyle(fontSize: 15.0, color: Colors.grey[350]),
                      ),
                    ],
                  ),
                ),
                Image.network(imageUrl, fit: BoxFit.contain, width: 100.0, height: 100.0),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomCard(icon: Icons.ac_unit, text: _weatherData?.humedad ?? "sin datos"),
                CustomCard(icon: Icons.wb_sunny, text: _weatherData?.radiacion ?? "sin datos"),
                CustomCard(icon: Icons.cloud, text: _weatherData?.precipitacion ?? "sin datos"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
