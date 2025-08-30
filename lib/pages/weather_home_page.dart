// Optimized weather_home_page.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/weather_details_page.dart';
import 'package:weather_app/services/weather_provider.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key, this.selectedCity});

  final String? selectedCity; // NEW: Accept selected city from search

  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final DraggableScrollableController _controller = DraggableScrollableController();
  
  @override
  void initState() {
    super.initState();
    // OPTIMIZED: Load the selected city or default city
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final weatherProvider = context.read<WeatherProvider>();
      
      if (widget.selectedCity != null) {
        // A specific city was selected from search - always fetch this city's data
        print('Loading weather data for selected city: ${widget.selectedCity}');
        weatherProvider.fetchWeatherData(widget.selectedCity);
      } else if (weatherProvider.weatherData == null && !weatherProvider.isLoading) {
        // No data exists and not already loading, load default city
        print('Loading default weather data');
        weatherProvider.fetchWeatherData();
      }
      // If we already have data and no specific city was selected, do nothing
    });
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Same background as main screen
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/homeBg1.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.8),
                  BlendMode.darken,
                ),
                onError: (exception, stackTrace) {
                  // Fallback gradient if image fails
                },
              ),
            ),
          ),
          // Loading overlay
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Loading Weather Data...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Please wait a moment',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen(BuildContext context, WeatherProvider weatherProvider) {
    return Scaffold(
      body: Stack(
        children: [
          // Same background as main screen
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/homeBg1.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.8),
                  BlendMode.darken,
                ),
                onError: (exception, stackTrace) {},
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.white,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Oops! Something went wrong',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      weatherProvider.error ?? 'Unknown error occurred',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => weatherProvider.fetchWeatherData(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text('Try Again'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Text(
          'No weather data available',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

// Widget _buildLoadingScreen(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Theme.of(context).colorScheme.surface,
//     body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: CircularProgressIndicator(
//               color: Theme.of(context).colorScheme.primary,
//               strokeWidth: 3,
//             ),
//           ),
//           SizedBox(height: 20),
//           Text(
//             'Loading Weather Data...',
//             style: TextStyle(
//               color: Theme.of(context).colorScheme.onSurface,
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

//  Widget _buildErrorScreen(BuildContext context, WeatherProvider weatherProvider) {
//   return Scaffold(
//     backgroundColor: Theme.of(context).colorScheme.surface,
//     body: Center(
//       child: Container(
//         margin: EdgeInsets.all(20),
//         padding: EdgeInsets.all(30),
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(25),
//           border: Border.all(
//             color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
//             width: 1,
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.error_outline,
//               size: 64,
//               color: Theme.of(context).colorScheme.onSurface,
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Oops! Something went wrong',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.onSurface,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               weatherProvider.error ?? 'Unknown error occurred',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
//                 fontSize: 14,
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => weatherProvider.fetchWeatherData(),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
//                 foregroundColor: Theme.of(context).colorScheme.onPrimary,
//                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//               ),
//               child: Text('Try Again'),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

//   Widget _buildNoDataScreen(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Theme.of(context).colorScheme.surface,
//     body: Center(
//       child: Text(
//         'No weather data available',
//         style: TextStyle(
//           color: Theme.of(context).colorScheme.onSurface,
//           fontSize: 18,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     ),
//   );
// }



  Widget _buildTopBar(weatherData) {
    // Helper function to format the time string from the API
    String formatLocalTime(String dateTimeString) {
      final parts = dateTimeString.split(' ');
      if (parts.length == 2) {
        return parts[1];
      }
      return dateTimeString;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weatherData.location}, ${weatherData.country}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Updated at ${formatLocalTime(weatherData.localTime)}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainTemperature(weatherData) {
  // Get the unit from the provider, not from weatherData
  final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
  final unit = weatherProvider.isFahrenheit ? '°F' : '°C';
  
  return Center(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${weatherData.temperature.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 120,
                        fontWeight: FontWeight.w300,
                        height: 1,
                      ),
                    ),
                    TextSpan(
                      text: unit, // Now using the correct unit from provider
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Column(
                children: [
                  Image.network(
                    weatherData.iconUrl,
                    width: 70,
                    height: 70,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.wb_sunny, size: 70, color: Colors.white);
                    },
                  ),
                  Text(
                    weatherData.condition,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Feels like ${weatherData.feelsLike.toStringAsFixed(0)}$unit', // Using correct unit
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  // 2. Update the _buildEnhancedHourlyForecast method
Widget _buildEnhancedHourlyForecast(weatherData) {
  // Get the unit from the provider
  final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
  final unit = weatherProvider.isFahrenheit ? '°F' : '°C';
  
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          child: Text(
            'Today\'s Forecast',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(height: 10),
        Divider(
          color: Colors.white.withOpacity(0.3),
          height: 1,
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
        SizedBox(height: 20),
        Container(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 8),
            itemCount: weatherData.hourlyForecast.length > 6 
                ? 6 
                : weatherData.hourlyForecast.length,
            itemBuilder: (context, index) {
              final forecast = weatherData.hourlyForecast[index];
              final isNow = index == 0;
              
              return Container(
                width: 70,
                margin: EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    Text(
                      isNow ? 'Now' : forecast.time,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: isNow ? BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ) : null,
                      child: Image.network(
                        forecast.iconUrl,
                        width: 35,
                        height: 35,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.wb_sunny, size: 35, color: Colors.white);
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '${forecast.temperature.toStringAsFixed(0)}$unit', // Using correct unit
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    if (forecast.precipitationChance > 0) ...[
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${forecast.precipitationChance}%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
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

  // 3. Update the _buildEnhancedDraggableComponent method
Widget _buildEnhancedDraggableComponent(weatherData) {
  // Get the unit from the provider
  final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
  final unit = weatherProvider.isFahrenheit ? '°F' : '°C';
  
  return DraggableScrollableSheet(
    controller: _controller,
    initialChildSize: 0.3,
    minChildSize: 0.3,
    maxChildSize: 0.9,
    builder: (context, scrollController) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.all(20),
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  SizedBox(height: 25),

                  // Weekly forecast with real data
                  Text(
                    '7-Day Forecast',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),

                  SizedBox(height: 15),

                  ...weatherData.dailyForecast.take(7).map((forecast) {
                    final isToday = forecast.date == DateTime.now().toIso8601String().split('T')[0];
                    return _buildDayItem(
                      isToday ? 'Today' : _formatDate(forecast.date),
                      forecast.iconUrl,
                      '${forecast.maxTemp.toStringAsFixed(0)}$unit', // Using correct unit
                      '${forecast.minTemp.toStringAsFixed(0)}$unit', // Using correct unit
                    );
                  }).toList(),

                  SizedBox(height: 30),

                  // Weather details with real data
                  Text(
                    'Weather Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),

                  SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _buildImprovedDetailCard(
                          icon: Icons.water_drop,
                          title: 'Humidity',
                          value: '${weatherData.humidity.toStringAsFixed(0)}%',
                          subtitle: _getHumidityLevel(weatherData.humidity),
                          description: 'Current humidity level.',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildImprovedDetailCard(
                          icon: Icons.air,
                          title: 'Wind Speed',
                          value: '${weatherData.windSpeed.toStringAsFixed(1)} km/h',
                          subtitle: _getWindLevel(weatherData.windSpeed),
                          description: 'Current wind conditions.',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildImprovedDetailCard(
                          icon: Icons.compress,
                          title: 'Pressure',
                          value: '${weatherData.pressure.toStringAsFixed(0)} hPa',
                          subtitle: _getPressureLevel(weatherData.pressure),
                          description: 'Atmospheric pressure level.',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildImprovedDetailCard(
                          icon: Icons.visibility,
                          title: 'Visibility',
                          value: '${(weatherData.visibility ?? 10).toStringAsFixed(0)} km',
                          subtitle: 'Clear',
                          description: 'Current visibility range.',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 25),

                  // Enhanced more details button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeatherDetailsPage(weatherData: weatherData),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.analytics_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Detailed Weather Analysis',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

  Widget _buildDayItem(String day, String iconUrl, String high, String low) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.network(
              iconUrl,
              width: 24,
              height: 24,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.wb_sunny, color: Colors.white, size: 24);
              },
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ),
          Text(
            high,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(width: 12),
          Text(
            low,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildImprovedDetailCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    String? description,
  }) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),

          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
              letterSpacing: 0.3,
            ),
          ),

          if (description != null) ...[
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 11,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${weekdays[date.weekday % 7]}, ${months[date.month - 1]} ${date.day}';
  }

  String _getHumidityLevel(double humidity) {
    if (humidity < 30) return 'Low';
    if (humidity < 60) return 'Moderate';
    if (humidity < 80) return 'High';
    return 'Very High';
  }

  String _getWindLevel(double windSpeed) {
    if (windSpeed < 5) return 'Calm';
    if (windSpeed < 15) return 'Light Breeze';
    if (windSpeed < 25) return 'Moderate';
    return 'Strong';
  }

  String _getPressureLevel(double pressure) {
    if (pressure < 1000) return 'Low';
    if (pressure < 1020) return 'Normal';
    return 'High';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        if (weatherProvider.isLoading) {
          return _buildLoadingScreen(context);
        }

        if (weatherProvider.error != null) {
          return _buildErrorScreen(context, weatherProvider);
        }

        final weatherData = weatherProvider.weatherData;
        if (weatherData == null) {
          return _buildNoDataScreen(context);
        }

        return Scaffold(
          body: Stack(
            children: [
              // Background image overlay
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/images/homeBg1.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.8),
                      BlendMode.darken,
                    ),
                    onError: (exception, stackTrace) {
                      print('Background image failed to load: $exception');
                    },
                  ),
                ),
              ),

              // Main weather content
              SafeArea(
                child: RefreshIndicator(
                  onRefresh: () => weatherProvider.refreshWeatherData(), // Use new refresh method
                  color: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 
                             MediaQuery.of(context).padding.top,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Column(
                          children: [
                            // Enhanced top bar with glass effect
                            _buildTopBar(weatherData),

                            SizedBox(height: 40),

                            // Main temperature with enhanced glass background
                            _buildMainTemperature(weatherData),

                            SizedBox(height: 20),

                            // Enhanced hourly forecast with horizontal scroll
                            _buildEnhancedHourlyForecast(weatherData),

                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Enhanced draggable component with weather data
              _buildEnhancedDraggableComponent(weatherData),
            ],
          ),
        );
      },
    );
  }
}