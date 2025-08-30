// // Filename: weather_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// /// A service class to handle all API calls to OpenWeatherMap.
// /// It centralizes the network logic, making the rest of the app cleaner.
// class WeatherService {
//   /// The base URL for the OpenWeatherMap API.
//   /// We use HTTPS to ensure all data is transferred securely.
//   static const String _baseUrl = 'https://api.openweathermap.org';

//   /// Your API key from the OpenWeatherMap website.
//   /// Replace 'YOUR_API_KEY_HERE' with the key you obtained after signing up.
//   final String apiKey;

//   WeatherService({
//     // A simple way to pass the API key, making it more flexible.
//     this.apiKey = 'd15ad74bf9af8728494a74d668a4a9cf',
//   });

//   // Add a simple cache for search results
//   final Map<String, List<Map<String, dynamic>>> _searchCache = {};

//   /// Searches for cities based on a query using the Geocoding API.
//   ///
//   /// This function takes a [query] string (e.g., 'London') and returns a
//   /// list of potential city matches with their geographical coordinates.
//   Future<List<Map<String, dynamic>>> searchCities(String query) async {
//     // Construct the URL for the geocoding API endpoint.
//     final Uri uri = Uri.parse('$_baseUrl/geo/1.0/direct?q=$query&limit=5&appid=$apiKey');

//     // 1. Normalize the query for caching
//     final normalizedQuery = query.toLowerCase().trim();

//     // 2. Check the cache first
//     if (_searchCache.containsKey(normalizedQuery)) {
//       print('Returning results from cache for: $normalizedQuery');
//       return _searchCache[normalizedQuery]!;
//     }

//     try {
//       final response = await http.get(uri);

//       if (response.statusCode == 200) {
//         // If the server returns a 200 OK response, parse the JSON.
//         final List<dynamic> json = jsonDecode(response.body);
//         final List<Map<String, dynamic>> cities = json.cast<Map<String, dynamic>>();

//         // 3. Store results in the cache before returning
//         _searchCache[normalizedQuery] = cities;
//         return cities;
//       } else {
//         // If the server did not return a 200 OK response,
//         // throw an exception with the status code.
//         throw Exception('Failed to load cities. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Catch any network-related errors.
//       throw Exception('An error occurred while searching for cities: $e');
//     }
//   }

//   /// Fetches the current weather data for a given location.
//   ///
//   /// This function takes the latitude [lat] and longitude [lon] of a city
//   /// and returns the current weather conditions.
//   Future<Map<String, dynamic>> fetchCurrentWeather(double lat, double lon) async {
//     // Construct the URL for the current weather API endpoint.
//     final Uri uri = Uri.parse('$_baseUrl/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey');

//     try {
//       final response = await http.get(uri);

//       if (response.statusCode == 200) {
//         // If the server returns a 200 OK response, parse the JSON.
//         final Map<String, dynamic> json = jsonDecode(response.body);
//         return json;
//       } else {
//         // Handle API errors based on the status code.
//         throw Exception('Failed to load weather data. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Catch network errors (e.g., no internet connection).
//       throw Exception('An error occurred while fetching weather data: $e');
//     }
//   }
  
//   /// Fetches the 5-day/3-hour forecast for a given location.
//   ///
//   /// This function takes the latitude [lat] and longitude [lon] of a city
//   /// and returns a comprehensive forecast data set. The OpenWeatherMap API
//   /// provides data points for every 3 hours. The UI will then need to
//   /// parse this data to display the desired number of hours and days.
//   Future<Map<String, dynamic>> fetchForecastWeather(double lat, double lon) async {
//     // Construct the URL for the forecast API endpoint.
//     final Uri uri = Uri.parse('$_baseUrl/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey');
    
//     try {
//       final response = await http.get(uri);

//       if (response.statusCode == 200) {
//         // If the server returns a 200 OK response, parse the JSON.
//         final Map<String, dynamic> json = jsonDecode(response.body);
//         return json;
//       } else {
//         // Handle API errors based on the status code.
//         throw Exception('Failed to load forecast data. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Catch network errors.
//       throw Exception('An error occurred while fetching forecast data: $e');
//     }
//   }
// }



// Filename: weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class to handle all API calls to WeatherAPI.com.
/// It centralizes the network logic, making the rest of the app cleaner.
class WeatherService {
  /// The base URL for the WeatherAPI.com API.
  static const String _baseUrl = 'https://api.weatherapi.com/v1';

  /// Your API key from the WeatherAPI.com website.
  /// This is now a static constant, no longer passed in the constructor.
  static const String apiKey = 'e99d2167e25642b98e0191709251808';

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

