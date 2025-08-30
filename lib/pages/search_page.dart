// Optimized search_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/main_screen.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/services/weather_provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // New import for local storage

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final WeatherService _weatherService = WeatherService();

  bool hasSearched = false;
  bool isSearching = false;
  List<Map<String, dynamic>> searchResults = [];

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  
  // New state variable to store search history
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  // New method to load search history from local storage
  void _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    setState(() {
      _searchHistory = history;
    });
  }

  // New method to save search history to local storage
  void _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('search_history', _searchHistory);
  }

  // New method to clear search history from local storage and state
  void _clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
    setState(() {
      _searchHistory = [];
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        hasSearched = false;
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
      hasSearched = true;
    });

    try {
      final cities = await _weatherService.searchLocation(query);
      setState(() {
        searchResults = cities;
        isSearching = false;
      });
    } catch (e) {
      setState(() {
        isSearching = false;
      });
      print('Error performing search: $e');
    }
  }

  // OPTIMIZED: Just navigate with city name, let WeatherHomePage handle loading
  void _selectCity(String cityName) {
    // New logic to save the selected city to history
    _searchHistory.remove(cityName); // Remove if it already exists to move it to the top
    _searchHistory.insert(0, cityName); // Add it to the beginning
    
    // Keep the history list to a reasonable size (e.g., 10 items)
    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.sublist(0, 10);
    }
    
    _saveSearchHistory(); // Save the updated list

    // Set the new city in the provider
    context.read<WeatherProvider>().setCurrentCity(cityName);
    
    // Navigate immediately to home page with the selected city
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MainScreen(selectedCity: cityName),
      ),
    );
  }

  // New method to build the list of recent searches
  Widget _buildSearchHistoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: _clearSearchHistory,
                child: Text(
                  'Clear History',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _searchHistory.length,
            itemBuilder: (context, index) {
              final query = _searchHistory[index];
              return _buildCityResult(
                query,
                '',
                '',
                query,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchContent() {
    if (isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.onSurface
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Searching...',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    
    // New condition to show search history if available and not actively searching
    if (!hasSearched && _searchHistory.isNotEmpty) {
      return _buildSearchHistoryList();
    }

    if (!hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.search_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Search for any city',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start typing to find weather information',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.location_off_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No cities found',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with a different name',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final city = searchResults[index];
        final String name = city['name'] ?? '';
        final String region = city['region'] != null ? '${city['region']}, ' : '';
        final String country = city['country'] ?? '';
        return _buildCityResult(name, region, country, name);
      },
    );
  }

  Widget _buildCityResult(String name, String region, String country, String fullSearchTerm) {
    return GestureDetector(
      onTap: () => _selectCity(fullSearchTerm),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.location_on_rounded,
                color: Theme.of(context).colorScheme.onSurface,
                size: 20,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                '$name, $region$country',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Search Cities',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: TextField(
                              controller: _searchController,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface, 
                                fontSize: 16
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search for a city...',
                                hintStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded, 
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                                ),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          _searchController.clear();
                                          _performSearch('');
                                        },
                                        child: Icon(
                                          Icons.clear_rounded,
                                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                        ),
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              ),
                              onChanged: _onSearchChanged,
                              onSubmitted: _onSearchChanged,
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: _buildSearchContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
