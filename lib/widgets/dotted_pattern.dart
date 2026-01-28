import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/map/map_page.dart';

class DottedPattern extends StatelessWidget {
  const DottedPattern({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => MapPage());
      },
      child: SizedBox(
        width: 34, // Fixed width
        height: 34, // Fixed height
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Don't expand
            children: [
              Row(
                mainAxisSize: MainAxisSize.min, // Don't expand
                children: [
                  _buildDot(),
                  const SizedBox(width: 2),
                  _buildDot(),
                  const SizedBox(width: 2),
                  _buildDot(),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min, // Don't expand
                children: [
                  _buildDot(),
                  const SizedBox(width: 2),
                  _buildDot(),
                  const SizedBox(width: 2),
                  _buildDot(),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min, // Don't expand
                children: [
                  _buildDot(),
                  const SizedBox(width: 2),
                  _buildDot(),
                  const SizedBox(width: 2),
                  _buildDot(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    );
  }
}
