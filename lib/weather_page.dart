import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // Replace with your OpenWeatherMap API key
  static const String apiKey = '546bae8a69c28d03e249998179f74a99';
  
  Map<String, dynamic>? currentWeather;
  List<dynamic>? forecastData;
  bool isLoading = true;
  String? errorMessage;
  Position? currentPosition;
  String cityName = '';

  @override
  void initState() {
    super.initState();
    _initializeWeatherData();
  }

  Future<void> _initializeWeatherData() async {
    await _getCurrentLocation();
    if (currentPosition != null) {
      await _fetchWeatherData();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            errorMessage = 'Location permission denied';
            isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          errorMessage = 'Location permissions are permanently denied';
          isLoading = false;
        });
        return;
      }

      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          errorMessage = 'Location services are disabled. Please enable location services.';
          isLoading = false;
        });
        return;
      }

      // Get current position
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      print('Location obtained: ${currentPosition!.latitude}, ${currentPosition!.longitude}');
    } catch (e) {
      print('Location error: $e');
      setState(() {
        errorMessage = 'Failed to get location: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchWeatherData() async {
    if (currentPosition == null) {
      setState(() {
        errorMessage = 'Location not available';
        isLoading = false;
      });
      return;
    }

    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      print('Fetching weather data for: ${currentPosition!.latitude}, ${currentPosition!.longitude}');

      // Fetch current weather
      final currentWeatherResponse = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${currentPosition!.latitude}&lon=${currentPosition!.longitude}&appid=$apiKey&units=metric',
        ),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      print('Current weather response status: ${currentWeatherResponse.statusCode}');

      // Fetch 5-day forecast
      final forecastResponse = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=${currentPosition!.latitude}&lon=${currentPosition!.longitude}&appid=$apiKey&units=metric',
        ),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      print('Forecast response status: ${forecastResponse.statusCode}');

      if (currentWeatherResponse.statusCode == 200 && forecastResponse.statusCode == 200) {
        final currentWeatherData = json.decode(currentWeatherResponse.body);
        final forecastResponseData = json.decode(forecastResponse.body);
        
        setState(() {
          currentWeather = currentWeatherData;
          forecastData = forecastResponseData['list'];
          cityName = currentWeatherData['name'] ?? 'Unknown Location';
          isLoading = false;
        });
        
        print('Weather data loaded successfully');
      } else {
        // Handle API errors
        String errorDetail = '';
        if (currentWeatherResponse.statusCode != 200) {
          final errorData = json.decode(currentWeatherResponse.body);
          errorDetail = errorData['message'] ?? 'Weather API error';
        }
        
        setState(() {
          errorMessage = 'Failed to fetch weather data: $errorDetail (Status: ${currentWeatherResponse.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Weather fetch error: $e');
      setState(() {
        errorMessage = 'Network error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Weather Forecast',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.blue.shade600),
            onPressed: _fetchWeatherData,
            tooltip: 'Refresh Weather',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.blue.shade600),
            const SizedBox(height: 16),
            Text(
              'Loading weather data...',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _initializeWeatherData,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchWeatherData,
      color: const Color.fromARGB(255, 78, 165, 241),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildCurrentWeather(),
            _buildWeatherAlerts(),
            _buildHourlyForecast(),
            _buildDailyForecast(),
            const SizedBox(height: 20),
          ],
        ),
        ),
      );
  }

  Widget _buildCurrentWeather() {
    if (currentWeather == null) return const SizedBox();

    final temp = currentWeather!['main']['temp'].round();
    final feelsLike = currentWeather!['main']['feels_like'].round();
    final humidity = currentWeather!['main']['humidity'];
    final windSpeed = currentWeather!['wind']['speed'];
    final description = currentWeather!['weather'][0]['description'];
    final iconCode = currentWeather!['weather'][0]['icon'];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade600,
            const Color.fromARGB(255, 75, 144, 214),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                cityName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$temp°C',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Feels like $feelsLike°C',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.network(
                  'https://openweathermap.org/img/wn/$iconCode@2x.png',
                  width: 80,
                  height: 80,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.wb_sunny,
                      size: 80,
                      color: Colors.white,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherDetail(
                icon: Icons.water_drop,
                label: 'Humidity',
                value: '$humidity%',
              ),
              _buildWeatherDetail(
                icon: Icons.air,
                label: 'Wind',
                value: '${windSpeed.toStringAsFixed(1)} m/s',
              ),
              _buildWeatherDetail(
                icon: Icons.thermostat,
                label: 'Pressure',
                value: '${currentWeather!['main']['pressure']} hPa',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherAlerts() {
    if (currentWeather == null) return const SizedBox();

    // Check for severe weather conditions
    final windSpeed = currentWeather!['wind']['speed'];
    final visibility = currentWeather!['visibility'] ?? 10000;
    final weatherMain = currentWeather!['weather'][0]['main'];
    
    List<String> alerts = [];
    
    if (windSpeed > 10) {
      alerts.add('⚠️ Strong winds detected (${windSpeed.toStringAsFixed(1)} m/s)');
    }
    
    if (visibility < 1000) {
      alerts.add('⚠️ Low visibility conditions');
    }
    
    if (weatherMain == 'Thunderstorm') {
      alerts.add('⚠️ Thunderstorm alert - Stay indoors');
    }
    
    if (weatherMain == 'Rain' && currentWeather!['rain'] != null) {
      final rainVolume = currentWeather!['rain']['1h'] ?? 0;
      if (rainVolume > 5) {
        alerts.add('⚠️ Heavy rainfall detected');
      }
    }

    if (alerts.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: Colors.orange.shade600),
              const SizedBox(width: 8),
              Text(
                'Weather Alerts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...alerts.map((alert) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              alert,
              style: TextStyle(
                color: Colors.orange.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast() {
    if (forecastData == null || forecastData!.isEmpty) return const SizedBox();

    final next24Hours = forecastData!.take(8).toList();

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hourly Forecast',
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: next24Hours.length,
              itemBuilder: (context, index) {
                final hourData = next24Hours[index];
                final time = DateTime.fromMillisecondsSinceEpoch(
                  hourData['dt'] * 1000,
                );
                final temp = hourData['main']['temp'].round();
                final iconCode = hourData['weather'][0]['icon'];

                return Container(
                  width: 85,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${time.hour}:00',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Image.network(
                        'https://openweathermap.org/img/wn/$iconCode.png',
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.wb_sunny,
                            size: 40,
                            color: Colors.orange.shade400,
                          );
                        },
                      ),
                      Text(
                        '$temp°',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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

  Widget _buildDailyForecast() {
    if (forecastData == null || forecastData!.isEmpty) return const SizedBox();

    // Group forecast by day
    Map<String, List<dynamic>> dailyData = {};
    for (var item in forecastData!) {
      final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      final dateKey = '${date.year}-${date.month}-${date.day}';
      
      if (!dailyData.containsKey(dateKey)) {
        dailyData[dateKey] = [];
      }
      dailyData[dateKey]!.add(item);
    }

    final days = dailyData.keys.take(5).toList();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '5-Day Forecast',
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...days.map((dayKey) {
            final dayData = dailyData[dayKey]!;
            final firstItem = dayData.first;
            final date = DateTime.fromMillisecondsSinceEpoch(firstItem['dt'] * 1000);
            
            // Calculate min/max temp for the day
            final temps = dayData.map((item) => item['main']['temp']).toList();
            final minTemp = temps.reduce((a, b) => a < b ? a : b).round();
            final maxTemp = temps.reduce((a, b) => a > b ? a : b).round();
            
            final iconCode = firstItem['weather'][0]['icon'];
            final description = firstItem['weather'][0]['description'];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      _getDayName(date),
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.network(
                      'https://openweathermap.org/img/wn/$iconCode.png',
                      width: 40,
                      height: 40,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.wb_sunny,
                          size: 40,
                          color: Colors.orange.shade400,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    '$minTemp° / $maxTemp°',
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _getDayName(DateTime date) {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    
    if (date.day == now.day && date.month == now.month && date.year == now.year) {
      return 'Today';
    } else if (date.day == tomorrow.day && date.month == tomorrow.month && date.year == tomorrow.year) {
      return 'Tomorrow';
    } else {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[date.weekday - 1];
    }
  }
}