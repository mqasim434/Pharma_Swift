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
    final SideNavController sideNavController = Get.find();

    return Container(
      color: MyColors.darkGreyColor,
      width: screenWidth * 0.13,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(width: 80, 'assets/images/pharmacy.png'),
                SizedBox(
                  height: 4,
                ),
                Text(
                  'Pharma Swift',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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
                icon: Icons.list_alt,
                isSelected:
                    sideNavController.selectedItemLabel.value == 'Orders',
                onTap: () {
                  sideNavController.changeSelectedLabel('Orders');
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
                label: 'Stock',
                icon: Icons.production_quantity_limits,
                isSelected:
                    sideNavController.selectedItemLabel.value == 'Stock',
                onTap: () {
                  sideNavController.changeSelectedLabel('Stock');
                },
              )),
          Obx(() => NavItemWidget(
                label: 'Sales',
                icon: Icons.assessment,
                isSelected:
                    sideNavController.selectedItemLabel.value == 'Sales',
                onTap: () {
                  sideNavController.changeSelectedLabel('Sales');
                },
              )),
          Obx(() => NavItemWidget(
                label: 'Expiry',
                icon: Icons.event,
                isSelected:
                    sideNavController.selectedItemLabel.value == 'Expiry',
                onTap: () {
                  sideNavController.changeSelectedLabel('Expiry');
                },
              )),
          Obx(
            () => NavItemWidget(
              label: 'Purchase',
              icon: Icons.assignment,
              isSelected:
                  sideNavController.selectedItemLabel.value == 'Purchase',
              onTap: () {
                sideNavController.changeSelectedLabel('Purchase');
              },
            ),
          ),
          // Obx(() => NavItemWidget(
          //       label: 'Test',
          //       icon: Icons.event,
          //       isSelected: sideNavController.selectedItemLabel.value == 'Test',
          //       onTap: () {
          //         sideNavController.changeSelectedLabel('Test');
          //       },
          //     )),
          Obx(() => NavItemWidget(
                label: 'Analytics',
                icon: Icons.trending_up,
                isSelected:
                    sideNavController.selectedItemLabel.value == 'Analytics',
                onTap: () {
                  sideNavController.changeSelectedLabel('Analytics');
                },
              )),
        ],
      ),
    );
  }
}
