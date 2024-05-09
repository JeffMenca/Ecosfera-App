class WeatherRecord {
  final String fechaHora;
  final double temperatura;
  final String humedad;
  final String radiacion;
  final double suelo1;
  final double suelo2;
  final double suelo3;
  final double direccion;
  final double velocidad;
  final String precipitacion;

  WeatherRecord({
    required this.fechaHora,
    required this.temperatura,
    required this.humedad,
    required this.radiacion,
    required this.suelo1,
    required this.suelo2,
    required this.suelo3,
    required this.direccion,
    required this.velocidad,
    required this.precipitacion,
  });

  factory WeatherRecord.fromJson(Map<String, dynamic> json) {
    return WeatherRecord(
      fechaHora: json['fechahora'],
      temperatura: double.parse(json['temperatura']),
      humedad: json['humedad'],
      radiacion:json['radiacion'],
      suelo1: double.parse(json['suelo1']),
      suelo2: double.parse(json['suelo2']),
      suelo3: double.parse(json['suelo3']),
      direccion: double.parse(json['direccion']),
      velocidad: double.parse(json['velocidad']),
      precipitacion: json['precipitacion'],
    );
  }
}
