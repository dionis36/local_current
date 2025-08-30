
// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/main_screen.dart'; // Assuming this is your main UI page
import 'package:weather_app/services/weather_provider.dart'; // Your WeatherProvider
import 'package:weather_app/theme/theme_provider.dart'; // Your ThemeProvider
import 'package:flutter_dotenv/flutter_dotenv.dart';


// This asynchronous main function is required to load the .env file
Future<void> main() async {
  // Wait for the .env file to be loaded
  await dotenv.load(fileName: ".env");
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