import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/controllers/settings_controller.dart';

import 'package:weather_app/widgets/my_text.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsController settingsCtrl = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Custom App Bar
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blueAccent.shade700,
                  Colors.blueAccent.shade400,
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const MyText(
                    text: 'Settings',
                    color: Colors.white,
                    size: 24,
                    weight: FontWeight.w700,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Settings Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Temperature Unit Section
                    _buildSectionTitle('Temperature Unit'),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildUnitButton(
                              isSelected: settingsCtrl.isCelsius.value,
                              text: '°C',
                              onTap: () => settingsCtrl.isCelsius.value = true,
                            ),
                          ),
                          Expanded(
                            child: _buildUnitButton(
                              isSelected: !settingsCtrl.isCelsius.value,
                              text: '°F',
                              onTap: () => settingsCtrl.isCelsius.value = false,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Measurement Units
                    _buildSectionTitle('Measurement Units'),
                    _buildSettingItem(
                      icon: Icons.straighten_outlined,
                      title: 'Units System',
                      value: settingsCtrl.selectedUnits.value,
                      onTap: () => _showUnitsDialog(settingsCtrl),
                    ),

                    const SizedBox(height: 24),

                    // Language
                    _buildSectionTitle('Language'),
                    _buildSettingItem(
                      icon: Icons.language_outlined,
                      title: 'App Language',
                      value: settingsCtrl.selectedLanguage.value,
                      onTap: () => _showLanguageDialog(settingsCtrl),
                    ),

                    const SizedBox(height: 24),

                    // Refresh Interval
                    _buildSectionTitle('Refresh Interval'),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                text: 'Auto Refresh',
                                size: 16,
                                weight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              MyText(
                                text:
                                    '${settingsCtrl.refreshInterval.value.round()} min',
                                size: 16,
                                weight: FontWeight.w600,
                                color: Colors.blueAccent,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Slider(
                            value: settingsCtrl.refreshInterval.value,
                            min: 5,
                            max: 60,
                            divisions: 11,
                            activeColor: Colors.blueAccent,
                            inactiveColor: Colors.grey[800],
                            onChanged: (value) {
                              settingsCtrl.refreshInterval.value = value;
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                text: '5 min',
                                size: 12,
                                color: Colors.grey[500],
                              ),
                              MyText(
                                text: '60 min',
                                size: 12,
                                color: Colors.grey[500],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Toggle Settings
                    _buildSectionTitle('Preferences'),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildToggleItem(
                            icon: Icons.notifications_outlined,
                            title: 'NearCast Notifications',
                            value: settingsCtrl.notificationsEnabled.value,
                            onChanged: (value) =>
                                settingsCtrl.notificationsEnabled.value = value,
                          ),
                          // _buildDivider(),
                          // _buildToggleItem(
                          //   icon: Icons.dark_mode_outlined,
                          //   title: 'Dark Mode',
                          //   value: settingsCtrl.darkModeEnabled.value,
                          //   onChanged: (value) =>
                          //       settingsCtrl.darkModeEnabled.value = value,
                          // ),
                          _buildDivider(),
                          _buildToggleItem(
                            icon: Icons.location_on_outlined,
                            title: 'Use Current Location',
                            value: settingsCtrl.locationEnabled.value,
                            onChanged: (value) =>
                                settingsCtrl.locationEnabled.value = value,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // About & Support
                    _buildSectionTitle('About & Support'),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildListTile(
                            icon: Icons.info_outline,
                            title: 'About NearCast',
                            onTap: () => _showAboutDialog(),
                          ),
                          _buildDivider(),
                          _buildListTile(
                            icon: Icons.help_outline,
                            title: 'Help & Support',
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _buildListTile(
                            icon: Icons.restart_alt_outlined,
                            title: 'Reset to Defaults',
                            onTap: () => _showResetConfirmation(settingsCtrl),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Save Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blueAccent.shade400,
                            Colors.blueAccent.shade700,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          // Save settings
                          await settingsCtrl.saveSettings();
                          Navigator.pop(context);
                        },
                        child: const MyText(
                          text: 'Save Settings',
                          size: 18,
                          weight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Version Info
                    Center(
                      child: MyText(
                        text: 'NearCast v1.0.0',
                        size: 14,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
      child: MyText(
        text: title,
        size: 16,
        weight: FontWeight.w600,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildUnitButton({
    required bool isSelected,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Center(
          child: MyText(
            text: text,
            size: 20,
            weight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.blueAccent : Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.1),
              ),
              child: Icon(icon, color: Colors.blueAccent, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: title,
                    size: 16,
                    weight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 2),
                  MyText(text: value, size: 14, color: Colors.grey[400]),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueAccent.withOpacity(0.1),
            ),
            child: Icon(icon, color: Colors.blueAccent, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: MyText(
              text: title,
              size: 16,
              weight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blueAccent,
            activeTrackColor: Colors.blueAccent.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.1),
              ),
              child: Icon(icon, color: Colors.blueAccent, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MyText(
                text: title,
                size: 16,
                weight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: Colors.grey[800]),
    );
  }

  void _showUnitsDialog(SettingsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const MyText(
          text: 'Select Units',
          size: 20,
          weight: FontWeight.w600,
          color: Colors.white,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogOption(
              'Metric (km/h)',
              'Metric',
              controller.selectedUnits.value == 'Metric',
              () {
                controller.selectedUnits.value = 'Metric';
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
            _buildDialogOption(
              'Imperial (mph)',
              'Imperial',
              controller.selectedUnits.value == 'Imperial',
              () {
                controller.selectedUnits.value = 'Imperial';
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(SettingsController controller) {
    final languages = ['English', 'Urdu', 'Spanish', 'French', 'Arabic'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const MyText(
          text: 'Select Language',
          size: 20,
          weight: FontWeight.w600,
          color: Colors.white,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              return _buildDialogOption(
                languages[index],
                languages[index],
                controller.selectedLanguage.value == languages[index],
                () {
                  controller.selectedLanguage.value = languages[index];
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDialogOption(
    String text,
    String value,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Center(
          child: MyText(
            text: text,
            size: 16,
            weight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.blueAccent : Colors.white,
          ),
        ),
      ),
    );
  }

  void _showResetConfirmation(SettingsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: MyText(
          text: 'Reset Settings',
          size: 20,
          weight: FontWeight.w600,
          color: Colors.white,
        ),
        content: MyText(
          text: 'Are you sure you want to reset all settings to default?',
          size: 16,
          color: Colors.grey[300],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: MyText(text: 'Cancel', size: 16, color: Colors.grey[400]),
          ),
          TextButton(
            onPressed: () async {
              await controller.resetToDefaults();
              Navigator.pop(context);
            },
            child: const MyText(text: 'Reset', size: 16, color: Colors.red),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent.shade400,
                    Colors.blueAccent.shade700,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wb_sunny, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            const MyText(
              text: 'NearCast',
              size: 22,
              weight: FontWeight.w700,
              color: Colors.white,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyText(text: 'Version 1.0.0', size: 14, color: Colors.grey[400]),
            const SizedBox(height: 16),
            MyText(
              text:
                  'Stay updated with accurate weather forecasts and real-time conditions. Built with Flutter.',
              size: 14,
              color: Colors.grey[300],
              align: TextAlign.center,
            ),
            const SizedBox(height: 20),
            MyText(
              text: '© 2024 Weather App. All rights reserved.',
              size: 12,
              color: Colors.grey[500],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const MyText(
              text: 'Close',
              size: 16,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
