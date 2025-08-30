// // draggable_component.dart
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:weather_app/pages/weather_details_page.dart';

// class DraggableComponent extends StatelessWidget {
//   final DraggableScrollableController controller;

//   const DraggableComponent({super.key, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       controller: controller,
//       initialChildSize: 0.3,
//       minChildSize: 0.3,
//       maxChildSize: 0.85,
//       builder: (context, scrollController) {
//         return Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.vertical(
//               top: Radius.circular(25),
//             ),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.vertical(
//               top: Radius.circular(25),
//             ),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.25),
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(25),
//                   ),
//                   border: Border.all(
//                     color: Colors.white.withOpacity(0.3),
//                     width: 1,
//                   ),
//                 ),
//                 child: ListView(
//                   controller: scrollController,
//                   padding: EdgeInsets.all(20),
//                   children: [
//                     // Drag handle
//                     Center(
//                       child: Container(
//                         width: 40,
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                     ),

//                     SizedBox(height: 20),

//                     // Weekly forecast
//                     _buildDayItem('Tomorrow', Icons.cloud, '13°', '8°'),
//                     _buildDayItem('Tuesday, 13 Oct', Icons.wb_cloudy, '11°', '6°'),
//                     _buildDayItem('Wednesday, 14 Oct', Icons.grain, '16°', '9°'),
//                     _buildDayItem('Thursday', Icons.wb_cloudy, '14°', '8°'),
//                     _buildDayItem('Friday', Icons.cloud, '13°', '6°'),

//                     SizedBox(height: 30),

//                     // Additional details with improved glass cards
//                     Text(
//                       'Weather Details',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                         letterSpacing: 0.5,
//                       ),
//                     ),

//                     SizedBox(height: 20),

//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildImprovedDetailCard(
//                             icon: Icons.water_drop,
//                             title: 'Humidity',
//                             value: '65%',
//                             subtitle: 'Moderate',
//                             description: 'Comfortable humidity level.',
//                           ),
//                         ),
//                         SizedBox(width: 16),
//                         Expanded(
//                           child: _buildImprovedDetailCard(
//                             icon: Icons.air,
//                             title: 'Wind Speed',
//                             value: '12 km/h',
//                             subtitle: 'Light Breeze',
//                             description: 'From northwest direction.',
//                           ),
//                         ),
//                       ],
//                     ),

//                     SizedBox(height: 16),

//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildImprovedDetailCard(
//                             icon: Icons.wb_sunny,
//                             title: 'UV Index',
//                             value: '3',
//                             subtitle: 'Moderate',
//                             description: 'Wear sunscreen when outside.',
//                           ),
//                         ),
//                         SizedBox(width: 16),
//                         Expanded(
//                           child: _buildImprovedDetailCard(
//                             icon: Icons.speed,
//                             title: 'Pressure',
//                             value: '1013 hPa',
//                             subtitle: 'Normal',
//                             description: 'Stable atmospheric pressure.',
//                           ),
//                         ),
//                       ],
//                     ),

//                     SizedBox(height: 20),

//                     // More details button
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => WeatherTestDetailsPage()),
//                         );
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(vertical: 16),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(15),
//                           border: Border.all(
//                             color: Colors.white.withOpacity(0.3),
//                             width: 1,
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'More Details',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600,
//                                 letterSpacing: 0.5,
//                               ),
//                             ),
//                             const SizedBox(width: 16,),
//                             Icon(
//                               Icons.navigate_next_rounded,
//                               color: Colors.white,
//                               size: 25,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 100,)
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildDayItem(String day, IconData icon, String high, String low) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 16, horizontal: 4),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: Colors.white.withOpacity(0.1),
//             width: 0.5,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: Colors.white, size: 24),
//           ),
//           SizedBox(width: 16),
//           Expanded(
//             child: Text(
//               day,
//               style: TextStyle(
//                 fontSize: 17,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.white,
//                 letterSpacing: 0.3,
//               ),
//             ),
//           ),
//           Text(
//             high,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//               color: Colors.white,
//               letterSpacing: 0.3,
//             ),
//           ),
//           SizedBox(width: 12),
//           Text(
//             low,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//               color: Colors.white70,
//               letterSpacing: 0.3,
//             ),
//           ),
//         ],
//       ),
//     );
//   }


//  Widget _buildImprovedDetailCard({
//     required IconData icon,
//     required String title,
//     required String value,
//     required String subtitle,
//     String? description,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: ClipRRect(
//         child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Icon(
//                       icon,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white,
//                         letterSpacing: 0.3,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               SizedBox(height: 12),

//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                   letterSpacing: 0.5,
//                 ),
//               ),

//               Text(
//                 subtitle,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w400,
//                   color: Colors.white70,
//                   letterSpacing: 0.3,
//                 ),
//               ),

//               if (description != null) ...[
//                 SizedBox(height: 8),
//                 Text(
//                   description,
//                   style: TextStyle(
//                     color: Colors.white60,
//                     fontSize: 11,
//                     height: 1.3,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ],
//           ),
//       ),
//     );
//   }
// }