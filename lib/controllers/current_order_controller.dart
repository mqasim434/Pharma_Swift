import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/database/orders_db_helper.dart';
import 'package:pharmacy_pos/models/order_model.dart';
import 'package:pharmacy_pos/models/product_model.dart';

class CurrentOrderController extends GetxController {
  var orderItems = <OrderItem>[].obs;
  var currentOrder = OrderModel(
    id: '',
    orderDate: DateTime.now(),
    items: [],
    totalAmount: 0.0,
    discount: 0.0,
    netAmount: 0.0,
    customerName: '',
    notes: '',
  ).obs;

  TextEditingController discountController = TextEditingController(text: '0');
  TextEditingController customerNameController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  void updateQuantity(String productId, String value) {
    int quantity = int.tryParse(value) ?? 0;
    var item =
        orderItems.firstWhere((element) => element.productId == productId);
    item.quantity = quantity;
    item.totalPrice = item.salePrice * quantity;
    updateTotals();
  }

  void addItemToCart(ProductModel item) {
    print(item.id);
    print('Added Product ${item.toString()}');
    final orderItem = OrderItem(
      productId: item.id,
      name: item.name,
      quantity: 1,
      retailPrice: item.unitPurchasePrice,
      category: item.category,
      company: item.company,
      formula: item.formula.toString(),
      strength: item.strength.toString(),
      salePrice:
          item.unitSalePrice == null ? 0.0 : item.unitSalePrice!.toDouble(),
      totalPrice: item.unitSalePrice == null
          ? 0.0
          : item.unitSalePrice! * 1, // Default quantity
      profit: item.unitSalePrice == null
          ? 0.0
          : item.unitSalePrice! - item.unitPurchasePrice,
    );
    orderItems.add(orderItem);
    updateTotals();
  }

  void removeItemFromCart(OrderItem item) {
    orderItems.remove(item);
    updateTotals();
  }

  void setDiscount(double discount) {
    currentOrder.update((order) {
      order!.discount = discount;
      order.netAmount =
          order.totalAmount - (order.totalAmount * (order.discount / 100));
    });
  }

  void updateTotals() {
    currentOrder.update((order) {
      order!.totalAmount =
          orderItems.fold(0, (sum, item) => sum + item.totalPrice);
      order.netAmount =
          order.totalAmount - (order.totalAmount * (order.discount / 100));
    });
  }

  Future<void> saveOrder() async {
    currentOrder.update((order) {
      order!.customerName = customerNameController.text;
      order.notes = notesController.text;
      order.items = orderItems.toList(); // Assign the order items to the order
    });

    final ordersDBHelper = OrdersDBHelper();
    await ordersDBHelper.addOrder(currentOrder.value);
    clearOrder();
  }

  void clearOrder() {
    orderItems.clear();
    currentOrder.update((order) {
      order!.id = '';
      order.items.clear();
      order.totalAmount = 0.0;
      order.discount = 0.0;
      order.netAmount = 0.0;
      order.customerName = '';
      order.notes = '';
    });
    discountController.clear();
    customerNameController.clear();
    notesController.clear();
  }
}
