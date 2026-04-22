import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/weather_data.dart';

class WeatherRemoteDataSource {
  static const String _cacheKey = 'cached_weather_data';
  static const String _cacheTimeKey = 'cached_weather_timestamp';

  /// Fetches the dynamic weather based on current location
  Future<WeatherData> getDynamicWeather() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 1. Check Cache
    final int? lastFetchTime = prefs.getInt(_cacheTimeKey);
    final String? cachedData = prefs.getString(_cacheKey);

    if (lastFetchTime != null && cachedData != null) {
      final DateTime lastFetch = DateTime.fromMillisecondsSinceEpoch(
        lastFetchTime,
      );
      final Duration difference = DateTime.now().difference(lastFetch);

      // If cache is younger than 15 minutes, reuse it
      if (difference.inMinutes < 15) {
        return WeatherData.fromJson(
          jsonDecode(cachedData) as Map<String, dynamic>,
        );
      }
    }

    try {
      // 2. Get Location
      final Position position = await _getCurrentLocation();

      // 3. Fetch from Open-Meteo (100% Free, No Key Required)
      final Uri url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=${position.latitude}&longitude=${position.longitude}&current_weather=true',
      );

      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;

        // 4. Update Cache
        await prefs.setString(_cacheKey, response.body);
        await prefs.setInt(
          _cacheTimeKey,
          DateTime.now().millisecondsSinceEpoch,
        );

        return WeatherData.fromJson(data);
      } else {
        // Fallback to cache if request fails
        if (cachedData != null) {
          return WeatherData.fromJson(
            jsonDecode(cachedData) as Map<String, dynamic>,
          );
        }

        // Final Fallback: Simulated for UI health
        final bool isNightTime =
            DateTime.now().hour < 6 || DateTime.now().hour > 19;
        return WeatherData(
          temperature: isNightTime ? 22.0 : 25.0,
          condition: 'Simulated',
          isNight: isNightTime,
        );
      }
    } catch (e) {
      // Emergency Fallback (e.g. Permission Denied or Offline)
      final bool isNightTime =
          DateTime.now().hour < 6 || DateTime.now().hour > 18;

      return WeatherData(
        temperature: isNightTime ? 22.0 : 25.0,
        condition: 'Offline',
        isNight: isNightTime,
      );
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    );
  }
}
