import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/controllers/products_controller.dart';
import 'package:pharmacy_pos/database/orders_db_helper.dart';
import 'package:pharmacy_pos/models/order_model.dart';
import 'package:pharmacy_pos/models/product_model.dart';

class OrdersController extends GetxController {
  final orders = <OrderModel>[].obs;
  final OrdersDBHelper dbHelper = OrdersDBHelper();
  var filteredOrders = <OrderModel>[].obs; // Filtered orders

  final ProductsController productsController = Get.put(ProductsController());

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    orders.value = await dbHelper.getAllOrders();
    filteredOrders = orders;
  }

  Future<void> addOrder(OrderModel order) async {
    await dbHelper.addOrder(order).then((value) {
      for (var item in order.items) {
        ProductModel? productModel = productsController.productList
            .firstWhereOrNull((element) => element.id == item.productId);
        if (productModel != null) {
          // Calculate the updated units
          int updatedUnits = (productModel.availableUnits ?? 0) - item.quantity;
          // Update the product in the database and productList
          productsController.updateAvailableUnitsAndPacks(
            productId: item.productId,
            updatedUnits: updatedUnits,
          );
        }
      }
    });
    await _initialize();
  }

  Future<void> deleteOrder(String orderId) async {
    await dbHelper.deleteOrder(orderId);
    orders.removeWhere((order) => order.id == orderId);
  }

  Future<void> updateOrder(OrderModel updatedOrder) async {
    await dbHelper.updateOrder(updatedOrder);
    int index = orders.indexWhere((order) => order.id == updatedOrder.id);
    if (index != -1) {
      orders[index] = updatedOrder;
    }
  }

  Future<OrderModel?> getOrderById(String orderId) {
    return dbHelper.getOrderById(orderId);
  }

  void filterOrdersByDate(DateTime date) {
    filteredOrders.value = orders.where((order) {
      return DateFormat('yyyy-MM-dd').format(order.orderDate) ==
          DateFormat('yyyy-MM-dd').format(date);
    }).toList();
  }

  void clearFilters() {
    filteredOrders.value = orders; // Reset to all orders
  }
}
