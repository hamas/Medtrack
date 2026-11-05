import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/weather_data.dart';
import '../../data/datasources/weather_remote_data_source.dart';

/// Provider for real-time, cached weather data
final FutureProvider<WeatherData> weatherProvider = FutureProvider<WeatherData>(
  (Ref ref) async {
    final WeatherRemoteDataSource weatherDataSource = WeatherRemoteDataSource();
    return weatherDataSource.getDynamicWeather();
  },
);
