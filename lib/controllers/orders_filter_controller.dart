import 'package:get/get.dart';
import 'package:pharmacy_pos/models/order_model.dart';

class OrderFilterController extends GetxController {
  var selectedDate = Rx<DateTime?>(null);

  void setDate(DateTime? date) {
    selectedDate.value = date;
  }

  OrderFilterController() {
    selectedDate.value = DateTime.now();
  }

  List<OrderModel> filterOrders(List<OrderModel> orders) {
    if (selectedDate.value == null) {
      return orders;
    }
    return orders
        .where((order) =>
            order.orderDate.year == selectedDate.value!.year &&
            order.orderDate.month == selectedDate.value!.month &&
            order.orderDate.day == selectedDate.value!.day)
        .toList();
  }

  var selectedMonth = 0.obs;
  var selectedYear = 0.obs;

  /// Set the selected month and year for filtering
  void setMonthAndYear(int month, int year) {
    selectedMonth.value = month;
    selectedYear.value = year;
  }

  /// Filter orders by selected month and year
  List<OrderModel> filterOrdersByMonth(List<OrderModel> orders) {
    return orders.where((order) {
      return order.orderDate.month == selectedMonth.value &&
          order.orderDate.year == selectedYear.value;
    }).toList();
  }
}
