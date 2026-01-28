// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/forecast_model.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/utils/app_constants.dart';

class WeatherController extends GetxController {
  RxString cityName = 'Hafizabad'.obs;
  RxString country = ''.obs;
  RxDouble temperature = 0.0.obs;
  RxString weatherCondition = ''.obs;
  RxString weatherIcon = ''.obs;
  RxString weatherDescription = ''.obs;
  RxDouble feelsLike = 0.0.obs;
  RxInt humidity = 0.obs;
  RxDouble windSpeed = 0.0.obs;
  RxInt pressure = 0.obs;
  RxInt visibility = 0.obs;
  RxString sunrise = ''.obs;
  RxString sunset = ''.obs;
  RxBool isLoading = false.obs;
  RxDouble tempMax = 0.0.obs;
  RxDouble tempMin = 0.0.obs;
  Rx<Forecast?> forecastData = Rx<Forecast?>(null);
  RxList<Map<String, dynamic>> dailyForecasts = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> hourlyForecastsToday =
      <Map<String, dynamic>>[].obs;
  RxBool isForecastLoading = false.obs;
  RxString selectedForecastDay = 'Today'.obs;
  RxBool isAirPollutionLoading = false.obs;
  AppConstants appConstants = AppConstants();

  var baeseUrl = AppConstants.apiBaseUrl;
  var weatherRef = AppConstants.apiWeatherReference;

  @override
  void onInit() {
    super.onInit();
    fetchAllWeatherData();
  }

  // API Key
  final String apiKey = 'a977c5f18b36b5aa545a12d04df3b6d9';

  // Map OpenWeather icon codes to your asset names
  String getWeatherIconAsset(String iconCode) {
    return 'assets/weather/$iconCode.png';
  }

  // Format time from timestamp
  String formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Fetch both current weather and forecast
  Future<void> fetchAllWeatherData({String? city}) async {
    final cityToFetch = city ?? cityName.value;
    await fetchWeatherData(city: cityToFetch);
    await fetchForecast(cityToFetch);
    await getDirectCoordinates(cityToFetch);
  }

  // Main function to fetch current weather data
  Future<void> fetchWeatherData({String? city}) async {
    try {
      isLoading.value = true;

      // Use the provided city or current cityName
      final cityToFetch = city ?? cityName.value;

      var endPoint = '/weather';
      final url =
          '$baeseUrl$weatherRef$endPoint?q=$cityToFetch&appid=$apiKey&units=metric';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print('🌤️ Weather API Response for $cityToFetch');

        // Update weather data
        cityName.value = data['name'];
        country.value = data['sys']['country'];

        // Temperature (already in Celsius because of units=metric)
        temperature.value = data['main']['temp'].toDouble();
        tempMax.value = data['main']['temp_max'].toDouble();
        tempMin.value = data['main']['temp_min'].toDouble();
        feelsLike.value = data['main']['feels_like'].toDouble();

        // Weather condition and icon
        final weather = data['weather'][0];
        weatherIcon.value = weather['icon'];
        weatherDescription.value = weather['description'];
        weatherCondition.value = weather['main'];

        // Other details
        humidity.value = data['main']['humidity'];
        pressure.value = data['main']['pressure'];

        // Wind speed (convert m/s to km/h)
        windSpeed.value = data['wind']['speed'].toDouble() * 3.6;

        // Visibility (convert meters to km)
        visibility.value = (data['visibility'] / 1000).round();

        // Sunrise and sunset times
        sunrise.value = formatTime(data['sys']['sunrise']);
        sunset.value = formatTime(data['sys']['sunset']);

        print(' Weather data loaded for ${cityName.value}');
        print('   Temperature: ${temperature.value}°C');
        print('   Condition: ${weatherCondition.value}');
      } else {
        print(
          'Failed to load weather data. Status code: ${response.statusCode}',
        );
        Get.snackbar(
          'Error',
          'Failed to load weather data for $cityToFetch',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      Get.snackbar(
        'Error',
        'Failed to load weather: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update city first, then fetch weather and forecast
  void updateCity(String selectedCity) {
    if (selectedCity.isNotEmpty) {
      cityName.value = selectedCity;
      fetchAllWeatherData(city: selectedCity);
    }
  }

  String getCurrentDate() {
    final now = DateTime.now();
    return DateFormat('EEEE, d MMM').format(now);
  }

  // Fetch and process forecast data
  Future<void> fetchForecast(String? city) async {
    try {
      isForecastLoading.value = true;
      print('Fetching forecast data...');

      final forecastData = await fetchForecastData(city);

      // Update the Rx lists
      dailyForecasts.value = (forecastData['daily_forecasts'] as List)
          .cast<Map<String, dynamic>>();
      hourlyForecastsToday.value =
          (forecastData['hourly_forecasts_today'] as List)
              .cast<Map<String, dynamic>>();

      // Debug info
      print(' Forecast data processed:');
      print('   Daily forecasts: ${dailyForecasts.length} days');
      print(
        '   Hourly forecasts today: ${hourlyForecastsToday.length} periods',
      );

      update(); // Notify listeners
    } catch (e) {
      print(' Error fetching forecast: $e');
      Get.snackbar(
        'Error',
        'Failed to load forecast: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isForecastLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> fetchForecastData(String? city) async {
    final cityToFetch = city ?? cityName.value;

    var foracastEndPoint = '/forecast';
    final url = Uri.parse(
      "$baeseUrl$weatherRef$foracastEndPoint?q=$cityToFetch&appid=$apiKey&units=metric",
    );

    try {
      print(' Calling forecast API for: $cityToFetch');
      final response = await http.get(url);

      print(' Forecast API Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        print('Forecast API success!');

        // Process data for daily and hourly forecasts
        return _processForecastData(data);
      } else if (response.statusCode == 404) {
        throw Exception('City "$cityToFetch" not found');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key');
      } else {
        throw Exception(
          'Failed to load forecast data. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print(' Error fetching forecast: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _processForecastData(Map<String, dynamic> rawData) {
    print(' Processing forecast data...');
    final List<dynamic> rawList = rawData['list'] ?? [];
    final List<Map<String, dynamic>> allForecasts = [];

    print(' Total forecast periods: ${rawList.length}');

    // Process all forecasts
    for (final item in rawList) {
      final Map<String, dynamic> forecast = {
        'dt': item['dt'],
        'dt_txt': item['dt_txt'],
        'temp': item['main']['temp'].toDouble(),
        'temp_min': item['main']['temp_min'].toDouble(),
        'temp_max': item['main']['temp_max'].toDouble(),
        'feels_like': item['main']['feels_like'].toDouble(),
        'humidity': item['main']['humidity'],
        'pressure': item['main']['pressure'],
        'weather': item['weather'][0],
        'wind_speed': item['wind']['speed'].toDouble(),
        'wind_deg': item['wind']['deg'],
        'clouds': item['clouds']['all'],
        // Removed 'pop' field (probability of precipitation)
      };
      allForecasts.add(forecast);
    }

    // Group by date for daily forecasts
    final Map<String, List<Map<String, dynamic>>> forecastsByDate = {};

    for (final forecast in allForecasts) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(
        forecast['dt'] * 1000,
      );
      final dateKey = '${dateTime.year}-${dateTime.month}-${dateTime.day}';

      if (!forecastsByDate.containsKey(dateKey)) {
        forecastsByDate[dateKey] = [];
      }
      forecastsByDate[dateKey]!.add(forecast);
    }

    // Create daily forecasts (one per day, using noon or average)
    final List<Map<String, dynamic>> dailyForecastsList = [];

    forecastsByDate.forEach((dateKey, forecasts) {
      if (forecasts.isNotEmpty) {
        // Find forecast closest to noon (12 PM) for better representation
        Map<String, dynamic>? noonForecast;
        int closestToNoonDiff = 24;

        for (final forecast in forecasts) {
          final dateTime = DateTime.fromMillisecondsSinceEpoch(
            forecast['dt'] * 1000,
          );
          final hourDiff = (dateTime.hour - 12).abs();

          if (hourDiff < closestToNoonDiff) {
            closestToNoonDiff = hourDiff;
            noonForecast = forecast;
          }
        }

        // Calculate min/max temp for the day
        double minTemp = double.infinity;
        double maxTemp = double.negativeInfinity;
        double totalTemp = 0;

        for (final forecast in forecasts) {
          final temp = forecast['temp'] as double;
          if (temp < minTemp) minTemp = temp;
          if (temp > maxTemp) maxTemp = temp;
          totalTemp += temp;
        }

        final dailyForecast = {
          'date': dateKey,
          'dateTime': DateTime.fromMillisecondsSinceEpoch(
            noonForecast!['dt'] * 1000,
          ),
          'temp': noonForecast['temp'],
          'feels_like': noonForecast['feels_like'],
          'temp_min': minTemp,
          'temp_max': maxTemp,
          'avg_temp': totalTemp / forecasts.length,
          'humidity': noonForecast['humidity'],
          'pressure': noonForecast['pressure'],
          'weather': noonForecast['weather'],
          'wind_speed': noonForecast['wind_speed'],
          'wind_deg': noonForecast['wind_deg'],
          'clouds': noonForecast['clouds'],
          'hourly_forecasts': forecasts,
        };

        dailyForecastsList.add(dailyForecast);
      }
    });

    // Sort daily forecasts by date
    dailyForecastsList.sort((a, b) => a['dateTime'].compareTo(b['dateTime']));

    // Get hourly forecasts for today and tomorrow
    final now = DateTime.now();
    final tomorrow = now.add(Duration(days: 1));

    final List<Map<String, dynamic>> hourlyForecastsTodayList = allForecasts
        .where((forecast) {
          final dateTime = DateTime.fromMillisecondsSinceEpoch(
            forecast['dt'] * 1000,
          );
          return dateTime.year == now.year &&
              dateTime.month == now.month &&
              dateTime.day == now.day;
        })
        .toList();

    final List<Map<String, dynamic>> hourlyForecastsTomorrowList = allForecasts
        .where((forecast) {
          final dateTime = DateTime.fromMillisecondsSinceEpoch(
            forecast['dt'] * 1000,
          );
          return dateTime.year == tomorrow.year &&
              dateTime.month == tomorrow.month &&
              dateTime.day == tomorrow.day;
        })
        .toList();

    print(' Forecast processing complete');
    print('   Today\'s hourly forecasts: ${hourlyForecastsTodayList.length}');
    print('   Daily forecasts: ${dailyForecastsList.length}');

    return {
      'city': rawData['city'],
      'daily_forecasts': dailyForecastsList.take(7).toList(),
      'hourly_forecasts_today': hourlyForecastsTodayList,
      'hourly_forecasts_tomorrow': hourlyForecastsTomorrowList,
      'all_forecasts': allForecasts,
      'raw_data': rawData,
    };
  }

  // Helper method to get day name from index
  String getDayNameFromIndex(int index) {
    if (index == 0) return 'Today';
    if (index == 1) return 'Tomorrow';

    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final now = DateTime.now();
    final targetDay = now.add(Duration(days: index));
    return days[targetDay.weekday % 7];
  }

  // Helper method to get weather icon based on condition
  IconData getWeatherIconFromCondition(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
      case 'drizzle':
        return Icons.water_drop;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
      case 'haze':
        return Icons.cloud;
      default:
        return Icons.wb_sunny;
    }
  }

  // Helper method to get icon color based on condition
  Color getWeatherIconColorFromCondition(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Colors.orange;
      case 'clouds':
        return Colors.blueGrey;
      case 'rain':
      case 'drizzle':
        return Colors.blue;
      case 'thunderstorm':
        return Colors.purple;
      case 'snow':
        return Colors.cyan;
      case 'mist':
      case 'fog':
      case 'haze':
        return Colors.grey;
      default:
        return Colors.green;
    }
  }

  // Get forecast for specific day index
  Map<String, dynamic>? getForecastForDay(int dayIndex) {
    if (dayIndex < 0 || dayIndex >= dailyForecasts.length) {
      return null;
    }
    return dailyForecasts[dayIndex];
  }

  // Get weather condition text for forecast
  String getForecastCondition(Map<String, dynamic>? forecast) {
    if (forecast == null || forecast['weather'] == null) return 'Clear';
    return forecast['weather']['description'] ?? 'Clear';
  }

  // Get weather icon code for forecast
  String getForecastIcon(Map<String, dynamic>? forecast) {
    if (forecast == null || forecast['weather'] == null) return '01d';
    return forecast['weather']['icon'] ?? '01d';
  }

  // Format date for display
  String formatDate(DateTime date) {
    return DateFormat('EEE, MMM d').format(date);
  }

  // Get day name from dt (timestamp)
  String getDayName(int dt) {
    final date = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
    return DateFormat('EEE').format(date);
  }

  // Format time for hourly display
  String formatHourlyTime(int dt) {
    final date = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
    final now = DateTime.now();

    if (date.day == now.day && date.hour == now.hour) {
      return 'Now';
    }

    return DateFormat('ha').format(date);
  }

  // Get temperature with unit
  String getFormattedTemp(double temp) {
    return '${temp.round()}°C';
  }

  // Get wind speed with unit
  String getFormattedWindSpeed(double speed) {
    return '${speed.round()} km/h';
  }

  // Get pressure with unit
  String getFormattedPressure() {
    return '${pressure.value} hPa';
  }

  Future<void> getDirectCoordinates(String city) async {
    try {
      isLoading.value = true;

      var kDirectGeocodingEndpoint = '/direct';
      final url =
          '$baeseUrl${AppConstants.apiCoordinatesReference}$kDirectGeocodingEndpoint?q=$city&limit=1&appid=$apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;

        if (data.isNotEmpty) {
          final coordData = data[0];
          double lat = coordData['lat'];
          double lon = coordData['lon'];

          print('Coordinates for $city: Latitude: $lat, Longitude: $lon');
        } else {
          print('No coordinates found for city: $city');
        }
      } else {
        print(
          'Failed to load coordinates. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching coordinates: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> fetchAirPollutionData(double lat, double lon) async {
  //   try {
  //     isLoading.value = true;
  //     var kAirPollutionEndpoint = '/air_pollution';
  //     final url =
  //         '$baeseUrl$weatherRef$kAirPollutionEndpoint?lat=$lat&lon=$lon&appid=$apiKey';
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       print('Air Pollution Data: $data');
  //     } else {
  //       print(
  //         'Failed to load air pollution data. Status code: ${response.statusCode}',
  //       );
  //     }
  //   } catch (e) {
  //     print('Error fetching air pollution data: $e');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }


  //   // Your existing variables like airPollution, isAirPollutionLoading, etc.

  // /// Returns a smoothly interpolated color based on AQI value (1 to 5)
  // Color getAqiColor(double aqi) {
  //   // Clamp the value between 1 and 5
  //   aqi = aqi.clamp(1, 5);

  //   if (aqi <= 2) {
  //     // Green to Yellow
  //     return Color.lerp(Colors.green, Colors.yellow, (aqi - 1) / 1)!;
  //   } else if (aqi <= 3) {
  //     // Yellow to Orange
  //     return Color.lerp(Colors.yellow, Colors.orange, (aqi - 2) / 1)!;
  //   } else if (aqi <= 4) {
  //     // Orange to Red
  //     return Color.lerp(Colors.orange, Colors.red, (aqi - 3) / 1)!;
  //   } else {
  //     // Red to Deep Red
  //     return Color.lerp(Colors.red, Colors.deepPurple, (aqi - 4) / 1)!;
  //   }
  // }

  // /// Returns a label based on AQI value (1 to 5)
  // String getAqiLabel(double aqi) {
  //   if (aqi < 1.5) return 'Good';
  //   if (aqi < 2.5) return 'Fair';
  //   if (aqi < 3.5) return 'Moderate';
  //   if (aqi < 4.5) return 'Poor';
  //   return 'Very Poor';
  // }
}
