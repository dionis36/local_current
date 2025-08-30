import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:weather_app/pages/home_page.dart';
import 'package:weather_app/pages/search_page.dart';
import 'package:weather_app/pages/settings_page.dart';
import 'package:weather_app/pages/weather_home_page.dart';

class MainScreen extends StatefulWidget {
  final String? selectedCity; // NEW: Accept selected city parameter
  
  const MainScreen({super.key, this.selectedCity});
  // const MainScreen({super.key});

  

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  

  final List<Widget> _pages = [
    WeatherHomePage(),
    SearchPage(),
    SettingsPage(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.onSurface : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: Icon(
            icon,
            key: ValueKey(isSelected),
            color: isSelected ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            size: isSelected ? 24 : 22,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // This will be the main content of your pages
          _pages[_selectedIndex],
          // Google Nav Bar (GNav) with reduced width - now theme-aware
          Positioned(
            left: 50,
            right: 50,
            bottom: 30,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(38),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                  width: 0.5,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: GNav(
                  backgroundColor: Colors.transparent,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  activeColor: Theme.of(context).colorScheme.surface,
                  tabBackgroundColor: Theme.of(context).colorScheme.onSurface,
                  gap: 8,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  selectedIndex: _selectedIndex,
                  onTabChange: _onItemTapped,
                  tabs: [
                    GButton(
                      icon: Icons.home_rounded,
                      text: 'Home',
                    ),
                    GButton(
                      icon: Icons.search,
                      text: 'Search',
                    ),
                    GButton(
                      icon: Icons.person_outline_rounded,
                      text: 'Settings',
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
}

