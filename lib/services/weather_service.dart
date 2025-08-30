// Filename: weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// A service class to handle all API calls to WeatherAPI.com.
/// It centralizes the network logic, making the rest of the app cleaner.
class WeatherService {
  /// The base URL for the WeatherAPI.com API.
  static const String _baseUrl = 'https://api.weatherapi.com/v1';

  /// Your API key from the WeatherAPI.com website.
  /// This is now a static constant, no longer passed in the constructor.
  String apiKey = dotenv.env['WEATHER_API_KEY']!;

  // A simple way to pass the API key.
  WeatherService();

  /// Searches for cities based on a query using the search/autocomplete API.
  ///
  /// This function takes a [query] string (e.g., 'London') and returns a
  /// list of potential city matches with their geographical coordinates.
  Future<List<Map<String, dynamic>>> searchLocation(String query) async {
    // Construct the URL for the search API endpoint.
    final Uri uri = Uri.parse('$_baseUrl/search.json?key=$apiKey&q=$query');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
        final List<dynamic> json = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(json);
      } else {
        // Handle API errors based on the status code.
        throw Exception('Failed to search for location. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch network errors (e.g., no internet connection).
      throw Exception('An error occurred while fetching location data: $e');
    }
  }

  /// Fetches comprehensive weather data for a given location.
  ///
  /// This function takes the location name [location] and returns current,
  /// hourly, and daily forecast data, as well as astronomy and sports data.
  Future<Map<String, dynamic>> fetchWeather(String location) async {
    // The `forecast.json` endpoint is a comprehensive one.
    // We request 14 days of forecast and astronomy data.
    final Uri uri = Uri.parse('$_baseUrl/forecast.json?key=$apiKey&q=$location&days=14&aqi=no&alerts=no');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
        final Map<String, dynamic> json = jsonDecode(response.body);
        return json;
      } else {
        // Handle API errors based on the status code.
        throw Exception('Failed to load weather data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch network errors (e.g., no internet connection).
      throw Exception('An error occurred while fetching weather data: $e');
    }
  }

  /// Fetches historical weather data for a given location and date.
  ///
  /// The free tier supports up to 7 days of historical data.
  Future<Map<String, dynamic>> fetchHistory(String location, String date) async {
    final Uri uri = Uri.parse('$_baseUrl/history.json?key=$apiKey&q=$location&dt=$date');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return json;
      } else {
        throw Exception('Failed to load historical data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred while fetching historical data: $e');
    }
  }
}

