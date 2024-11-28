import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/components/side_nav_bar.dart';
import 'package:pharmacy_pos/controllers/side_nav_controller.dart';
import 'package:pharmacy_pos/utils/colors.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key}) {
    Get.put(SideNavController());
  }

  @override
  Widget build(BuildContext context) {
    final SideNavController sideNavController = Get.find<SideNavController>();
    return Row(
      children: [
        // Sidebar should not be wrapped in Obx as a whole; only specific parts should observe state
        const Expanded(child: SideNavBar()),
        Expanded(
          flex: 8,
          child: Obx(
            () => PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: sideNavController.pageController,
              children: sideNavController.screensList
                  .toList(), // Convert RxList to a regular list
            ),
          ),
        ),
      ],
    );
  }
}
