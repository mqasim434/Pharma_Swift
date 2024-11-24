import 'package:get/get.dart';
import 'package:pharmacy_pos/controllers/orders_controller.dart';
import 'package:pharmacy_pos/models/order_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AnalyticsController extends GetxController {
  // Reference to OrdersController to access the orders
  final OrdersController ordersController =
      Get.put<OrdersController>(OrdersController());
  RxString selectedFilter = 'Profit'.obs;
  var selectedDate = DateTime.now().obs; // Make selectedDate reactive

  // Get the orders for the selected month and year
  List<OrderModel> getOrdersForMonth(int month, int year) {
    return ordersController.orders.where((order) {
      final orderDate = order.orderDate;
      return orderDate != null &&
          orderDate.month == month &&
          orderDate.year == year;
    }).toList();
  }

  // Calculate daily sales for the selected month
  List<FlSpot> getSalesData() {
    List<OrderModel> orders = getOrdersForMonth(
      selectedDate.value.month,
      selectedDate.value.year,
    );
    List<double> dailySales = List.filled(31, 0); // Max days in a month

    for (var order in orders) {
      int day = order.orderDate.day;
      double bill = order.totalAmount;
      dailySales[day - 1] += bill;
    }

    return dailySales.asMap().entries.map((entry) {
      int day = entry.key + 1;
      double sales = entry.value;
      return FlSpot(day.toDouble(), sales);
    }).toList();
  }

  // Get order count for the selected month
  List<FlSpot> getOrderData() {
    List<OrderModel> orders = getOrdersForMonth(
      selectedDate.value.month,
      selectedDate.value.year,
    );
    List<int> dailyOrders = List.filled(31, 0); // Max days in a month

    for (var order in orders) {
      int day = order.orderDate.day;
      dailyOrders[day - 1] += 1;
    }

    return dailyOrders.asMap().entries.map((entry) {
      int day = entry.key + 1;
      int orderCount = entry.value;
      return FlSpot(day.toDouble(), orderCount.toDouble());
    }).toList();
  }

  // Get profit data (this can be implemented similarly to sales, depending on your logic)
  List<FlSpot> getProfitData() {
    List<OrderModel> orders = getOrdersForMonth(
      selectedDate.value.month,
      selectedDate.value.year,
    );
    List<double> dailyProfit = List.filled(31, 0); // Max days in a month

    for (var order in orders) {
      int day = order.orderDate.day;
      // Using fold to accumulate profit from all items in the order
      double totalProfit = order.items.fold(0.0, (acc, item) {
        // Use the profit from each item in the order
        double itemProfit = item.profit * item.quantity;
        return acc + itemProfit - ((order.discount / 100) * order.totalAmount);
      });
      dailyProfit[day - 1] += totalProfit;
    }

    return dailyProfit.asMap().entries.map((entry) {
      int day = entry.key + 1;
      double profit = entry.value;
      return FlSpot(day.toDouble(), profit.toPrecision(2));
    }).toList();
  }

  // Get the current data based on the selected filter
  List<FlSpot> getCurrentData() {
    switch (selectedFilter.value) {
      case 'Profit':
        return getProfitData();
      case 'Sales':
        return getSalesData();
      case 'Orders':
        return getOrderData();
      default:
        return [];
    }
  }

  // Process data whenever the date is selected or the filter changes
  void processOrderData() {
    // This will force a refresh of the data based on the selected month and filter
    update();
  }
}
