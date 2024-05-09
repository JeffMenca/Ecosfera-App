import 'dart:convert';
import 'package:ecosfera/presentation/models/weather_record.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://cyt.cunoc.edu.gt/index.php/Ultimo-Registro";

  Future<WeatherRecord> fetchWeatherRecord() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/Cunoc'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return WeatherRecord.fromJson(jsonData);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: $e');
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}

