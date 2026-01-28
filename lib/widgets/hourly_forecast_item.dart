// hourly_forecast_item.dart
// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/controllers/weather_controller.dart';
import 'package:weather_app/controllers/settings_controller.dart';

class HourlyForecastItem extends StatelessWidget {
  final Map<String, dynamic> forecast;
  final int index;
  final bool isFirstItem;

  const HourlyForecastItem({
    super.key,
    required this.forecast,
    required this.index,
    this.isFirstItem = false,
  });

  @override
  Widget build(BuildContext context) {
    final weatherCtrl = Get.find<WeatherController>();
    final settingsCtrl = Get.find<SettingsController>();
    
    final timestamp = forecast['dt'] as int;
    final temp = forecast['temp'] as double;
    final weatherData = forecast['weather'] as Map<String, dynamic>;
    final condition = weatherData['main'] as String;
    final iconCode = weatherData['icon'] as String;
    
    // Convert timestamp to time
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final hour = dateTime.hour;
    
    // Format time
    String time = isFirstItem ? 'Now' : _formatHour(hour);
    
    // Get icon and color
    final iconInfo = _getIconInfo(condition, iconCode);
    
    // Get pop (probability of precipitation)
    final pop = forecast['pop'] as double? ?? 0.0;
    
    return Container(
      width: 82,
      margin: EdgeInsets.only(
        left: isFirstItem ? 8 : 0,
        right: 12,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Time
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          // Weather icon with pop indicator
          _buildWeatherIcon(iconInfo, pop, condition),
          
          // Temperature
          _buildTemperature(temp, forecast, settingsCtrl.isCelsius.value),
        ],
      ),
    );
  }

  String _formatHour(int hour) {
    return hour < 12
        ? '$hour AM'
        : hour == 12
            ? '12 PM'
            : '${hour - 12} PM';
  }

  Map<String, dynamic> _getIconInfo(String condition, String iconCode) {
    final isDayTime = iconCode.contains('d');
    IconData icon;
    Color color;

    switch (condition.toLowerCase()) {
      case 'clear':
        icon = isDayTime ? Icons.wb_sunny : Icons.nightlight_round;
        color = isDayTime ? Colors.orange : Colors.indigo;
        break;
      case 'clouds':
        icon = Icons.cloud;
        color = Colors.grey;
        break;
      case 'rain':
      case 'drizzle':
        icon = Icons.water_drop;
        color = Colors.blue;
        break;
      case 'thunderstorm':
        icon = Icons.flash_on;
        color = Colors.purple;
        break;
      case 'snow':
        icon = Icons.ac_unit;
        color = Colors.cyan;
        break;
      case 'mist':
      case 'fog':
      case 'haze':
        icon = Icons.cloud;
        color = Colors.grey[600]!;
        break;
      default:
        icon = isDayTime ? Icons.wb_sunny : Icons.nightlight_round;
        color = Colors.white;
    }

    return {'icon': icon, 'color': color};
  }

  Widget _buildWeatherIcon(
      Map<String, dynamic> iconInfo, double pop, String condition) {
    final icon = iconInfo['icon'] as IconData;
    final color = iconInfo['color'] as Color;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.3),
                color.withOpacity(0.1),
              ],
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        
        // Precipitation probability indicator
        if ((condition.toLowerCase().contains('rain') ||
                condition.toLowerCase().contains('snow')) &&
            pop > 0)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '${(pop * 100).round()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTemperature(double temp, Map<String, dynamic> forecast, bool isCelsius) {
    return Column(
      children: [
        Text(
          isCelsius
              ? '${temp.round()}°'
              : '${((temp * 9 / 5) + 32).round()}°',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        // "Feels like" for current hour
        if (index == 0 && forecast.containsKey('feels_like'))
          Text(
            'Feels ${(forecast['feels_like'] as double).round()}°',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 10,
            ),
          ),
      ],
    );
  }
}