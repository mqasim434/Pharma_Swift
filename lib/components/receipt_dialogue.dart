import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/models/order_model.dart';
import 'package:pharmacy_pos/utils/colors.dart';
import 'package:pharmacy_pos/utils/utility_functions.dart';

class ReceiptDialog extends StatelessWidget {
  final OrderModel order;

  ReceiptDialog({required this.order});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Receipt',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AL-NOOR CLINIC',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Text('Ghari Pull, Daulat Nagar.'),
              const Text('Ph: 0533-572041'),
              const Divider(),
              Text('Bill No: ${order.id}'),
              Text(
                  'Date: ${DateFormat('dd/MM/yyyy h:mm a').format(order.orderDate)}'),
              const Divider(),
              const Row(
                children: [
                  Expanded(
                      child: Text('Item #',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text('Name',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text('Qty',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text('Price',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text('Total',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
              const Divider(),
              ...List.generate(order.items.length, (index) {
                final item = order.items[index];
                double total = item.salePrice * item.quantity;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Item #${index + 1}:    ${item.name}(${item.strength})(${item.category.toString().substring(0, item.category.toString().length - 1)})',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        const Expanded(child: SizedBox()),
                        Expanded(
                            child: Text('${item.quantity}',
                                style: const TextStyle(fontSize: 12))),
                        Expanded(
                            child: Text('${item.salePrice.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 12))),
                        Expanded(
                            child: Text(total.toStringAsFixed(2),
                                style: const TextStyle(fontSize: 12))),
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
                  Text('${order.items.length}'),
                ],
              ),
              Row(
                children: [
                  const Text('Total Bill:'),
                  const Spacer(),
                  Text('${order.totalAmount.toStringAsFixed(2)}'),
                ],
              ),
              Row(
                children: [
                  const Text('Discount:'),
                  const Spacer(),
                  Text('${order.discount.toStringAsFixed(2)} %'),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Text('Net Bill:'),
                  const Spacer(),
                  Text('${order.netAmount.toStringAsFixed(2)}'),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          style: TextButton.styleFrom(backgroundColor: MyColors.greenColor),
          onPressed: () {
            UtilityFunctions.printReceipt(order, context).then((value) {
              Navigator.pop(context);
            });
          },
          child: const Text(
            'Print',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
