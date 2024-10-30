// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/components/nav_item_widget.dart';
import 'package:pharmacy_pos/controllers/side_nav_controller.dart';
import 'package:pharmacy_pos/utils/colors.dart';

class SideNavBar extends StatelessWidget {
  const SideNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final SideNavController sideNavController =
        Get.find(); // Access the existing controller

    return Container(
      color: MyColors.darkGreyColor,
      width: screenWidth * 0.13,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.medical_information,
                  color: MyColors.greenColor,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  'MediKit\nPOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            subtitle: Text(
              'Main Menu',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          // Only wrap individual NavItemWidgets with Obx
          Obx(() => NavItemWidget(
                label: 'Home',
                icon: Icons.home,
                isSelected: sideNavController.selectedItemLabel.value == 'Home',
                onTap: () {
                  sideNavController.changeSelectedLabel('Home');
                },
              )),
          Obx(() => NavItemWidget(
                label: 'Orders',
                icon: Icons.history,
                isSelected:
                    sideNavController.selectedItemLabel.value == 'Orders',
                onTap: () {
                  sideNavController.changeSelectedLabel('Orders');
                },
              )),
          Obx(() => NavItemWidget(
                label: 'Suppliers',
                icon: Icons.production_quantity_limits,
                isSelected:
                    sideNavController.selectedItemLabel.value == 'Suppliers',
                onTap: () {
                  sideNavController.changeSelectedLabel('Suppliers');
                },
              )),
          Obx(() => NavItemWidget(
                label: 'Products',
                icon: Icons.medication,
                isSelected:
                    sideNavController.selectedItemLabel.value == 'Products',
                onTap: () {
                  sideNavController.changeSelectedLabel('Products');
                },
              )),
          Obx(() => NavItemWidget(
                label: 'Settings',
                icon: Icons.settings,
                isSelected:
                    sideNavController.selectedItemLabel.value == 'Settings',
                onTap: () {
                  sideNavController.changeSelectedLabel('Settings');
                },
              )),
        ],
      ),
    );
  }
}
