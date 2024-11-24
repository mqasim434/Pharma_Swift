import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/controllers/filter_controller.dart';
class FilterItemWidget extends StatelessWidget {
  const FilterItemWidget({
    super.key,
    required this.filterLabel,
    required this.filterIcon,
  });

  final String filterLabel;
  final IconData filterIcon;

  @override
  Widget build(BuildContext context) {
    Get.put(FiltersController());
    final FiltersController filtersController = Get.find<FiltersController>();

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: InkWell(
        onTap: () {
          filtersController.changeLabel(filterLabel);
        },
        child: Obx(() {
          final bool isSelected =
              filtersController.selectedLabel.value == filterLabel;

          return Chip(
            backgroundColor: isSelected
                ? Colors.orangeAccent
                : Get.isDarkMode
                    ? const Color(0xff3E3E42)
                    : Colors.white,
            label: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  filterIcon,
                  color: isSelected
                      ? Colors.white
                      : Get.isDarkMode
                          ? Colors.grey
                          : Colors.black,
                ),
                const SizedBox(width: 8), // Add spacing between icon and text
                Text(
                  filterLabel,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Get.isDarkMode
                            ? Colors.grey
                            : Colors.black,
                  ),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.transparent),
            ),
          );
        }),
      ),
    );
  }
}
