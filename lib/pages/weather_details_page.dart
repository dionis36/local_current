// Fixed weather_details_page.dart with dynamic temperature units
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ADD: Import provider
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/services/weather_provider.dart'; // ADD: Import weather provider

class WeatherDetailsPage extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherDetailsPage({Key? key, required this.weatherData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    
    return Scaffold(
      body: Stack(
        children: [
          // Theme-aware background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Fixed header matching modern design
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Weather Details',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Main content area
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Location & Time Info
                        _buildLocationTimeOverview(context),
                        
                        // Current Weather Overview (large temperature)
                        _buildCurrentWeatherOverview(context),
                        
                        // Hourly Forecast
                        _buildModernHourlyForecast(context),
                        
                        // Weather Stats Grid (upgraded design)
                        _buildModernWeatherStatsGrid(context),
                        
                        // Sun & Moon Information
                        _buildModernSunMoonCard(context),
                        
                        // Daily Forecast
                        _buildModernDailyForecast(context),
                        
                        // Historical Data if available
                        if (weatherData.historicalData != null)
                          _buildModernHistoricalData(context),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTimeOverview(BuildContext context) {
    // Helper function to format the time string from the API
    String formatLocalTime(String dateTimeString) {
      // The API returns 'YYYY-MM-DD HH:mm'. We only need the HH:mm part.
      final parts = dateTimeString.split(' ');
      if (parts.length == 2) {
        return parts[1];
      }
      return dateTimeString;
    }
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${weatherData.location}, ${weatherData.country}', // Display location and country
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.network(
                    weatherData.iconUrl,
                    width: 48,
                    height: 48,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.wb_sunny, size: 48, color: Colors.orange);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CURRENT TIME',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      formatLocalTime(weatherData.localTime), // Use the new local time
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'CONDITION',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      weatherData.condition,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentWeatherOverview(BuildContext context) {
    // FIXED: Get the unit from the provider
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    final unit = weatherProvider.isFahrenheit ? '°F' : '°C';
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          // Large temperature display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${weatherData.temperature.toInt()}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 80,
                  fontWeight: FontWeight.w200,
                  height: 0.8,
                ),
              ),
              Text(
                unit, // FIXED: Use dynamic unit
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 60,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ],
          ),
          
          Text(
            'Feels like ${weatherData.feelsLike.toStringAsFixed(1)}$unit', // FIXED: Use dynamic unit
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernHourlyForecast(BuildContext context) {
    // FIXED: Get the unit from the provider
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    final unit = weatherProvider.isFahrenheit ? '°F' : '°C';
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: Theme.of(context).colorScheme.onSurface,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'HOURLY FORECAST',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: weatherData.hourlyForecast.length,
              separatorBuilder: (context, index) => SizedBox(width: 16),
              itemBuilder: (context, index) {
                final forecast = weatherData.hourlyForecast[index];
                final isNow = index == DateTime.now().hour;
                
                return Container(
                  width: 80,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isNow 
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: isNow 
                        ? Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3))
                        : null,
                  ),
                  child: Column(
                    children: [
                      Text(
                        isNow ? 'Now' : forecast.time,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: isNow ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 8),
                      Image.network(
                        forecast.iconUrl,
                        width: 32,
                        height: 32,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.wb_sunny, size: 32, color: Colors.orange);
                        },
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${forecast.precipitationChance}%',
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${forecast.temperature.toInt()}${unit.substring(1)}', // FIXED: Use dynamic unit symbol only
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'UV: ${forecast.uvIndex.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernWeatherStatsGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: 1.1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildModernStatCard(
            context,
            icon: Icons.water_drop,
            title: 'Humidity',
            value: '${weatherData.humidity.toStringAsFixed(0)}%',
            subtitle: 'Moderate',
            description: 'Comfortable humidity level.',
          ),
          _buildModernStatCard(
            context,
            icon: Icons.compress,
            title: 'Pressure',
            value: '${weatherData.pressure.toStringAsFixed(0)}',
            subtitle: 'hPa',
            description: 'Normal atmospheric pressure.',
          ),
          _buildModernStatCard(
            context,
            icon: Icons.air,
            title: 'Wind Speed',
            value: '${weatherData.windSpeed.toStringAsFixed(1)}',
            subtitle: 'km/h ${weatherData.windDirection}',
            description: 'Light breeze.',
          ),
          _buildModernStatCard(
            context,
            icon: Icons.visibility,
            title: 'Visibility',
            value: '${weatherData.visibility}',
            subtitle: 'km',
            description: 'Clear visibility.',
          ),
          _buildUVIndexCard(context),
          _buildMoonPhaseCard(context),
        ],
      ),
    );
  }

  Widget _buildModernStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    String? description,
  }) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 20,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          Spacer(),
          
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          Text(
            subtitle,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          
          if (description != null) ...[
            SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 10,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUVIndexCard(BuildContext context) {
    Color uvColor = Colors.green;
    if (weatherData.uvIndex > 7) uvColor = Colors.red;
    else if (weatherData.uvIndex > 5) uvColor = Colors.orange;
    else if (weatherData.uvIndex > 2) uvColor = Colors.yellow;

    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: uvColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.wb_sunny,
                  color: uvColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'UV Index',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          Spacer(),
          
          Text(
            '${weatherData.uvIndex.toStringAsFixed(1)}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          Text(
            weatherData.uvDescription,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
          
          SizedBox(height: 4),
          Text(
            weatherData.uvIndex > 5 ? 'Wear sunscreen.' : 'Low exposure risk.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoonPhaseCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.nights_stay,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 20,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Moon Phase',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          Spacer(),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${weatherData.moonIllumination}%',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    weatherData.moonPhase,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '🌔',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernSunMoonCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.wb_sunny,
                color: Theme.of(context).colorScheme.onSurface,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'SUN & MOON TIMES',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Icon(Icons.wb_sunny_outlined, color: Colors.orange, size: 32),
                    SizedBox(height: 8),
                    Text(
                      'Sunrise',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      weatherData.sunrise,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
                width: 1,
                height: 60,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
              
              Expanded(
                child: Column(
                  children: [
                    Icon(Icons.wb_sunny, color: Colors.deepOrange, size: 32),
                    SizedBox(height: 8),
                    Text(
                      'Sunset',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      weatherData.sunset,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernDailyForecast(BuildContext context) {
    // FIXED: Get the unit from the provider
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    final unit = weatherProvider.isFahrenheit ? '°F' : '°C';
    
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Theme.of(context).colorScheme.onSurface,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'DAILY FORECAST',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: weatherData.dailyForecast.length,
            itemBuilder: (context, index) {
              final forecast = weatherData.dailyForecast[index];
              final isToday = index == 0;
              
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isToday 
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        isToday ? 'Today' : _formatDetailedDate(forecast.date),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Image.network(
                      forecast.iconUrl,
                      width: 32,
                      height: 32,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.wb_sunny, size: 32, color: Colors.orange);
                      },
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            forecast.condition,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.water_drop, size: 12, color: Colors.lightBlueAccent),
                              Text(
                                ' ${forecast.precipitation.toStringAsFixed(1)}mm',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(Icons.opacity, size: 12, color: Colors.teal),
                              Text(
                                ' ${forecast.humidity.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${forecast.maxTemp.toStringAsFixed(0)}${unit.substring(1)}', // FIXED: Use dynamic unit symbol only
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '${forecast.minTemp.toStringAsFixed(0)}${unit.substring(1)}', // FIXED: Use dynamic unit symbol only
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModernHistoricalData(BuildContext context) {
    // FIXED: Get the unit from the provider
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    final unit = weatherProvider.isFahrenheit ? '°F' : '°C';
    
    final historicalData = weatherData.historicalData!;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: Theme.of(context).colorScheme.onSurface,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'YESTERDAY\'S WEATHER',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Image.network(
                  historicalData.daily.iconUrl,
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.wb_sunny, size: 40, color: Colors.orange);
                  },
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        historicalData.daily.condition,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'High: ${historicalData.daily.maxTemp.toStringAsFixed(1)}$unit', // FIXED: Use dynamic unit
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Low: ${historicalData.daily.minTemp.toStringAsFixed(1)}$unit', // FIXED: Use dynamic unit
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Precipitation',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      '${historicalData.daily.precipitation.toStringAsFixed(1)} mm',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDetailedDate(String dateString) {
    final date = DateTime.parse(dateString);
    final weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    return '${weekdays[date.weekday % 7]} ${date.day} ${months[date.month - 1]}';
  }
}