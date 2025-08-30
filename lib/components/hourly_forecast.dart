// File: lib/widgets/hourly_weather_item.dart

import 'package:flutter/material.dart';

class HourlyItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;

  const HourlyItem({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          time,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(8),
          
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        SizedBox(height: 10),
        Text(
          temp,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}