
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/theme/theme_provider.dart';
import 'package:weather_app/theme/theme.dart';
import 'package:weather_app/services/weather_provider.dart'; // NEW: Import the weather provider


// Settings Page
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  // final String _temperatureUnit = 'Celsius';
  String _temperatureUnit = 'Celsius'; // Make this a state variable
  final String _language = 'English';

  @override
  void initState() {
    super.initState();
    // NEW: Get the initial unit from the provider
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    _temperatureUnit = weatherProvider.isFahrenheit ? 'Fahrenheit' : 'Celsius';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeData == darkMode;
    
    return Scaffold(
      body: Stack(
        children: [
          // Clean background that adapts to theme
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Clean settings header
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.settings_rounded,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Settings',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Settings sections
                  Expanded(
                    child: ListView(
                      children: [
                        _buildSettingsSection(
                          'Appearance',
                          Icons.brightness_6_rounded,
                          [
                            _buildSettingsItem(
                              'Dark Mode',
                              'Toggle between light and dark theme',
                              Icons.dark_mode_outlined,
                              trailing: Switch(
                                value: isDarkMode,
                                onChanged: (value) {
                                  themeProvider.toggleTheme();
                                },
                                activeColor: Theme.of(context).colorScheme.onSurface,
                                activeTrackColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                inactiveThumbColor: Colors.grey,
                                inactiveTrackColor: Colors.grey.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        _buildSettingsSection(
                          'General',
                          Icons.tune_rounded,
                          [
                            _buildSettingsItem(
                              'Notifications',
                              'Get weather alerts and updates',
                              Icons.notifications_outlined,
                              trailing: Switch(
                                value: _notificationsEnabled,
                                onChanged: (value) => setState(() => _notificationsEnabled = value),
                                activeColor: Theme.of(context).colorScheme.onSurface,
                                activeTrackColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                inactiveThumbColor: Colors.grey,
                                inactiveTrackColor: Colors.grey.withOpacity(0.3),
                              ),
                            ),
                            _buildSettingsItem(
                              'Location Services',
                              'Allow location access for local weather',
                              Icons.location_on_outlined,
                              trailing: Switch(
                                value: _locationEnabled,
                                onChanged: (value) => setState(() => _locationEnabled = value),
                                activeColor: Theme.of(context).colorScheme.onSurface,
                                activeTrackColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                inactiveThumbColor: Colors.grey,
                                inactiveTrackColor: Colors.grey.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 20),
                        
                        _buildSettingsSection(
                          'Preferences',
                          Icons.palette_outlined,
                          [
                            _buildSettingsItem(
                              'Temperature Unit',
                              _temperatureUnit,
                              Icons.thermostat_outlined,
                              trailing: DropdownButton<String>(
                                value: _temperatureUnit,
                                items: <String>['Celsius', 'Fahrenheit'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _temperatureUnit = newValue!;
                                  });
                                  // Call the provider's toggle method
                                  Provider.of<WeatherProvider>(context, listen: false).toggleTemperatureUnit();
                                },
                              ),
                            ),
                            _buildSettingsItem(
                              'Language',
                              'Choose your preferred language',
                              Icons.language_outlined,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _language,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), size: 16),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 20),
                        
                        _buildSettingsSection(
                          'Support & Info',
                          Icons.info_outline_rounded,
                          [
                            _buildSettingsItem(
                              'Privacy Policy',
                              'Read our privacy policy',
                              Icons.privacy_tip_outlined,
                              trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), size: 16),
                            ),
                            _buildSettingsItem(
                              'Terms of Service',
                              'Read terms and conditions',
                              Icons.article_outlined,
                              trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), size: 16),
                            ),
                            _buildSettingsItem(
                              'Help & Support',
                              'Get help with the app',
                              Icons.help_outline_rounded,
                              trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), size: 16),
                            ),
                            _buildSettingsItem(
                              'App Version',
                              '1.0.0',
                              Icons.info_outlined,
                              trailing: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Latest',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 100,)
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
  
  Widget _buildSettingsSection(String title, IconData sectionIcon, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(sectionIcon, color: Theme.of(context).colorScheme.onSurface, size: 20),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
                children: items,
              ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSettingsItem(
    String title, 
    String subtitle, 
    IconData icon, {
    Widget? trailing,
    Color? titleColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 20),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor ?? Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 13,
                      letterSpacing: 0.2,
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),

    );
  }
}