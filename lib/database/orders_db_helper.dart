import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/models/order_model.dart';

class OrdersDBHelper {
  static const String _orderBoxName = 'ordersBox';
  static const String _idBoxName = 'lastOrderIdBox';

  Future<Box<OrderModel>> _openOrderBox() async {
    return await Hive.openBox<OrderModel>(_orderBoxName);
  }

  Future<Box<int>> _openIdBox() async {
    return await Hive.openBox<int>(_idBoxName);
  }

  // Add a new order
  Future<void> addOrder(OrderModel order) async {
    final orderBox = await _openOrderBox();
    final idBox = await _openIdBox();

    // Generate a unique order ID
    int lastOrderId = idBox.get('lastOrderId') ?? 0;
    String newOrderId = '${lastOrderId + 1}';
    order.orderDate = DateTime.now().toLocal();

    // Clone the order to avoid key conflicts
    OrderModel newOrder = OrderModel(
      id: newOrderId,
      totalAmount: order.totalAmount,
      netAmount: order.netAmount,
      discount: order.discount,
      items: List.from(order.items),
      orderDate: order.orderDate, // Ensure deep copy
    );

    // Save the order with the new ID
    await orderBox.put(newOrderId, newOrder);
    print('Order Saved with ID: $newOrderId');

    // Update the lastOrderId
    await idBox.put('lastOrderId', lastOrderId + 1);

    // Close boxes (optional)
    await orderBox.close();
    await idBox.close();
  }

  Future<List<OrderModel>> getAllOrders() async {
    final orderBox = await _openOrderBox();
    return orderBox.values.toList();
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      final orderBox = await _openOrderBox();

      // Check if the ID exists
      if (orderBox.containsKey(orderId)) {
        await orderBox.delete(orderId);
        print('Order $orderId deleted successfully.');
      } else {
        print('Order with ID $orderId does not exist.');
      }
    } catch (e) {
      print('Error deleting order with ID $orderId: $e');
    }
  }

  // Update an existing order
  Future<void> updateOrder(OrderModel updatedOrder) async {
    final orderBox = await _openOrderBox();
    await orderBox.put(updatedOrder.id!, updatedOrder);
  }

  // Find an order by ID
  Future<OrderModel?> getOrderById(String orderId) async {
    final orderBox = await _openOrderBox();
    try {
      return orderBox.get(orderId);
    } catch (e) {
      // If no order is found, return null
      return null;
    }
  }

  // Close the order box (optional)
  Future<void> closeOrderBox() async {
    final orderBox = await _openOrderBox();
    await orderBox.close();
  }

  // Close the id box (optional)
  Future<void> closeIdBox() async {
    final idBox = await _openIdBox();
    await idBox.close();
  }
}
