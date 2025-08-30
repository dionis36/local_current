// Filename: weather_data.dart

/// Represents a single hourly forecast data point.
class HourlyForecast {
  final String time;
  final double temperature;
  final String condition;
  final String iconUrl;
  final int precipitationChance;
  final double uvIndex;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.condition,
    required this.iconUrl,
    required this.precipitationChance,
    required this.uvIndex,
  });
}

/// Represents a single daily forecast data point.
class DailyForecast {
  final String date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String iconUrl;
  final double precipitation;
  final double humidity;
  final double uvIndex;

  const DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.iconUrl,
    required this.precipitation,
    required this.humidity,
    required this.uvIndex,
  });
}

/// Represents the historical data for a specific day.
class HistoricalDailyForecast {
  final String date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String iconUrl;
  final double precipitation;
  final double humidity;

  const HistoricalDailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.iconUrl,
    required this.precipitation,
    required this.humidity,
  });
}

/// Represents a single historical hourly data point.
class HistoricalHourlyForecast {
  final String time;
  final double temperature;
  final String condition;
  final String iconUrl;
  final double precipitation;

  const HistoricalHourlyForecast({
    required this.time,
    required this.temperature,
    required this.condition,
    required this.iconUrl,
    required this.precipitation,
  });
}

/// Represents the full set of historical weather data.
class HistoricalData {
  final HistoricalDailyForecast daily;
  final List<HistoricalHourlyForecast> hourly;

  const HistoricalData({
    required this.daily,
    required this.hourly,
  });
}

/// A model class to hold all weather data points.
class WeatherData {
  final String location;
  final String country; // New field for the country
  final String localTime; // New field for the local time
  final double temperature;
  final String condition;
  final String iconUrl;
  final double humidity;
  final double pressure;
  final double visibility;
  final double precipitation;
  final double windSpeed;
  final String windDirection;
  final double uvIndex;
  final String uvDescription;
  final double feelsLike;
  final double dewPoint;
  final String sunrise;
  final String sunset;
  final String moonPhase;
  final int moonIllumination;
  final String moonset;
  final int daysToFullMoon;
  final List<HourlyForecast> hourlyForecast;
  final List<DailyForecast> dailyForecast;
  final HistoricalData? historicalData;
  final bool isFahrenheit; // New field to indicate the temperature unit


  WeatherData({
    required this.location,
    required this.country, // Make sure to add this in the constructor
    required this.localTime, // Make sure to add this in the constructor
    required this.temperature,
    required this.condition,
    required this.iconUrl,
    required this.humidity,
    required this.pressure,
    required this.visibility,
    required this.precipitation,
    required this.windSpeed,
    required this.windDirection,
    required this.uvIndex,
    required this.uvDescription,
    required this.feelsLike,
    required this.dewPoint,
    required this.sunrise,
    required this.sunset,
    required this.moonPhase,
    required this.moonIllumination,
    required this.moonset,
    required this.daysToFullMoon,
    required this.hourlyForecast,
    required this.dailyForecast,
    this.historicalData,
    this.isFahrenheit = false, // Default to Celsius
  });
}