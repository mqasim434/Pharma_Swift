import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/controllers/current_order_controller.dart';
import 'package:pharmacy_pos/utils/colors.dart';

class CartItemWidget extends StatefulWidget {
  final String itemName;
  final String id;
  final double price;
  final int quantity;
  final VoidCallback onRemove;
  final void Function(String)? onQuantityChanged;

  const CartItemWidget({
    super.key,
    required this.itemName,
    required this.id,
    required this.price,
    required this.quantity,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  late TextEditingController quantityController;
  final formKey = GlobalKey<FormState>();
  final currentOrderController = Get.find<CurrentOrderController>();

  @override
  void initState() {
    super.initState();
    quantityController = TextEditingController(
      text: currentOrderController.orderItems
          .firstWhere((element) => element.productId == widget.id)
          .quantity
          .toString(),
    );
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8, right: 10, left: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.itemName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      InkWell(
                          onTap: widget.onRemove,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Unit: \$${widget.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Quantity: '),
                        SizedBox(
                          height: 20,
                          width: 100,
                          child: TextFormField(
                            controller: quantityController,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                                hintText: 'Quantity',
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 5),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a quantity';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              widget.onQuantityChanged!(val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    return Text(
                      'Total: \$${(widget.price * currentOrderController.orderItems.firstWhere((element) => element.productId == widget.id).quantity).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
