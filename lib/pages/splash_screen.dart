// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:weather_app/pages/main_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
//   // AnimationController for various animations (e.g., fade, scale)
//   late AnimationController _controller;
//   // Animations for opacity and scale
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize animation controller with a duration
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2), // Total duration for animations
//       vsync: this,
//     );

//     // Define fade animation: from transparent to fully opaque
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.0, 0.7, curve: Curves.easeIn), // Fade in during the first 70% of the duration
//       ),
//     );

//     // Define scale animation: from small to original size
//     _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.3, 1.0, curve: Curves.bounceOut), // Scale up during the last 70% with a bounce
//       ),
//     );

//     // Start the animation
//     _controller.forward();

//     // Set a timer to navigate to the home screen after the splash duration
//     Timer(const Duration(seconds: 3), () {
//       _navigateToHome();
//     });
//   }

//   // Navigates to the Home screen and prevents going back to the splash screen
//   void _navigateToHome() {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => const MainScreen()),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose(); // Dispose the controller to free up resources
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand, // Make the stack expand to fill the screen
//         children: <Widget>[
//           // Background Image (inspired by your reference image)
//           // Replace 'assets/background_weather.jpg' with your actual image path.
//           // Make sure to add the image to your pubspec.yaml under 'assets:'
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('lib/images/homeBg1.jpg'), // Placeholder: add your image here!
//                 fit: BoxFit.cover, // Cover the entire screen
//               ),
//             ),
//             child: Container(
//               // Optional: Add a subtle gradient or color overlay for better text readability
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.black.withOpacity(0.5), // Darker at the bottom
//                     Colors.transparent,           // Transparent at the top
//                   ],
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                 ),
//               ),
//             ),
//           ),
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 // Animated Weather Icon
//                 ScaleTransition(
//                   scale: _scaleAnimation,
//                   child: FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: Icon(
//                       Icons.cloud_queue, // Example weather icon (cloud)
//                       color: Colors.white,
//                       size: 120.0,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20.0), // Spacing between icon and text

//                 // Animated App Name
//                 FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: const Text(
//                     'WeatherWise', // Your app's name
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 48.0,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 2.0,
//                       fontFamily: 'Inter', // Assuming Inter font is available or replaced
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10.0), // Spacing between app name and tagline

//                 // Animated Tagline
//                 FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: const Text(
//                     'Your Accurate Forecast, Instantly', // Your app's tagline
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 18.0,
//                       fontStyle: FontStyle.italic,
//                       fontFamily: 'Inter',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }