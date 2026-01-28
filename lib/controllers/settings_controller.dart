import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  // Temperature Unit (Celsius/Fahrenheit)
  RxBool isCelsius = true.obs;
  
  // Notifications
  RxBool notificationsEnabled = true.obs;
  
  // Dark Mode
  RxBool darkModeEnabled = true.obs;
  
  // Location Services
  RxBool locationEnabled = true.obs;
  
  // Language Selection
  RxString selectedLanguage = 'English'.obs;
  
  // Units System (Metric/Imperial)
  RxString selectedUnits = 'Metric'.obs;
  
  // Auto Refresh Interval (in minutes)
  RxDouble refreshInterval = 30.0.obs;
  
  // Weather data cache duration
  RxInt cacheDuration = 15.obs; // minutes
  
  // Keys for SharedPreferences
  static const String _isCelsiusKey = 'isCelsius';
  static const String _notificationsKey = 'notificationsEnabled';
  static const String _darkModeKey = 'darkModeEnabled';
  static const String _locationKey = 'locationEnabled';
  static const String _languageKey = 'selectedLanguage';
  static const String _unitsKey = 'selectedUnits';
  static const String _refreshKey = 'refreshInterval';
  static const String _cacheKey = 'cacheDuration';

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  /// Load all settings from SharedPreferences
  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      isCelsius.value = prefs.getBool(_isCelsiusKey) ?? true;
      notificationsEnabled.value = prefs.getBool(_notificationsKey) ?? true;
      darkModeEnabled.value = prefs.getBool(_darkModeKey) ?? true;
      locationEnabled.value = prefs.getBool(_locationKey) ?? true;
      selectedLanguage.value = prefs.getString(_languageKey) ?? 'English';
      selectedUnits.value = prefs.getString(_unitsKey) ?? 'Metric';
      refreshInterval.value = prefs.getDouble(_refreshKey) ?? 30.0;
      cacheDuration.value = prefs.getInt(_cacheKey) ?? 15;
      
      print('✅ Settings loaded successfully');
      print('🌡️ Temperature Unit: ${isCelsius.value ? "°C" : "°F"}');
      print('📏 Units System: $selectedUnits');
      print('🌐 Language: $selectedLanguage');
    } catch (e) {
      print('❌ Error loading settings: $e');
    }
  }

  /// Save all settings to SharedPreferences
  Future<void> saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool(_isCelsiusKey, isCelsius.value);
      await prefs.setBool(_notificationsKey, notificationsEnabled.value);
      await prefs.setBool(_darkModeKey, darkModeEnabled.value);
      await prefs.setBool(_locationKey, locationEnabled.value);
      await prefs.setString(_languageKey, selectedLanguage.value);
      await prefs.setString(_unitsKey, selectedUnits.value);
      await prefs.setDouble(_refreshKey, refreshInterval.value);
      await prefs.setInt(_cacheKey, cacheDuration.value);
      
      print('✅ Settings saved successfully');
      
      // Show success message
      Get.snackbar(
        'Success',
        'Settings saved successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ Error saving settings: $e');
      
      // Show error message
      Get.snackbar(
        'Error',
        'Failed to save settings',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// Convert temperature based on selected unit
  double convertTemperature(double tempInCelsius) {
    if (isCelsius.value) {
      return tempInCelsius; // Return as-is for Celsius
    } else {
      // Convert Celsius to Fahrenheit: (C × 9/5) + 32
      return (tempInCelsius * 9 / 5) + 32;
    }
  }

  /// Convert wind speed based on selected unit system
  double convertWindSpeed(double speedInKmh) {
    if (selectedUnits.value == 'Metric') {
      return speedInKmh; // Return as-is for Metric (km/h)
    } else {
      // Convert km/h to mph: km/h × 0.621371
      return speedInKmh * 0.621371;
    }
  }

  /// Convert pressure if needed (hPa to inHg for Imperial)
  double convertPressure(double pressureInHpa) {
    if (selectedUnits.value == 'Metric') {
      return pressureInHpa; // hPa for Metric
    } else {
      // Convert hPa to inHg: hPa × 0.02953
      return pressureInHpa * 0.02953;
    }
  }

  /// Convert visibility if needed (meters to miles for Imperial)
  double convertVisibility(double visibilityInMeters) {
    if (selectedUnits.value == 'Metric') {
      // Convert meters to kilometers
      return visibilityInMeters / 1000;
    } else {
      // Convert meters to miles: meters × 0.000621371
      return visibilityInMeters * 0.000621371;
    }
  }

  /// Get temperature unit symbol
  String get temperatureUnit => isCelsius.value ? '°C' : '°F';
  
  /// Get wind speed unit
  String get windSpeedUnit => selectedUnits.value == 'Metric' ? 'km/h' : 'mph';
  
  /// Get pressure unit
  String get pressureUnit => selectedUnits.value == 'Metric' ? 'hPa' : 'inHg';
  
  /// Get visibility unit
  String get visibilityUnit => selectedUnits.value == 'Metric' ? 'km' : 'mi';
  
  /// Get formatted temperature with unit
  String getFormattedTemperature(double tempInCelsius) {
    final convertedTemp = convertTemperature(tempInCelsius);
    return '${convertedTemp.round()}$temperatureUnit';
  }
  
  /// Get formatted wind speed with unit
  String getFormattedWindSpeed(double speedInKmh) {
    final convertedSpeed = convertWindSpeed(speedInKmh);
    return '${convertedSpeed.round()} $windSpeedUnit';
  }
  
  /// Get formatted pressure with unit
  String getFormattedPressure(double pressureInHpa) {
    final convertedPressure = convertPressure(pressureInHpa);
    return selectedUnits.value == 'Metric' 
        ? '${convertedPressure.round()} $pressureUnit'
        : '${convertedPressure.toStringAsFixed(2)} $pressureUnit';
  }
  
  /// Get formatted visibility with unit
  String getFormattedVisibility(double visibilityInMeters) {
    final convertedVisibility = convertVisibility(visibilityInMeters);
    return selectedUnits.value == 'Metric'
        ? '${convertedVisibility.round()} $visibilityUnit'
        : '${convertedVisibility.toStringAsFixed(1)} $visibilityUnit';
  }

  /// Get refresh interval in milliseconds
  int get refreshIntervalInMs => (refreshInterval.value * 60 * 1000).round();
  
  /// Get cache duration in milliseconds
  int get cacheDurationInMs => (cacheDuration.value * 60 * 1000).round();

  /// Reset all settings to default values
  Future<void> resetToDefaults() async {
    isCelsius.value = true;
    notificationsEnabled.value = true;
    darkModeEnabled.value = true;
    locationEnabled.value = true;
    selectedLanguage.value = 'English';
    selectedUnits.value = 'Metric';
    refreshInterval.value = 30.0;
    cacheDuration.value = 15;
    
    await saveSettings();
    
    // Show success message
    Get.snackbar(
      'Settings Reset',
      'All settings have been reset to defaults',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  /// Toggle temperature unit
  void toggleTemperatureUnit() {
    isCelsius.value = !isCelsius.value;
  }

  /// Toggle notifications
  void toggleNotifications() {
    notificationsEnabled.value = !notificationsEnabled.value;
  }

  /// Toggle dark mode
  void toggleDarkMode() {
    darkModeEnabled.value = !darkModeEnabled.value;
  }

  /// Toggle location services
  void toggleLocation() {
    locationEnabled.value = !locationEnabled.value;
  }

  /// Set language
  void setLanguage(String language) {
    selectedLanguage.value = language;
  }

  /// Set units system
  void setUnits(String units) {
    selectedUnits.value = units;
  }

  /// Set refresh interval
  void setRefreshInterval(double interval) {
    refreshInterval.value = interval;
  }

  /// Set cache duration
  void setCacheDuration(int duration) {
    cacheDuration.value = duration;
  }

  /// Check if location services are enabled
  bool get isLocationEnabled => locationEnabled.value;
  
  /// Check if notifications are enabled
  bool get isNotificationsEnabled => notificationsEnabled.value;
  
  /// Check if dark mode is enabled
  bool get isDarkModeEnabled => darkModeEnabled.value;
  
  /// Get current language
  String get currentLanguage => selectedLanguage.value;
  
  /// Get current units system
  String get currentUnits => selectedUnits.value;
  
  /// Get current refresh interval
  double get currentRefreshInterval => refreshInterval.value;
  
  /// Get current cache duration
  int get currentCacheDuration => cacheDuration.value;
}

// Helper function to get the SettingsController instance
SettingsController get settingsController => Get.find<SettingsController>();