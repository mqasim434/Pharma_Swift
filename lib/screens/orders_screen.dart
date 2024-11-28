import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/components/receipt_dialogue.dart';
import 'package:pharmacy_pos/components/table_cell.dart';
import 'package:pharmacy_pos/components/update_order_dialogue.dart';
import 'package:pharmacy_pos/controllers/orders_controller.dart';
import 'package:pharmacy_pos/controllers/orders_filter_controller.dart';
import 'package:pharmacy_pos/models/order_model.dart';
import 'package:pharmacy_pos/utils/colors.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String selectedFilter = "Today"; // Default filter
  DateTime? selectedDate;

  final ordersController = Get.put(OrdersController());
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.greenColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Orders',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.215,
                  height: 40,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search an item...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    onChanged: (value) {
                      ordersController.searchOrders(value);
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: selectedFilter,
                  items: const [
                    DropdownMenuItem(value: "Today", child: Text("Today")),
                    DropdownMenuItem(
                        value: "Selected Date", child: Text("Selected Date")),
                    DropdownMenuItem(
                        value: "All Orders", child: Text("All Orders")),
                  ],
                  onChanged: (value) async {
                    setState(() {
                      selectedFilter = value!;
                    });
                    if (value == "Today") {
                      selectedDate = null;
                      Get.find<OrderFilterController>().setDate(DateTime.now());
                    } else if (value == "Selected Date") {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                        Get.find<OrderFilterController>().setDate(pickedDate);
                      } else {
                        setState(() {
                          selectedFilter =
                              "Today"; // Revert if no date selected
                        });
                      }
                    } else if (value == "All Orders") {
                      selectedDate = null;
                      Get.find<OrderFilterController>().setDate(null);
                    }
                  },
                ),
                if (selectedFilter == "Selected Date" && selectedDate != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Selected: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Content
          Expanded(
            child: Obx(() {
              var ordersController =
                  Get.put<OrdersController>(OrdersController());
              var orderFilterController =
                  Get.put<OrderFilterController>(OrderFilterController());
              var filteredOrders = ordersController.isSearching.value
                  ? ordersController.searchResults
                  : orderFilterController
                      .filterOrders(ordersController.orders.reversed.toList());
              double totalProfit = filteredOrders.fold(
                  0.0,
                  (sum, order) =>
                      sum +
                      order.items.fold(
                          0.0,
                          (itemSum, item) =>
                              itemSum + (item.profit * item.quantity)) -
                      ((order.discount / 100) * order.totalAmount));
              return Column(
                children: [
                  // Total Sale
                  Container(
                    color: MyColors.darkGreyColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Sale: ${filteredOrders.fold(0.0, (sum, order) => sum + order.netAmount).toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'Total Profit: ${totalProfit.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'Filter: ${selectedFilter}',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  // Table Header (Fixed)
                  Table(
                    border: TableBorder.all(color: Colors.white),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(3),
                      3: FlexColumnWidth(2),
                      4: FlexColumnWidth(2),
                      5: FlexColumnWidth(2),
                      6: FlexColumnWidth(2),
                      7: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        decoration:
                            const BoxDecoration(color: MyColors.greenColor),
                        children: [
                          tableCell('Order ID', isHeader: true),
                          tableCell('Items', isHeader: true),
                          tableCell('Order Date', isHeader: true),
                          tableCell('Total Amount', isHeader: true),
                          tableCell('Discount', isHeader: true),
                          tableCell('Net Amount', isHeader: true),
                          tableCell('Profit', isHeader: true),
                          tableCell('Actions', isHeader: true),
                        ],
                      ),
                    ],
                  ),
                  // Table Rows
                  Expanded(
                    child: filteredOrders.isEmpty
                        ? const Center(
                            child: Text('No Orders Found'),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: filteredOrders.map((order) {
                                return Table(
                                  border: TableBorder.all(color: Colors.grey),
                                  columnWidths: const {
                                    0: FlexColumnWidth(2),
                                    1: FlexColumnWidth(1),
                                    2: FlexColumnWidth(3),
                                    3: FlexColumnWidth(2),
                                    4: FlexColumnWidth(2),
                                    5: FlexColumnWidth(2),
                                    6: FlexColumnWidth(2),
                                    7: FlexColumnWidth(2),
                                  },
                                  children: [
                                    TableRow(
                                      children: [
                                        tableCell(order.id.toString()),
                                        tableCell(order.items.length.toString(),
                                            hasOrderViewAction: true,
                                            viewOrder: () {
                                          showOrderItemsDialog(
                                            context,
                                            order.items,
                                          );
                                        }),
                                        tableCell(
                                            DateFormat('dd/MMM/yy, h:mm:ss a')
                                                .format(order.orderDate)),
                                        tableCell(order.totalAmount
                                            .toStringAsFixed(2)),
                                        tableCell(
                                            '${order.discount.toStringAsFixed(2)} %'),
                                        tableCell(
                                            order.netAmount.toStringAsFixed(2)),
                                        tableCell(
                                          order.items
                                              .fold(
                                                  0.0,
                                                  (subtotal, item) =>
                                                      subtotal +
                                                      (item.salePrice -
                                                              item
                                                                  .retailPrice) *
                                                          item.quantity -
                                                      (order.discount / 100) *
                                                          order.totalAmount)
                                              .toStringAsFixed(2),
                                        ),
                                        tableCell(
                                          'Actions',
                                          hasProductActions: true,
                                          viewProduct: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return ReceiptDialog(
                                                      order: order);
                                                });
                                          },
                                          editProduct: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return UpdateOrderDialogue(
                                                    orderModel: order.copy(),
                                                  );
                                                });
                                          },
                                          deleteProduct: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Are you sure to delete order ${order.id}'),
                                                  actions: [
                                                    TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Colors.red),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          'No',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                    TextButton(
                                                        style: TextButton.styleFrom(
                                                            backgroundColor:
                                                                MyColors
                                                                    .greenColor),
                                                        onPressed: () {
                                                          ordersController
                                                              .deleteOrder(
                                                                  order);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

void showOrderItemsDialog(BuildContext context, List<OrderItem> orderItems) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Order Items'),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close))
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Table(
                  border: TableBorder.all(),
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(1),
                    5: FlexColumnWidth(1),
                    6: FlexColumnWidth(1),
                    7: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      children: const [
                        TableCell(
                          child: Center(child: Text('Product Name')),
                        ),
                        TableCell(
                          child: Center(child: Text('Formula')),
                        ),
                        TableCell(
                          child: Center(child: Text('Category')),
                        ),
                        TableCell(
                          child: Center(child: Text('Company')),
                        ),
                        TableCell(
                          child: Center(child: Text('Quantity')),
                        ),
                        TableCell(
                          child: Center(child: Text('Purchase Price')),
                        ),
                        TableCell(
                          child: Center(child: Text('Sale Price')),
                        ),
                        TableCell(
                          child: Center(child: Text('Unit Profit')),
                        ),
                        TableCell(
                          child: Center(child: Text('Total Profit')),
                        ),
                      ],
                    ),
                    ...orderItems.map((item) {
                      return TableRow(
                        children: [
                          TableCell(
                            child: Center(child: Text(item.name)),
                          ),
                          TableCell(
                            child: Center(child: Text(item.formula)),
                          ),
                          TableCell(
                            child: Center(child: Text(item.category)),
                          ),
                          TableCell(
                            child: Center(child: Text(item.company)),
                          ),
                          TableCell(
                            child:
                                Center(child: Text(item.quantity.toString())),
                          ),
                          TableCell(
                            child: Center(
                                child:
                                    Text(item.retailPrice.toStringAsFixed(2))),
                          ),
                          TableCell(
                            child: Center(
                                child: Text(item.salePrice.toStringAsFixed(2))),
                          ),
                          TableCell(
                            child: Center(
                                child: Text(item.profit.toStringAsFixed(2))),
                          ),
                          TableCell(
                            child: Center(
                                child: Text((item.profit * item.quantity)
                                    .toStringAsFixed(2))),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
