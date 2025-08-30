// Optimized weather_provider.dart
import 'package:flutter/foundation.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; // NEW: Import this package


class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  
  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _error;
  String _currentCity = 'Dar es Salaam'; // Default city
  bool _isFahrenheit = false; // New state for temperature unit

  static const _temperatureUnitKey = 'isFahrenheit'; // NEW: Key for SharedPreferences

  // Constructor
  WeatherProvider() {
    _loadTemperatureUnit(); // NEW: Load the saved preference on initialization
  }

  // Getters
  WeatherData? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentCity => _currentCity;
  bool get isFahrenheit => _isFahrenheit;

  // NEW: Method to load the saved temperature unit
  Future<void> _loadTemperatureUnit() async {
    final prefs = await SharedPreferences.getInstance();
    _isFahrenheit = prefs.getBool(_temperatureUnitKey) ?? false;
    notifyListeners();
  }
  
  // NEW: Method to toggle temperature unit and save the preference
  void toggleTemperatureUnit() async {
    _isFahrenheit = !_isFahrenheit;
    
    // Save the new state to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_temperatureUnitKey, _isFahrenheit);
    
    _weatherData = null; 
    notifyListeners();
    fetchWeatherData(); 
  }
  
  // NEW: Method to clear weather data when changing cities
  void clearWeatherData() {
    _weatherData = null;
    _error = null;
    notifyListeners();
  }
  
  // NEW: Check if we have data for the requested city
  bool hasDataForCity(String cityName) {
    return _weatherData != null && 
           _currentCity.toLowerCase() == cityName.toLowerCase() && 
           _error == null;
  }
  
  // NEW: Set the current city (for when a new city is selected)
  void setCurrentCity(String cityName) {
    if (_currentCity.toLowerCase() != cityName.toLowerCase()) {
      _currentCity = cityName;
      clearWeatherData(); // Clear existing data when city changes
    }
  }
  
  // Fetch weather data for a city
  Future<void> fetchWeatherData([String? cityName]) async {
    final city = cityName ?? _currentCity;
    
    // Update current city if a new one is provided
    if (cityName != null && cityName.toLowerCase() != _currentCity.toLowerCase()) {
      _currentCity = cityName;
    }
    
    // OPTIMIZATION: Skip if we already have data for this city and no error
    if (hasDataForCity(city) && !_isLoading) {
      print('Weather data already available for $city, skipping fetch');
      return;
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      print('Fetching weather data for $city...');
      
      // Step 1: Search for the location
      final List<Map<String, dynamic>> locations = await _weatherService.searchLocation(city);
      
      if (locations.isEmpty) {
        throw Exception('Location "$city" not found. Please check your spelling and try again.');
      }
      
      final String validLocation = locations.first['name'];
      final String country = locations.first['country'] ?? 'N/A';
      
      print('Found location: $validLocation, $country');
      
      // Step 2: Fetch current weather data
      final Map<String, dynamic> weatherDataJson = await _weatherService.fetchWeather(validLocation);
      
      // Step 3: Fetch historical data for yesterday
      final DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
      final String yesterdayDate = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
      final Map<String, dynamic> historicalDataJson = await _weatherService.fetchHistory(validLocation, yesterdayDate);
      
      // Parse all the data
      _weatherData = _parseWeatherData(weatherDataJson, historicalDataJson);
      _currentCity = city;
      _error = null;
      
      print('Weather data successfully loaded for $_currentCity');
      
    } catch (e) {
      _error = e.toString();
      _weatherData = null; // Clear data on error
      print('Error fetching weather data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // NEW: Force refresh data (for pull-to-refresh)
  Future<void> refreshWeatherData() async {
    _weatherData = null; // Clear existing data to force refresh
    await fetchWeatherData(_currentCity);
  }
  
  WeatherData _parseWeatherData(Map<String, dynamic> weatherJson, Map<String, dynamic> historicalJson) {
    final Map<String, dynamic> current = weatherJson['current'];
    final Map<String, dynamic> location = weatherJson['location'];
    final Map<String, dynamic> forecastDay = weatherJson['forecast']['forecastday'][0];
    final Map<String, dynamic> astro = forecastDay['astro'];
    
    
    // Helper function for conversion
    double convertTemp(double celsius) {
      return _isFahrenheit ? (celsius * 9 / 5) + 32 : celsius;
    }


    // Parse hourly forecast
    List<HourlyForecast> hourlyForecast = [];
    final List<dynamic> hourlyList = forecastDay['hour'];
    for (var item in hourlyList) {
      hourlyForecast.add(
        HourlyForecast(
          time: item['time'].toString().substring(11, 16),
          // temperature: item['temp_c'].toDouble(),
          temperature: convertTemp(item['temp_c'].toDouble()),
          condition: item['condition']['text'],
          iconUrl: 'https:${item['condition']['icon']}',
          precipitationChance: item['chance_of_rain'].toInt(),
          uvIndex: item['uv'].toDouble(),
        ),
      );
    }
    
    // Parse daily forecast
    List<DailyForecast> dailyForecast = [];
    final List<dynamic> dailyList = weatherJson['forecast']['forecastday'];
    for (var item in dailyList) {
      dailyForecast.add(
        DailyForecast(
          date: item['date'],
          maxTemp: convertTemp(item['day']['maxtemp_c'].toDouble()),
          minTemp: convertTemp(item['day']['mintemp_c'].toDouble()),
          condition: item['day']['condition']['text'],
          iconUrl: 'https:${item['day']['condition']['icon']}',
          precipitation: item['day']['totalprecip_mm'].toDouble(),
          humidity: item['day']['avghumidity'].toDouble(),
          uvIndex: item['day']['uv'].toDouble(),
        ),
      );
    }
    
    // Parse historical data
    final Map<String, dynamic> historyDay = historicalJson['forecast']['forecastday'][0];
    final List<HistoricalHourlyForecast> historicalHourly = [];
    final List<dynamic> historyHourList = historyDay['hour'];
    for (var item in historyHourList) {
      historicalHourly.add(
        HistoricalHourlyForecast(
          time: item['time'].toString().substring(11, 16),
          temperature: convertTemp(item['temp_c'].toDouble()),
          condition: item['condition']['text'],
          iconUrl: 'https:${item['condition']['icon']}',
          precipitation: item['precip_mm'].toDouble(),
        ),
      );
    }
    
    final HistoricalDailyForecast historicalDaily = HistoricalDailyForecast(
      date: historyDay['date'],
      maxTemp: convertTemp(historyDay['day']['maxtemp_c'].toDouble()),
      minTemp: convertTemp(historyDay['day']['mintemp_c'].toDouble()),
      condition: historyDay['day']['condition']['text'],
      iconUrl: 'https:${historyDay['day']['condition']['icon']}',
      precipitation: historyDay['day']['totalprecip_mm'].toDouble(),
      humidity: historyDay['day']['avghumidity'].toDouble(),
    );
    
    final HistoricalData historicalData = HistoricalData(
      hourly: historicalHourly,
      daily: historicalDaily,
    );
    
    return WeatherData(
      location: location['name'],
      country: location['country'] ?? 'N/A',
      localTime: location['localtime'],
      // temperature: current['temp_c'].toDouble(),
      temperature: convertTemp(current['temp_c'].toDouble()),
      condition: current['condition']['text'],
      iconUrl: 'https:${current['condition']['icon']}',
      humidity: current['humidity'].toDouble(),
      pressure: current['pressure_mb'].toDouble(),
      visibility: current['vis_km'].toDouble(),
      precipitation: current['precip_mm'].toDouble(),
      windSpeed: current['wind_kph'].toDouble(),
      windDirection: current['wind_dir'],
      uvIndex: current['uv'].toDouble(),
      uvDescription: _getUvDescription(current['uv'].toDouble()),
      feelsLike: current['feelslike_c'].toDouble(),
      dewPoint: 0.0,
      sunrise: astro['sunrise'],
      sunset: astro['sunset'],
      moonPhase: astro['moon_phase'],
      moonIllumination: astro['moon_illumination'],
      moonset: astro['moonset'],
      daysToFullMoon: _calculateDaysToFullMoon(astro['moon_phase']),
      hourlyForecast: hourlyForecast,
      dailyForecast: dailyForecast,
      historicalData: historicalData,
    );
  }
  
  String _getUvDescription(double uv) {
    if (uv <= 2) return 'Low';
    if (uv <= 5) return 'Moderate';
    if (uv <= 7) return 'High';
    if (uv <= 10) return 'Very High';
    return 'Extreme';
  }
  
  int _calculateDaysToFullMoon(String moonPhase) {
    switch (moonPhase) {
      case 'New Moon':
        return 15;
      case 'Waxing Crescent':
        return 10;
      case 'First Quarter':
        return 7;
      case 'Waxing Gibbous':
        return 3;
      case 'Full Moon':
        return 0;
      case 'Waning Gibbous':
        return 3;
      case 'Last Quarter':
        return 7;
      case 'Waning Crescent':
        return 10;
      default:
        return -1;
    }
  }
}