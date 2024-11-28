import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  var searchResults = <OrderModel>[].obs; // Filtered orders
  RxBool isSearching = false.obs;

  final ProductsController productsController = Get.put(ProductsController());

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    orders.value = await dbHelper.getAllOrders();
    filteredOrders.value = orders
      ..sort((a, b) => a.orderDate.compareTo(b.orderDate));
  }

  Future<void> addOrder(OrderModel order) async {
    await dbHelper.addOrder(order).then((value) {
      for (var item in order.items) {
        ProductModel? productModel = productsController.productList
            .firstWhereOrNull((element) => element.id == item.productId);
        if (productModel != null) {
          int updatedUnits = (productModel.availableUnits ?? 0) - item.quantity;
          productsController.updateAvailableUnitsAndPacks(
            productId: item.productId,
            updatedUnits: updatedUnits,
          );
        }
      }
    });
    await _initialize();
  }

  Future<void> deleteOrder(OrderModel orderModel) async {
    // Update the available units for each product in the order
    for (var orderItem in orderModel.items) {
      final ProductModel productModel = productsController.productList
          .firstWhere((element) => orderItem.productId == element.id);
      productsController.updateAvailableUnitsAndPacks(
        productId: orderItem.productId,
        updatedUnits: (productModel.availableUnits ?? 0) + orderItem.quantity,
      );
    }
    // Delete the order from the database
    await dbHelper.deleteOrder(orderModel.id);
    // Reinitialize the order list to reflect changes
    await _initialize();
  }

  Future<void> updateOrder(OrderModel updatedOrder) async {
    await dbHelper.updateOrder(updatedOrder);
    int index = orders.indexWhere((order) => order.id == updatedOrder.id);
    if (index != -1) {
      orders[index] = updatedOrder;
    }
    await _initialize();
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

  void searchOrders(String query) {
    print("Searching for: $query");
    if (query.isNotEmpty) {
      isSearching.value = true;
      searchResults.value = filteredOrders.where((order) {
        return order.id.toString().toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      isSearching.value = false;
    }
    print("Filtered Orders: ${filteredOrders.length}");
  }

  void clearFilters() {
    filteredOrders.value = orders; // Reset to all orders
  }
}
