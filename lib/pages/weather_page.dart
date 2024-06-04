import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('5f951abd81bbc1ab5020e83efb970ee7'); // Replace with your actual API key
  final TextEditingController _cityController = TextEditingController();
  Weather? _weather;
  bool _isLoading = false;
  String _errorMessage = '';

  // Fetch weather by city name
  _fetchWeatherByCity() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Get the city name from the text field
      String cityName = _cityController.text.trim();
      print('City name entered: $cityName');

      // Get weather for city
      final weather = await _weatherService.getWeather(cityName);
      print('Fetched weather: ${weather.temperature}°C in ${weather.cityName}');

      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching weather: $e');
      setState(() {
        _errorMessage = 'Failed to load weather data';
        _isLoading = false;
      });
    }
  }

  // Fetch weather by current location
  _fetchWeatherByLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Get the current location
      Position position = await _weatherService.getCurrentLocation();
      print('Current location: ${position.latitude}, ${position.longitude}');

      // Get weather for current location
      final weather = await _weatherService.getWeatherByCoordinates(position.latitude, position.longitude);
      print('Fetched weather: ${weather.temperature}°C in ${weather.cityName}');

      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching weather: $e');
      setState(() {
        _errorMessage = 'Failed to load weather data';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text field for city name
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'Enter city name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Fetch weather by city name button
              ElevatedButton(
                onPressed: _fetchWeatherByCity,
                child: Text('Fetch Weather by City'),
              ),
              SizedBox(height: 16),
              // Fetch weather by current location button
              ElevatedButton(
                onPressed: _fetchWeatherByLocation,
                child: Text('Fetch Weather by Current Location'),
              ),
              SizedBox(height: 32),
              // Loading indicator or error message
              _isLoading
                  ? CircularProgressIndicator()
                  : _errorMessage.isNotEmpty
                  ? Text(_errorMessage)
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // City name
                  Text(_weather?.cityName ?? "Unable to load city"),
                  // Temperature
                  Text('${_weather?.temperature?.round() ?? 'N/A'}°C'),
                  // Main Condition
                  Text(_weather?.mainCondition ?? "N/A"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
