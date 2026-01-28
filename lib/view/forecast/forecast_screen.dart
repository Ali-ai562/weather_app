import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/controllers/settings_controller.dart';
import 'package:weather_app/controllers/weather_controller.dart';
import 'package:weather_app/view/settings/settings_page.dart';
import 'package:weather_app/widgets/my_text.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final weatherCtrl1 = Get.find<WeatherController>();
  final settingsCtrl = Get.find<SettingsController>();

  @override
  void initState() {
    super.initState();
    // Load forecast data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      weatherCtrl1.fetchForecast(weatherCtrl1.cityName.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Top blue weather section
              Container(
                height: 450,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 8,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    children: [
                      // Top bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                height: 34,
                                width: 34,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const MyText(
                              text: '7 Days Forecast',
                              size: 20,
                              weight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            IconButton(
                              onPressed: () {
                                Get.to(() => SettingsPage());
                              },
                              icon: const Icon(
                                Icons.settings_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(
                              () => Image.asset(
                                weatherCtrl1.getWeatherIconAsset(
                                  weatherCtrl1.weatherIcon.value,
                                ),
                                height: 150,
                                width: 150,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/weather/50d.png',
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.contain,
                                  );
                                },
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => MyText(
                                    text:
                                        '${weatherCtrl1.cityName.value}, ${weatherCtrl1.country.value}',
                                    size: 22,
                                    weight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                MyText(
                                  text: weatherCtrl1.getCurrentDate(),
                                  size: 16,
                                  weight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Obx(
                                      () => MyText(
                                        text:
                                            '${settingsCtrl.convertTemperature(weatherCtrl1.temperature.value).round()}${settingsCtrl.temperatureUnit}',
                                        size: 48,
                                        weight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 14.0),
                                      child: Obx(
                                        () => MyText(
                                          text: weatherCtrl1
                                              .weatherCondition
                                              .value,
                                          size: 16,
                                          weight: FontWeight.w500,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Divider(
                        color: Colors.white.withOpacity(0.2),
                        thickness: 1,
                        endIndent: 40,
                        indent: 40,
                      ),

                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Obx(
                          () => Row(
                            children: [
                              Column(
                                children: [
                                  const Icon(
                                    Icons.air,
                                    color: Colors.white70,
                                    size: 28,
                                  ),
                                  const SizedBox(height: 4),
                                  MyText(
                                    text:
                                        '${settingsCtrl.convertWindSpeed(weatherCtrl1.windSpeed.value).round()} ${settingsCtrl.windSpeedUnit}',
                                    size: 16,
                                    weight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                  const MyText(
                                    text: 'Wind',
                                    size: 16,
                                    weight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  const Icon(
                                    Icons.water_drop_outlined,
                                    color: Colors.white70,
                                    size: 28,
                                  ),
                                  const SizedBox(height: 4),
                                  MyText(
                                    text: '${weatherCtrl1.humidity.value}%',
                                    size: 16,
                                    weight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                  const MyText(
                                    text: 'Humidity',
                                    size: 16,
                                    weight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  const Icon(
                                    Icons.water,
                                    color: Colors.white70,
                                    size: 28,
                                  ),
                                  const SizedBox(height: 4),
                                  MyText(
                                    text: '${weatherCtrl1.pressure.value} hPa',
                                    size: 16,
                                    weight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                  const MyText(
                                    text: 'Pressure',
                                    size: 16,
                                    weight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 7-Day Forecast Table Section
              Padding(
                padding: const EdgeInsets.only(top: 470.0),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Obx(() {
                      // if (weatherCtrl1.isForecastLoading.value) {
                      //   return const Center(
                      //     child: CircularProgressIndicator(),
                      //   );
                      // }

                      if (weatherCtrl1.dailyForecasts.isEmpty) {
                        return const Center(
                          child: MyText(
                            text: 'No forecast data available',
                            color: Colors.white,
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section Header with icon
                          const Padding(
                            padding: EdgeInsets.only(left: 4.0, bottom: 16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.blueAccent,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                MyText(
                                  text: '7-DAY FORECAST',
                                  size: 18,
                                  weight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),

                          // Modern Forecast Table Card
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Table Header
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[850],
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[800]!,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: const Row(
                                    children: [
                                      Expanded(
                                        child: MyText(
                                          text: 'DAY',
                                          size: 14,
                                          weight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Expanded(
                                        child: MyText(
                                          text: 'CONDITION',
                                          size: 14,
                                          weight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Expanded(
                                        child: MyText(
                                          text: 'TEMPERATURE',
                                          size: 14,
                                          weight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Forecast Rows - Now using real data
                                ...List.generate(
                                  weatherCtrl1.dailyForecasts.length,
                                  (index) {
                                    final forecast =
                                        weatherCtrl1.dailyForecasts[index];
                                    final isToday = index == 0;

                                    return _buildForecastRow(
                                      day: weatherCtrl1.getDayNameFromIndex(
                                        index,
                                      ),
                                      icon: weatherCtrl1
                                          .getWeatherIconFromCondition(
                                            forecast['weather']['main'],
                                          ),
                                      iconColor: weatherCtrl1
                                          .getWeatherIconColorFromCondition(
                                            forecast['weather']['main'],
                                          ),
                                      condition:
                                          forecast['weather']['description'],
                                      highTemp: (forecast['temp_max'] as num)
                                          .round(),
                                      lowTemp: (forecast['temp_min'] as num)
                                          .round(),
                                      isToday: isToday,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          // Additional Weather Info Cards using first day's forecast
                          if (weatherCtrl1.dailyForecasts.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildInfoCard(
                                    icon: Icons.thermostat,
                                    title: 'Feels Like',
                                    value:
                                        '${settingsCtrl.convertTemperature(weatherCtrl1.feelsLike.value).round()}${settingsCtrl.temperatureUnit}',
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildInfoCard(
                                    icon: Icons.water_drop,
                                    title: 'Humidity',
                                    value:
                                        '${weatherCtrl1.humidity.value.round()}%',
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildInfoCard(
                                    icon: Icons.air,
                                    title: 'Wind Speed',
                                    value:
                                        '${settingsCtrl.convertWindSpeed(weatherCtrl1.windSpeed.value).round()} ${settingsCtrl.windSpeedUnit}',
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildInfoCard(
                                    icon: Icons.visibility,
                                    title: 'Visibility',
                                    value:
                                        '${weatherCtrl1.visibility.value.round()} km',
                                    color: Colors.cyan,
                                  ),
                                ),
                              ],
                            ),
                          ],

                          // Bottom padding
                          const SizedBox(height: 40),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForecastRow({
    required String day,
    required IconData icon,
    required Color iconColor,
    required String condition,
    required int highTemp,
    required int lowTemp,
    bool isToday = false,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: isToday
                ? Colors.blueAccent.withOpacity(0.1)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              // Day Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: day,
                      size: 16,
                      weight: isToday ? FontWeight.w700 : FontWeight.w600,
                      color: isToday ? Colors.blueAccent : Colors.white,
                    ),
                    if (isToday)
                      Container(
                        margin:  EdgeInsets.only(top: 4),
                        padding:  EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const MyText(
                          text: 'NOW',
                          size: 10,
                          weight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),

              // Condition Column with Icon
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: iconColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MyText(
                        text: condition,
                        size: 15,
                        weight: FontWeight.w500,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),

              // Temperature Column
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.withOpacity(0.2),
                            Colors.orange.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MyText(
                        text: '$highTemp°',
                        size: 18,
                        weight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.2),
                            Colors.cyan.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MyText(
                        text: '$lowTemp°',
                        size: 16,
                        weight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Add divider between rows except for last one
        if (day != 'Sun') // You can change this logic based on your data
          Divider(
            height: 0,
            color: Colors.grey[800]!,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          MyText(text: title, size: 14, color: Colors.grey[400]),
          const SizedBox(height: 4),
          MyText(
            text: value,
            size: 20,
            weight: FontWeight.w700,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
