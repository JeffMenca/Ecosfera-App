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
        return 'https://picjj.com/images/2024/05/10/F384f.gif';
      case 'calor húmedo':
        return 'https://picjj.com/images/2024/05/10/F384f.gif';
      case 'frío seco':
        return 'https://picjj.com/images/2024/05/10/F3v7v.gif';
      case 'frío húmedo':
        return 'https://picjj.com/images/2024/05/10/F3v7v.gif';
      case 'clima agradable':
        return 'https://picjj.com/images/2024/05/10/F384f.gif';
      case 'húmedo y cómodo':
        return 'https://picjj.com/images/2024/05/10/F384f.gif';
      case 'nublado':
        return 'https://picjj.com/images/2024/05/10/F3v7v.gif';
      case 'lluvioso':
        return 'https://picjj.com/images/2024/05/10/F3XlU.gif';
      case 'soleado':
        return 'https://picjj.com/images/2024/05/10/F384f.gif';
      default:
        return 'https://picjj.com/images/2024/05/10/F384f.gif';
    }
  }
}
