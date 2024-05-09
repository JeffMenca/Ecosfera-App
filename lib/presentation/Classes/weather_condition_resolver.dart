class WeatherConditionResolver {
  String resolveWeatherCondition(
      double temperature,
      double? humedad,
      double? radiacion,
      double? precipitacion) {
    if (temperature >= 30 && (humedad ?? 0) < 50) {
      return 'Calor seco';
    } else if (temperature >= 30 && (humedad ?? 0) >= 50) {
      return 'Calor húmedo';
    } else if (temperature < 10 && (humedad ?? 0) < 50) {
      return 'Frío seco';
    } else if (temperature < 10 && (humedad ?? 0) >= 50) {
      return 'Frío húmedo';
    } else if (temperature >= 10 && temperature <= 25 && (humedad ?? 0) < 50) {
      return 'Clima agradable';
    } else if (temperature >= 10 && temperature <= 25 && (humedad ?? 0) >= 50) {
      return 'Húmedo y cómodo';
    } else if ((radiacion ?? 0) < 50 && (precipitacion ?? 0) < 50) {
      return 'Nublado';
    } else if ((radiacion ?? 0) < 50 && (precipitacion ?? 0) >= 50) {
      return 'Lluvioso';
    } else if ((radiacion ?? 0) >= 50 && (precipitacion ?? 0) < 50) {
      return 'Soleado';
    } else {
      return 'Caluroso y húmedo';
    }
  }

  String resolveWeatherImage(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'calor seco':
        return 'https://example.com/calor_seco.png';
      case 'calor húmedo':
        return 'https://example.com/calor_humedo.png';
      case 'frío seco':
        return 'https://example.com/frio_seco.png';
      case 'frío húmedo':
        return 'https://example.com/frio_humedo.png';
      case 'clima agradable':
        return 'https://example.com/clima_agradable.png';
      case 'húmedo y cómodo':
        return 'https://example.com/humedo_comodo.png';
      case 'nublado':
        return 'https://example.com/nublado.png';
      case 'lluvioso':
        return 'https://example.com/lluvioso.png';
      case 'soleado':
        return 'https://example.com/soleado.png';
      default:
        return 'https://example.com/default.png';
    }
  }
}
