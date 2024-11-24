import 'package:hive/hive.dart';
import 'package:pharmacy_pos/models/order_model.dart';

class SalesHelper {
  static const String orderBoxName = 'ordersBox';

  Future<void> openBox() async {
    await Hive.openBox<OrderModel>(orderBoxName);
  }

  List<OrderModel> getOrdersForMonth(int month, int year) {
    openBox().then((value) {});
    final box = Hive.box<OrderModel>(orderBoxName);
    return box.values.where((order) {
      final orderDate = order.orderDate;
      return orderDate != null &&
          orderDate.month == month &&
          orderDate.year == year;
    }).toList();
  }

  List<double> calculateDailySales(int month, int year) {
    List<OrderModel> orders = getOrdersForMonth(month, year);
    List<double> dailySales = List.filled(31, 0); // Max days in a month

    for (var order in orders) {
      if (order.orderDate == null) {
        print("Order with null date: ${order.id}");
      } else {
        int day = order.orderDate!.day;
        double bill = double.tryParse(order.netAmount.toString()) ?? 0;
        dailySales[day - 1] += bill;
      }
    }

    return dailySales;
  }
}
