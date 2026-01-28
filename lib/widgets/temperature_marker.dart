import 'package:flutter/material.dart';

class TemperatureMarker extends StatefulWidget {
  final String temperature;
  final String condition;
  
  const TemperatureMarker({super.key, 
    required this.temperature,
    required this.condition,
  });
  
  @override
  _TemperatureMarkerState createState() => _TemperatureMarkerState();
}

class _TemperatureMarkerState extends State<TemperatureMarker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show weather details
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent.withOpacity(0.9),
              Colors.blue.withOpacity(0.9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.temperature,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Icon(
              _getWeatherIcon(widget.condition),
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
  
  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear': return Icons.wb_sunny;
      case 'clouds': return Icons.cloud;
      case 'rain': return Icons.grain;
      case 'snow': return Icons.ac_unit;
      case 'thunderstorm': return Icons.flash_on;
      default: return Icons.wb_sunny;
    }
  }
}