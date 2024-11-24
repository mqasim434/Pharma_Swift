import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:get/get.dart';
import 'package:pharmacy_pos/controllers/analytics_controller.dart';
import 'package:pharmacy_pos/utils/colors.dart';

class AnalyticsScreen extends StatelessWidget {
  final AnalyticsController controller = Get.put(AnalyticsController());

  AnalyticsScreen() {
    controller.processOrderData(); // Initial data processing when screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analytics',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: MyColors.greenColor,
      ),
      body: Column(
        children: [
          // Filter buttons that do not require reactive updates themselves
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilterButton(
                  label: 'Profit',
                  filterType: 'Profit',
                  controller: controller,
                ),
                SizedBox(width: 8),
                FilterButton(
                  label: 'Sales',
                  filterType: 'Sales',
                  controller: controller,
                ),
                SizedBox(width: 8),
                FilterButton(
                  label: 'Orders',
                  filterType: 'Orders',
                  controller: controller,
                ),
              ],
            ),
          ),

          // Date selection button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(
                'Select Month: ${DateFormat.yMMM().format(controller.selectedDate.value)}',
              ),
            ),
          ),

          // Chart display wrapped with Obx to update reactively
          Expanded(
            child: Obx(() {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                    ),
                    borderData: FlBorderData(
                      border: const Border(
                        left: BorderSide(color: Colors.black),
                        bottom: BorderSide(color: Colors.black),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: controller.getCurrentData(),
                        isCurved: true,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != controller.selectedDate) {
      controller.selectedDate.value = picked;
      controller.processOrderData(); // Reprocess data when date is selected
    }
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final String
      filterType; // Added to identify which filter this button applies to
  final AnalyticsController controller;

  FilterButton({
    Key? key,
    required this.label,
    required this.controller,
    required this.filterType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isSelected = controller.selectedFilter.value == filterType;
      return GestureDetector(
        onTap: () {
          if (!isSelected) {
            controller.selectedFilter.value = filterType;
            controller
                .processOrderData(); // Reprocess data when filter is changed
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    });
  }
}
