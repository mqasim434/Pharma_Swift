import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/controllers/orders_controller.dart';
import 'package:pharmacy_pos/controllers/products_controller.dart';
import 'package:pharmacy_pos/models/order_model.dart';
import 'package:pharmacy_pos/models/product_model.dart';

class TestPurchaseScreen extends StatefulWidget {
  const TestPurchaseScreen({super.key});

  @override
  State<TestPurchaseScreen> createState() => _TestPurchaseScreenState();
}

class _TestPurchaseScreenState extends State<TestPurchaseScreen> {
  final ProductsController productsController = Get.put(ProductsController());
  final OrdersController ordersController = Get.put(OrdersController());

  @override
  void initState() {
    super.initState();
    calculateTotalPurchaseOfSoldUnits();
    calculateTotalPurchaseOfAvailableUnits();
  }

  double calculateTotalPurchaseOfAvailableUnits() {
    double totalPurchase = 0.0;

    // Loop through all products
    for (ProductModel product in productsController.productList) {
      if (product.availableUnits != null && product.unitPurchasePrice != null) {
        // Calculate purchase cost for available units
        totalPurchase += product.availableUnits! * product.unitPurchasePrice!;
      }
    }

    print('Total Purchase Cost of Available Units: $totalPurchase');
    return totalPurchase;
  }

  double calculateTotalPurchaseOfSoldUnits() {
    double totalPurchase = 0.0;

    // Loop through all orders
    for (OrderModel order in ordersController.orders) {
      for (OrderItem item in order.items) {
        // Find the corresponding product in the product list
        ProductModel? productModel = productsController.productList
            .firstWhereOrNull((product) => product.id == item.productId);

        if (productModel != null) {
          // Log details for debugging
          print(
              'Calculating for ${productModel.name} (Unit): Quantity: ${item.quantity}, Unit Purchase Price: ${productModel.unitPurchasePrice}');
          totalPurchase += item.quantity * productModel.unitPurchasePrice;
        } else {
          // Log missing product
          print('Product with ID ${item.productId} not found!');
        }
      }
    }

    print('Total Purchase Cost: $totalPurchase');
    return totalPurchase;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Screen'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
                'Available Items: ${productsController.productList.length.toString()}'),
          ),
          ListTile(
            title: Text(
                'Total Purchase: ${(calculateTotalPurchaseOfSoldUnits() + calculateTotalPurchaseOfAvailableUnits()).toStringAsFixed(2)}'),
          ),
          ListTile(
            title: Text(
                'Available Items Purchase: ${calculateTotalPurchaseOfAvailableUnits().toStringAsFixed(2)}'),
          ),
          ListTile(
            title: Text(
                'Sold Items Purchase: ${calculateTotalPurchaseOfSoldUnits().toStringAsFixed(2)}'),
          ),
        ],
      ),
    );
  }
}
