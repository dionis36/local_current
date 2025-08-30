
// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/main_screen.dart'; // Assuming this is your main UI page
import 'package:weather_app/services/weather_provider.dart'; // Your WeatherProvider
import 'package:weather_app/theme/theme_provider.dart'; // Your ThemeProvider

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => WeatherProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      // Access the theme from the ThemeProvider
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: MainScreen(), // Your main screen which will consume both providers
      debugShowCheckedModeBanner: false,
    );
  }
}