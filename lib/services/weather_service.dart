import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    try {
      final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));
      print('Weather API response status: ${response.statusCode}');
      print('Weather API response body: ${response.body}');

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load weather data: ${response.body}');
      }
    } catch (e) {
      print('Error in getWeather: $e');
      rethrow;
    }
  }

  Future<Weather> getWeatherByCoordinates(double latitude, double longitude) async {
    try {
      final response = await http.get(Uri.parse('$BASE_URL?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'));
      print('Weather API response status: ${response.statusCode}');
      print('Weather API response body: ${response.body}');

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load weather data: ${response.body}');
      }
    } catch (e) {
      print('Error in getWeatherByCoordinates: $e');
      rethrow;
    }
  }

  Future<Position> getCurrentLocation() async {
    try {
      // Get permission from user
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // Fetch the current location
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print('Current position: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      print('Error in getCurrentLocation: $e');
      rethrow;
    }
  }
}
