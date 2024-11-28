import 'package:get/get.dart';
import 'package:pharmacy_pos/controllers/orders_controller.dart';
import 'package:pharmacy_pos/controllers/purchase_controller.dart';
import 'package:pharmacy_pos/models/order_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/models/purchase_model.dart';
import 'package:pharmacy_pos/utils/utility_functions.dart';

class AnalyticsController extends GetxController {
  // Reference to OrdersController to access the orders
  final OrdersController ordersController =
      Get.put<OrdersController>(OrdersController());
  final PurchaseController purchaseController =
      Get.put<PurchaseController>(PurchaseController());
  RxString selectedFilter = 'Sales'.obs;
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

  List<FlSpot> getPurchasesData() {
    // Get all purchases for the selected month and year
    List<PurchaseModel> purchases =
        purchaseController.purchases.where((purchase) {
      final purchaseDate = purchase.purchaseDate;
      return purchaseDate != null &&
          DateFormat('dd/MM/yyyy').parse(purchaseDate).month ==
              selectedDate.value.month &&
          DateFormat('dd/MM/yyyy').parse(purchaseDate).year ==
              selectedDate.value.year;
    }).toList();

    // Initialize daily purchases list with zeros
    List<double> dailyPurchases = List.filled(31, 0); // Max days in a month

    // Aggregate purchase amounts for each day
    for (var purchase in purchases) {
      int day =
          DateFormat('dd/MM/yyyy').parse(purchase.purchaseDate.toString()).day;
      double amount = purchase.isSingleUnit
          ? purchase.availableUnits! * purchase.unitPurchasePrice!
          : (purchase.availablePacks! * purchase.packPurchasePrice!);
      dailyPurchases[day - 1] += amount;
    }

    // Convert daily purchases into FlSpot data points
    return dailyPurchases.asMap().entries.map((entry) {
      int day = entry.key + 1;
      double amount = entry.value;
      return FlSpot(day.toDouble(), amount);
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
      double totalProfit = UtilityFunctions.calculateProfitAfterDiscount(order);
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
      case 'Purchases':
        return getPurchasesData();
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
