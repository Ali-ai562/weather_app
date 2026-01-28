import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/controllers/settings_controller.dart';
import 'package:weather_app/controllers/weather_controller.dart';
import 'package:weather_app/view/cities/cities_page.dart';
import 'package:weather_app/view/forecast/forecast_screen.dart';
import 'package:weather_app/view/settings/settings_page.dart';
import 'package:weather_app/widgets/detail_card.dart';
import 'package:weather_app/widgets/hourly_forecast_item.dart';
import 'package:weather_app/widgets/my_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SettingsController settingsCtrl = Get.put(SettingsController());
  final WeatherController weatherCtrl = Get.put(WeatherController());

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // Load weather data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      weatherCtrl.fetchAllWeatherData();
    });
  }

  void showRefreshIndicator() {
    _refreshIndicatorKey.currentState?.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
        () => RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            await weatherCtrl.fetchAllWeatherData();
          },
          color: Colors.blueAccent,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Stack(
                children: [
                  // Top blue weather section
                  Container(
                    height: 530,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.6),
                          blurRadius: 25,
                          spreadRadius: 2,
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Row(
                              children: [
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 4),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() => CitiesPage());
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_sharp,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            SizedBox(width: 4),
                                            MyText(
                                              text: weatherCtrl.cityName.value,
                                              size: 18,
                                              weight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                      MyText(
                                        text: weatherCtrl.getCurrentDate(),
                                        size: 14,
                                        weight: FontWeight.w500,
                                        color: Colors.white70,
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () => Get.to(() => SettingsPage()),
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                    child: Icon(
                                      Icons.settings_outlined,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Weather icon
                          Image.asset(
                            weatherCtrl.getWeatherIconAsset(
                              weatherCtrl.weatherIcon.value,
                            ),
                            height: 150,
                            width: 150,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.wb_sunny,
                                color: Colors.white,
                                size: 100,
                              );
                            },
                          ),

                          const SizedBox(height: 15),

                          // Temperature with settings conversion
                          Text(
                            '${settingsCtrl.convertTemperature(weatherCtrl.temperature.value).round()}${settingsCtrl.temperatureUnit}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Weather condition
                          MyText(
                            text: weatherCtrl.weatherCondition.value,
                            size: 18,
                            weight: FontWeight.w600,
                            color: Colors.white,
                          ),

                          const SizedBox(height: 8),

                          // Location with country
                          MyText(
                            text:
                                '${weatherCtrl.cityName.value}, ${weatherCtrl.country.value}',
                            size: 16,
                            weight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.9),
                          ),

                          const SizedBox(height: 8),

                          Divider(
                            color: Colors.white.withOpacity(0.2),
                            thickness: 1,
                            endIndent: 40,
                            indent: 40,
                          ),

                          const SizedBox(height: 8),

                          // Weather stats with settings conversion
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                            ),
                            child: Row(
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
                                          '${settingsCtrl.convertWindSpeed(weatherCtrl.windSpeed.value).round()} ${settingsCtrl.windSpeedUnit}',
                                      size: 16,
                                      weight: FontWeight.w500,
                                      color: Colors.white70,
                                    ),
                                    MyText(
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
                                      text: '${weatherCtrl.humidity.value}%',
                                      size: 16,
                                      weight: FontWeight.w500,
                                      color: Colors.white70,
                                    ),
                                    MyText(
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
                                      text: '${weatherCtrl.pressure.value} hPa',
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
                        ],
                      ),
                    ),
                  ),

                  // Bottom content section
                  Padding(
                    padding: const EdgeInsets.only(top: 510.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hourly Forecast Title
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0, top: 8.0),
                              child: MyText(
                                text: 'Hourly Forecast',
                                size: 22,
                                weight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Hourly Forecast List
                            SizedBox(
                              height: 140,
                              child: Obx(() {
                                if (weatherCtrl.hourlyForecastsToday.isEmpty) {
                                  return Center(
                                    child: Text(
                                      'No hourly data available',
                                      style: TextStyle(color: Colors.grey[400]),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      weatherCtrl.hourlyForecastsToday.length,
                                  itemBuilder: (context, index) {
                                    return HourlyForecastItem(
                                      forecast: weatherCtrl
                                          .hourlyForecastsToday[index],
                                      index: index,
                                      isFirstItem: index == 0,
                                    );
                                  },
                                );
                              }),
                            ),

                            const SizedBox(height: 20),

                            // Weather Details Title
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  const MyText(
                                    text: 'Weather Details',
                                    size: 22,
                                    weight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => const ForecastScreen());
                                    },
                                    child: Row(
                                      children: const [
                                        MyText(
                                          text: '7 Days',
                                          size: 18,
                                          weight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.grey,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Weather Details Grid with settings conversion
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 3,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              children: [
                                DetailCard(
                                  icon: Icons.water_drop_outlined,
                                  label: 'Humidity',
                                  value: '${weatherCtrl.humidity.value}%',
                                  color: Colors.cyan.shade400,
                                ),
                                DetailCard(
                                  icon: Icons.air_outlined,
                                  label: 'Wind',
                                  value:
                                      '${settingsCtrl.convertWindSpeed(weatherCtrl.windSpeed.value).round()} ${settingsCtrl.windSpeedUnit}',
                                  color: Colors.orange.shade400,
                                ),
                                DetailCard(
                                  icon: Icons.thermostat_outlined,
                                  label: 'Feels Like',
                                  value:
                                      '${settingsCtrl.convertTemperature(weatherCtrl.feelsLike.value).round()}${settingsCtrl.temperatureUnit}',
                                  color: Colors.red.shade400,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:weather_app/controllers/weather_controller.dart';
// import 'package:weather_app/view/forecast/forecast_screen.dart';
// import 'package:weather_app/view/settings/settings_page.dart';
// import 'package:weather_app/widgets/detail_card.dart';
// import 'package:weather_app/widgets/dotted_pattern.dart';
// import 'package:weather_app/widgets/my_text.dart';

// class HomeScreen extends StatelessWidget {
//   HomeScreen({super.key});

//   final WeatherController weatherCtrl = Get.put(WeatherController());

//   @override
//   Widget build(BuildContext context) {
//     // Fetch data when screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       weatherCtrl.fetchWeatherData();
//     });

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Obx(
//         () => Stack(
//           children: [
//             // Top blue weather section
//             Container(
//               height: 530,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.blueAccent,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.blueAccent.withOpacity(0.6),
//                     blurRadius: 25,
//                     spreadRadius: 2,
//                     offset: const Offset(0, 8),
//                   ),
//                 ],
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 45.0),
//                 child: Column(
//                   children: [
//                     // Top bar
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Row(
//                         children: [
//                           Container(
//                             height: 34,
//                             width: 34,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: Colors.white,
//                                 width: 1.5,
//                               ),
//                             ),
//                             child: const Center(child: DottedPattern()),
//                           ),
//                           const Spacer(),
//                           Column(
//                             children: [
//                               const SizedBox(height: 4),
//                               Row(
//                                 children: [
//                                   const Icon(
//                                     Icons.location_on_sharp,
//                                     color: Colors.white,
//                                     size: 18,
//                                   ),
//                                   const SizedBox(width: 4),
//                                   MyText(
//                                     text: weatherCtrl.isLoading.value
//                                         ? 'Loading...'
//                                         : weatherCtrl.cityName.value,
//                                     size: 18,
//                                     weight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ],
//                               ),
//                               MyText(
//                                 text: _getCurrentDate(),
//                                 size: 14,
//                                 weight: FontWeight.w500,
//                                 color: Colors.white70,
//                               ),
//                             ],
//                           ),
//                           const Spacer(),
//                           IconButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => const SettingsPage(),
//                                 ),
//                               );
//                             },
//                             icon: const Icon(
//                               Icons.settings_outlined,
//                               color: Colors.white,
//                               size: 28,
//                             ),
//                             padding: const EdgeInsets.only(right: 8),
//                             constraints: const BoxConstraints(),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     // Weather icon
//                     weatherCtrl.isLoading.value
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : Image.asset(
//                             weatherCtrl.getWeatherIconAsset(
//                               weatherCtrl.weatherIcon.value,
//                             ),
//                             height: 150,
//                             width: 150,
//                             fit: BoxFit.contain,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Icon(
//                                 Icons.wb_sunny,
//                                 color: Colors.white,
//                                 size: 100,
//                               );
//                             },
//                           ),

//                     const SizedBox(height: 15),

//                     // Temperature
//                     Text(
//                       weatherCtrl.isLoading.value
//                           ? '--°C'
//                           : '${weatherCtrl.temperature.value.round()}°C',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 50,
//                         fontWeight: FontWeight.bold,
//                         shadows: [
//                           Shadow(
//                             color: Colors.black.withOpacity(0.2),
//                             blurRadius: 4,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 4),

//                     // Weather condition
//                     MyText(
//                       text: weatherCtrl.isLoading.value
//                           ? 'Loading...'
//                           : weatherCtrl.weatherCondition.value,
//                       size: 18,
//                       weight: FontWeight.w600,
//                       color: Colors.white,
//                     ),

//                     const SizedBox(height: 8),

//                     // Location with country
//                     MyText(
//                       text: weatherCtrl.isLoading.value
//                           ? 'Loading...'
//                           : '${weatherCtrl.cityName.value}, ${weatherCtrl.country.value}',
//                       size: 16,
//                       weight: FontWeight.w400,
//                       color: Colors.white.withOpacity(0.9),
//                     ),

//                     const SizedBox(height: 8),

//                     Divider(
//                       color: Colors.white.withOpacity(0.2),
//                       thickness: 1,
//                       endIndent: 40,
//                       indent: 40,
//                     ),

//                     const SizedBox(height: 8),

//                     // Weather stats
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                       child: Row(
//                         children: [
//                           _buildStatItem(
//                             icon: Icons.air,
//                             value: weatherCtrl.isLoading.value
//                                 ? '--'
//                                 : '${weatherCtrl.windSpeed.value.round()} km/h',
//                             label: 'Wind',
//                           ),
//                           const Spacer(),
//                           _buildStatItem(
//                             icon: Icons.water_drop_outlined,
//                             value: weatherCtrl.isLoading.value
//                                 ? '--'
//                                 : '${weatherCtrl.humidity.value}%',
//                             label: 'Humidity',
//                           ),
//                           const Spacer(),
//                           _buildStatItem(
//                             icon: Icons.water,
//                             value: weatherCtrl.isLoading.value
//                                 ? '--'
//                                 : '${weatherCtrl.chanceOfRain.value.round()}%',
//                             label: 'Chance of rain',
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Bottom content section
//             Padding(
//               padding: const EdgeInsets.only(top: 515.0),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16.0,
//                   vertical: 16.0,
//                 ),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Hourly Forecast Title
//                       const Padding(
//                         padding: EdgeInsets.only(left: 8.0, top: 8.0),
//                         child: MyText(
//                           text: 'Hourly Forecast',
//                           size: 22,
//                           weight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),

//                       const SizedBox(height: 12),

//                       // Hourly Forecast List
//                       SizedBox(
//                         height: 140,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: 8,
//                           itemBuilder: (context, index) {
//                             final hourly = weatherCtrl.getHourlyForecast();
//                             return Container(
//                               width: 82,
//                               margin: EdgeInsets.only(
//                                 left: index == 0 ? 8 : 0,
//                                 right: 12,
//                               ),
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[900],
//                                 borderRadius: BorderRadius.circular(18),
//                                 border: Border.all(
//                                   color: Colors.grey[800]!,
//                                   width: 1,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.3),
//                                     blurRadius: 6,
//                                     offset: const Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   MyText(
//                                     text: hourly[index]['time'],
//                                     size: 16,
//                                     weight: FontWeight.w500,
//                                     color: Colors.white,
//                                   ),
//                                   Container(
//                                     width: 42,
//                                     height: 42,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       gradient: LinearGradient(
//                                         colors: [
//                                           Colors.blueAccent.withOpacity(0.3),
//                                           Colors.blueAccent.withOpacity(0.1),
//                                         ],
//                                       ),
//                                     ),
//                                     child: Icon(
//                                       hourly[index]['icon'] == 'wb_sunny'
//                                           ? Icons.wb_sunny
//                                           : Icons.nightlight_round,
//                                       color: Colors.orange,
//                                       size: 24,
//                                     ),
//                                   ),
//                                   MyText(
//                                     text: '${hourly[index]['temp']}°',
//                                     size: 22,
//                                     weight: FontWeight.w600,
//                                     color: Colors.white,
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       // Weather Details Title
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: Row(
//                           children: [
//                             const MyText(
//                               text: 'Weather Details',
//                               size: 22,
//                               weight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                             const Spacer(),
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         const ForecastScreen(),
//                                   ),
//                                 );
//                               },
//                               child: Row(
//                                 children: const [
//                                   MyText(
//                                     text: '7 Days',
//                                     size: 18,
//                                     weight: FontWeight.bold,
//                                     color: Colors.grey,
//                                   ),
//                                   SizedBox(width: 4),
//                                   Icon(
//                                     Icons.arrow_forward_ios,
//                                     color: Colors.grey,
//                                     size: 16,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 16),

//                       // Weather Details Grid
//                       GridView.count(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         crossAxisCount: 3,
//                         mainAxisSpacing: 12,
//                         crossAxisSpacing: 12,
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         children: [
//                           DetailCard(
//                             icon: Icons.water_drop_outlined,
//                             label: 'Humidity',
//                             value: weatherCtrl.isLoading.value
//                                 ? '--%'
//                                 : '${weatherCtrl.humidity.value}%',
//                             color: Colors.cyan.shade400,
//                           ),
//                           DetailCard(
//                             icon: Icons.air_outlined,
//                             label: 'Wind',
//                             value: weatherCtrl.isLoading.value
//                                 ? '-- km/h'
//                                 : '${weatherCtrl.windSpeed.value.round()} km/h',
//                             color: Colors.orange.shade400,
//                           ),
//                           DetailCard(
//                             icon: Icons.thermostat_outlined,
//                             label: 'Feels Like',
//                             value: weatherCtrl.isLoading.value
//                                 ? '--°C'
//                                 : '${weatherCtrl.feelsLike.value.round()}°C',
//                             color: Colors.red.shade400,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatItem({
//     required IconData icon,
//     required String value,
//     required String label,
//   }) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.white70, size: 28),
//         const SizedBox(height: 4),
//         MyText(
//           text: value,
//           size: 16,
//           weight: FontWeight.w500,
//           color: Colors.white70,
//         ),
//         MyText(
//           text: label,
//           size: 16,
//           weight: FontWeight.w500,
//           color: Colors.white70,
//         ),
//       ],
//     );
//   }

// }
