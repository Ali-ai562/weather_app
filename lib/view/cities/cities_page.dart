import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/controllers/cities_controller.dart';
import 'package:weather_app/controllers/weather_controller.dart';
import 'package:weather_app/widgets/my_text.dart';

class CitiesPage extends StatefulWidget {
  const CitiesPage({super.key});

  @override
  State<CitiesPage> createState() => _CitiesPageState();
}

class _CitiesPageState extends State<CitiesPage> {
  final CitiesController citiesCtrl = Get.put(CitiesController());
  final WeatherController weatherCtrl =
      Get.find<WeatherController>(); // Get the controller
  final TextEditingController searchController = TextEditingController();
  List<String> filteredCities = [];

  @override
  void initState() {
    super.initState();
    filteredCities = citiesCtrl.allCities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
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
                        const SizedBox(width: 20),
                        const MyText(
                          text: 'Select a city',
                          size: 24,
                          color: Colors.white,
                          weight: FontWeight.bold,
                        ),
                        const Spacer(),
                        Obx(
                          () => MyText(
                            text: weatherCtrl.cityName.value,
                            size: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Search cities
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: searchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white70),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white70),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: 'Search cities here...',
                        hintStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  searchController.clear();
                                  setState(() {
                                    filteredCities = citiesCtrl.allCities;
                                  });
                                },
                              )
                            : null,
                      ),
                      cursorColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            filteredCities = citiesCtrl.allCities;
                          } else {
                            filteredCities = citiesCtrl.allCities
                                .where(
                                  (city) => city.toLowerCase().contains(
                                    value.toLowerCase(),
                                  ),
                                )
                                .toList();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Current City Card
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent.withOpacity(0.2),
                      ),
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MyText(
                            text: 'Current City',
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 4),
                          Obx(
                            () => MyText(
                              text: weatherCtrl.cityName.value,
                              size: 18,
                              weight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const MyText(
                        text: 'Active',
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Cities List Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  MyText(
                    text: searchController.text.isEmpty
                        ? 'All Cities'
                        : 'Search Results',
                    size: 18,
                    weight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  const Spacer(),
                  MyText(
                    text: '${filteredCities.length} cities',
                    size: 14,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),

            // Cities List
            Expanded(
              child: filteredCities.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_off,
                            size: 60,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 16),
                          const MyText(
                            text: 'No cities found',
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          const MyText(
                            text: 'Try a different search term',
                            size: 14,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: filteredCities.length,
                      itemBuilder: (context, index) {
                        final city = filteredCities[index];
                        return _buildCityItem(city);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityItem(String city) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    child: Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: ListTile(
        onTap: () async {
          try {
            // Show loading indicator
            Get.dialog(
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const CircularProgressIndicator(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              barrierDismissible: false,
            );

            // Update city and fetch weather
            weatherCtrl.updateCity(city);

            // Wait a moment for data to load
            await Future.delayed(const Duration(seconds: 1));

            // Close loading dialog
            if (Get.isDialogOpen ?? false) Get.back();

            // Go back to home screen
            Get.back();

            // Show success message
            Get.snackbar(
              'City Changed',
              'Weather updated for $city',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
            );
          } catch (e) {
            if (Get.isDialogOpen ?? false) Get.back();
            // Show error message
            Get.snackbar(
              'Error',
              'Failed to load weather for $city',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text('🇵🇰', style: TextStyle(fontSize: 24)),
          ),
        ),
        title: MyText(
          text: city,
          size: 18,
          weight: FontWeight.w600,
          color: Colors.white,
        ),
        subtitle:  MyText(
          text: 'Pakistan',
          size: 14,
          color: Colors.grey,
        ),
        trailing: Obx(
          () => Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: weatherCtrl.cityName.value == city
                  ? Colors.blueAccent
                  : Colors.grey[800],
              shape: BoxShape.circle,
            ),
            child: Icon(
              weatherCtrl.cityName.value == city
                  ? Icons.check
                  : Icons.arrow_forward_ios,
              color: Colors.white,
              size: weatherCtrl.cityName.value == city ? 18 : 16,
            ),
          ),
        ),
      ),
    ),
  );
}
}
