import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_data.freezed.dart';

@freezed
abstract class WeatherData with _$WeatherData {
  const WeatherData._();

  const factory WeatherData({
    required double temperature,
    required String condition,
    required bool isNight,
  }) = _WeatherData;

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    // Handle Open-Meteo structure mapping if necessary, or use standard if structure matches
    // Since we mapped it manually before, we can keep the manual logic but link to the constructor
    final Map<String, dynamic> current =
        json['current_weather'] as Map<String, dynamic>;

    final double temp = (current['temperature'] as num).toDouble();
    final int weatherCode = current['weathercode'] as int;
    final int isDayFlag = current['is_day'] as int;

    return WeatherData(
      temperature: temp,
      condition: _mapWeatherCode(weatherCode),
      isNight: isDayFlag == 0,
    );
  }

  static String _mapWeatherCode(int code) {
    if (code == 0) return 'Clear';
    if (code <= 3) return 'Partly Cloudy';
    if (code <= 48) return 'Foggy';
    if (code <= 67) return 'Rainy';
    if (code <= 77) return 'Snowy';
    if (code <= 82) return 'Rain Showers';
    if (code <= 99) return 'Thunderstorm';
    return 'Cloudy';
  }

  // Helper for cache serialization
  Map<String, dynamic> toCacheJson() {
    return <String, dynamic>{
      'current_weather': <String, dynamic>{
        'temperature': temperature,
        'weathercode': 0,
        'is_day': isNight ? 0 : 1,
      },
    };
  }
}
