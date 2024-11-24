import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/components/receipt_dialogue.dart';
import 'package:pharmacy_pos/components/table_cell.dart';
import 'package:pharmacy_pos/controllers/orders_controller.dart';
import 'package:pharmacy_pos/controllers/orders_filter_controller.dart';
import 'package:pharmacy_pos/models/order_model.dart';
import 'package:pharmacy_pos/screens/orders_screen.dart';
import 'package:pharmacy_pos/utils/colors.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  String selectedFilter = "Current Month"; // Default filter
  int? selectedMonth;
  int? selectedYear;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedMonth = now.month;
    selectedYear = now.year;
    Get.put<OrderFilterController>(OrderFilterController())
        .setMonthAndYear(selectedMonth!, selectedYear!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Filter Options
          Container(
            color: MyColors.greenColor,
            height: MediaQuery.of(context).size.height * 0.12,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sales',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      value: selectedFilter,
                      items: const [
                        DropdownMenuItem(
                            value: "Current Month",
                            child: Text("Current Month")),
                        DropdownMenuItem(
                            value: "Select Month & Year",
                            child: Text("Select Month & Year")),
                      ],
                      onChanged: (value) async {
                        setState(() {
                          selectedFilter = value!;
                        });
                        if (value == "Current Month") {
                          final now = DateTime.now();
                          setState(() {
                            selectedMonth = now.month;
                            selectedYear = now.year;
                          });
                          Get.find<OrderFilterController>()
                              .setMonthAndYear(selectedMonth!, selectedYear!);
                        } else if (value == "Select Month & Year") {
                          await _showMonthYearPicker(context);
                        }
                      },
                    ),
                    if (selectedMonth != null && selectedYear != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Selected: ${DateFormat('MMMM yyyy').format(DateTime(selectedYear!, selectedMonth!))}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Table Content
          Expanded(
            child: Obx(() {
              var ordersController =
                  Get.put<OrdersController>(OrdersController());
              var orderFilterController =
                  Get.put<OrderFilterController>(OrderFilterController());
              var filteredOrders = orderFilterController.filterOrdersByMonth(
                  ordersController.orders.reversed.toList());
              double totalProfit = filteredOrders.fold(
                  0.0,
                  (sum, order) =>
                      sum +
                      order.items.fold(
                          0.0,
                          (itemSum, item) =>
                              itemSum +
                              (item.profit * item.quantity) -
                              (order.discount / 100) * order.totalAmount));
              return Column(
                children: [
                  // Total Sale
                  Container(
                    color: MyColors.greenColor,
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
                          'Filter: $selectedFilter',
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
                      7: FlexColumnWidth(1),
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
                            child: Text('No Sales Found'),
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
                                    7: FlexColumnWidth(1),
                                  },
                                  children: [
                                    TableRow(
                                      children: [
                                        tableCell(order.id.toString()),
                                        tableCell(order.items.length.toString(),
                                            hasOrderViewAction: true,
                                            viewOrder: () {
                                          showOrderItemsDialog(
                                              context, order.items);
                                        }),
                                        tableCell(
                                            DateFormat('dd/M/yy, h:mm:ss a')
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
                                          hasOrderActions: true,
                                          viewOrder: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return ReceiptDialog(
                                                      order: order);
                                                });
                                          },
                                          deleteOrder: () {
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
                                                          Get.find<
                                                                  OrdersController>()
                                                              .deleteOrder(order
                                                                  .id
                                                                  .toString());
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

  Future<void> _showMonthYearPicker(BuildContext context) async {
    // Show a custom month & year picker
    final now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          DateTime(selectedYear ?? now.year, selectedMonth ?? now.month),
      firstDate: DateTime(2000), // Earliest available year
      lastDate: DateTime(now.year + 10), // Limit future years
    );

    if (pickedDate != null) {
      setState(() {
        selectedMonth = pickedDate.month;
        selectedYear = pickedDate.year;
        Get.find<OrderFilterController>()
            .setMonthAndYear(selectedMonth!, selectedYear!);
      });
    }
  }
}
