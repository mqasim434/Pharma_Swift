import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/controllers/orders_controller.dart';
import 'package:pharmacy_pos/controllers/products_controller.dart';
import 'package:pharmacy_pos/models/product_model.dart';
import 'package:pharmacy_pos/utils/colors.dart';

import '../models/order_model.dart';

class UpdateOrderDialogue extends StatefulWidget {
  const UpdateOrderDialogue({super.key, required this.orderModel});

  final OrderModel orderModel;

  @override
  State<UpdateOrderDialogue> createState() => _UpdateOrderDialogueState();
}

class _UpdateOrderDialogueState extends State<UpdateOrderDialogue> {
  late List<TextEditingController> quantityControllers;
  late Map<String, int> originalQuantities; // To track original item quantities
  late List<OrderItem> deletedItems; // Track deleted items

  @override
  void initState() {
    super.initState();

    // Initialize controllers with the current item quantities
    quantityControllers = widget.orderModel.items
        .map((item) => TextEditingController(text: item.quantity.toString()))
        .toList();

    // Save original quantities for comparison
    originalQuantities = {
      for (var item in widget.orderModel.items) item.productId: item.quantity
    };

    // Initialize the deleted items list
    deletedItems = [];
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    for (var controller in quantityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void updateSummary() {
    setState(() {
      widget.orderModel.totalAmount = widget.orderModel.items.fold(
        0.0,
        (sum, item) => sum + (item.salePrice * item.quantity),
      );

      widget.orderModel.netAmount = widget.orderModel.totalAmount *
          (1 - widget.orderModel.discount / 100);
    });
  }

  Future<void> _applyUpdates() async {
    final productsController = Get.find<ProductsController>();
    final ordersController = Get.find<OrdersController>();

    // Revert product quantities for updated items
    for (var item in widget.orderModel.items) {
      final int originalQuantity = originalQuantities[item.productId] ?? 0;
      if (originalQuantity != item.quantity) {
        final ProductModel product = productsController.productList
            .firstWhere((p) => p.id == item.productId);

        productsController.updateAvailableUnitsAndPacks(
          productId: item.productId,
          updatedUnits:
              product.availableUnits! + (originalQuantity - item.quantity),
        );
      }
    }

    // Revert product quantities for deleted items
    for (var item in deletedItems) {
      final ProductModel product = productsController.productList
          .firstWhere((p) => p.id == item.productId);

      // Add back the stock for the deleted item
      productsController.updateAvailableUnitsAndPacks(
        productId: item.productId,
        updatedUnits: product.availableUnits! + item.quantity,
      );
    }

    // Update the order in the database
    await ordersController.updateOrder(widget.orderModel);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Update Order',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Order No: '),
                  Text(
                    widget.orderModel.id,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Order Date & Time: '),
                  Text(
                    DateFormat('dd/MM/yyyy h:mm a')
                        .format(widget.orderModel.orderDate),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const Divider(),
              const Text(
                'Items:',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const Row(
                children: [
                  Expanded(
                      child: Text('Item #',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text('Name',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text('Price',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text('Qty',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text('Total',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text('Action',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
              ...List.generate(widget.orderModel.items.length, (index) {
                final item = widget.orderModel.items[index];

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Item #${index + 1}: ${item.name} (${item.strength}) (${item.category})',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(child: SizedBox()), // Item number spacer
                        const Expanded(child: SizedBox()), // Name spacer
                        Expanded(
                          child: Text(item.salePrice.toStringAsFixed(2),
                              style: const TextStyle(fontSize: 12)),
                        ),
                        Expanded(
                          child: SizedBox(
                            child: TextFormField(
                              controller: quantityControllers[index],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  int quantity = int.tryParse(value) ?? 1;
                                  if (quantity <= 0) {
                                    quantity = 1;
                                    quantityControllers[index].text = '1';
                                  }
                                  item.quantity = quantity;
                                  updateSummary();
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '  ${(item.salePrice * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                // Track the deleted item
                                deletedItems.add(widget.orderModel.items[index]);

                                // Remove the item from the order
                                widget.orderModel.items.removeAt(index);
                                quantityControllers.removeAt(index);
                                updateSummary();
                              });
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              const Divider(),
              Row(
                children: [
                  const Text('Total Items:'),
                  const Spacer(),
                  Text('${widget.orderModel.items.length}'),
                ],
              ),
              Row(
                children: [
                  const Text('Total Bill:'),
                  const Spacer(),
                  Text(widget.orderModel.totalAmount.toStringAsFixed(2)),
                ],
              ),
              Row(
                children: [
                  const Text('Discount:'),
                  const Spacer(),
                  Text('${widget.orderModel.discount.toStringAsFixed(2)} %'),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Text('Net Bill:'),
                  const Spacer(),
                  Text(widget.orderModel.netAmount.toStringAsFixed(2)),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _applyUpdates,
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      backgroundColor: MyColors.greenColor),
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
