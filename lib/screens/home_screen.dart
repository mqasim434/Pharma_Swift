import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/components/cart_item_widget.dart';
import 'package:pharmacy_pos/components/receipt_dialogue.dart';
import 'package:pharmacy_pos/components/table_cell.dart';
import 'package:pharmacy_pos/controllers/current_order_controller.dart';
import 'package:pharmacy_pos/controllers/filter_controller.dart';
import 'package:pharmacy_pos/controllers/orders_controller.dart';
import 'package:pharmacy_pos/controllers/products_controller.dart';
import 'package:pharmacy_pos/models/order_model.dart';
import 'package:pharmacy_pos/models/product_model.dart';
import 'package:pharmacy_pos/utils/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FiltersController filtersController = Get.put(FiltersController());
    final ProductsController productsController = Get.put(ProductsController());
    final CurrentOrderController currentOrderController =
        Get.put(CurrentOrderController());

    final hoveredRow = ValueNotifier<int?>(null);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.greenColor,
        title: Row(
          children: [
            const Text(
              'Home',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
                onChanged: (value) {
                  if (value.isEmpty) {
                    filtersController.switchSearchingStatus(false);
                    filtersController.updateFilteredProducts(productsController
                        .productList); // Reset to all products
                  } else {
                    filtersController.switchSearchingStatus(true);
                    filtersController.searchProducts(
                        value, productsController.productList);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Obx(() {
                    if (filtersController.filteredProducts.isEmpty) {
                      return const Center(
                          child: Text('No Products Available'));
                    }
                    return Column(
                      children: [
                        // Fixed Header Row
                        Container(
                          color: MyColors
                              .greenColor, // Background color for header
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          color: Colors.white,
                                          width: 2.0), // Border on top
                                      right: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: tableCell('Name', isHeader: true),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          color: Colors.white,
                                          width: 2.0), // Border on top
                                      right: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child:
                                      tableCell('Formula', isHeader: true),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          color: Colors.white,
                                          width: 2.0), // Border on top
                                      right: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child:
                                      tableCell('Strength', isHeader: true),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          color: Colors.white,
                                          width: 2.0), // Border on top
                                      right: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child:
                                      tableCell('Category', isHeader: true),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          color: Colors.white,
                                          width: 2.0), // Border on top
                                      right: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child:
                                      tableCell('Company', isHeader: true),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          color: Colors.white,
                                          width: 2.0), // Border on top
                                      right: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: tableCell('Batch', isHeader: true),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          color: Colors.white,
                                          width: 2.0), // Border on top
                                      right: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child:
                                      tableCell('Balance', isHeader: true),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          color: Colors.white,
                                          width: 2.0), // Border on top
                                      right: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child:
                                      tableCell('P. Price', isHeader: true),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          color: Colors.white,
                                          width: 2.0), // Border on top
                                      right: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: tableCell('Sale Price',
                                      isHeader: true),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          color: Colors.white,
                                          width:
                                              2.0), // Border// Border on top
                                    ),
                                  ),
                                  child:
                                      tableCell('Expiry', isHeader: true),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: ValueListenableBuilder<int?>(
                              valueListenable: hoveredRow,
                              builder: (context, hoveredIndex, child) {
                                return Table(
                                  border:
                                      TableBorder.all(color: Colors.grey),
                                  columnWidths: const {
                                    0: FlexColumnWidth(2), // Name column
                                    1: FlexColumnWidth(2), // Formula column
                                    2: FlexColumnWidth(
                                        1), // Category column
                                    3: FlexColumnWidth(
                                        1), // Category column
                                    4: FlexColumnWidth(
                                        1), // Category column
                                    5: FlexColumnWidth(1), // Batch column
                                    6: FlexColumnWidth(1), // Balance column
                                    7: FlexColumnWidth(
                                        1), // Unit Retail Price column
                                    8: FlexColumnWidth(
                                        1), // Unit Sale Price column
                                    9: FlexColumnWidth(1), // Expiry column
                                  },
                                  children: List.generate(
                                    filtersController
                                        .filteredProducts.length,
                                    (index) {
                                      final product = filtersController
                                          .filteredProducts[index];
                                      return TableRow(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: hoveredIndex == index
                                                ? Colors.blue
                                                : Colors.grey,
                                            width: hoveredIndex == index
                                                ? 2.0
                                                : 1.0,
                                          ),
                                          color: hoveredIndex == index
                                              ? Colors.blue.withOpacity(0.1)
                                              : Colors
                                                  .transparent, // Optional background color
                                        ),
                                        children: [
                                          MouseRegion(
                                            onEnter: (_) =>
                                                hoveredRow.value = index,
                                            onExit: (_) =>
                                                hoveredRow.value = null,
                                            child: InkWell(
                                                onTap: () {
                                                  int available = product
                                                          .availableUnits ??
                                                      0;
                                                  if (available < 0) {
                                                    showOutOfStockDialogue(
                                                        context, product);
                                                  } else {
                                                    currentOrderController
                                                        .addItemToCart(
                                                            product);
                                                  }
                                                },
                                                child: tableCell(
                                                    product.name)),
                                          ),
                                          MouseRegion(
                                            onEnter: (_) =>
                                                hoveredRow.value = index,
                                            onExit: (_) =>
                                                hoveredRow.value = null,
                                            child: InkWell(
                                                onTap: () {
                                                  int available = product
                                                          .availableUnits ??
                                                      0;
                                                  if (available > 0) {
                                                    currentOrderController
                                                        .addItemToCart(
                                                            product);
                                                  } else {
                                                    showOutOfStockDialogue(
                                                        context, product);
                                                  }
                                                },
                                                child: tableCell(
                                                    product.formula ??
                                                        'N/A')),
                                          ),
                                          MouseRegion(
                                            onEnter: (_) =>
                                                hoveredRow.value = index,
                                            onExit: (_) =>
                                                hoveredRow.value = null,
                                            child: InkWell(
                                                onTap: () {
                                                  int available = product
                                                          .availableUnits ??
                                                      0;
                                                  if (available > 0) {
                                                    currentOrderController
                                                        .addItemToCart(
                                                            product);
                                                  } else {
                                                    showOutOfStockDialogue(
                                                        context, product);
                                                  }
                                                },
                                                child: tableCell(product
                                                    .strength
                                                    .toString())),
                                          ),
                                          MouseRegion(
                                            onEnter: (_) =>
                                                hoveredRow.value = index,
                                            onExit: (_) =>
                                                hoveredRow.value = null,
                                            child: InkWell(
                                                onTap: () {
                                                  int available = product
                                                          .availableUnits ??
                                                      0;
                                                  if (available > 0) {
                                                    currentOrderController
                                                        .addItemToCart(
                                                            product);
                                                  } else {
                                                    showOutOfStockDialogue(
                                                        context, product);
                                                  }
                                                },
                                                child: tableCell(
                                                    product.category)),
                                          ),
                                          MouseRegion(
                                            onEnter: (_) =>
                                                hoveredRow.value = index,
                                            onExit: (_) =>
                                                hoveredRow.value = null,
                                            child: InkWell(
                                                onTap: () {
                                                  int available = product
                                                          .availableUnits ??
                                                      0;
                                                  if (available > 0) {
                                                    currentOrderController
                                                        .addItemToCart(
                                                            product);
                                                  } else {
                                                    showOutOfStockDialogue(
                                                        context, product);
                                                  }
                                                },
                                                child: tableCell(
                                                    product.company)),
                                          ),
                                          MouseRegion(
                                            onEnter: (_) =>
                                                hoveredRow.value = index,
                                            onExit: (_) =>
                                                hoveredRow.value = null,
                                            child: InkWell(
                                                onTap: () {
                                                  int available = product
                                                          .availableUnits ??
                                                      0;
                                                  if (available > 0) {
                                                    currentOrderController
                                                        .addItemToCart(
                                                            product);
                                                  } else {
                                                    showOutOfStockDialogue(
                                                        context, product);
                                                  }
                                                },
                                                child: tableCell(
                                                    product.batchNumber)),
                                          ),
                                          MouseRegion(
                                            onEnter: (_) =>
                                                hoveredRow.value = index,
                                            onExit: (_) =>
                                                hoveredRow.value = null,
                                            child: InkWell(
                                              onTap: () {
                                                int available = product
                                                        .availableUnits ??
                                                    0;
                                                if (available > 0) {
                                                  currentOrderController
                                                      .addItemToCart(
                                                          product);
                                                } else {
                                                  showOutOfStockDialogue(
                                                      context, product);
                                                }
                                              },
                                              child: tableCell(product
                                                  .availableUnits
                                                  .toString()),
                                            ),
                                          ),
                                          MouseRegion(
                                            onEnter: (_) =>
                                                hoveredRow.value = index,
                                            onExit: (_) =>
                                                hoveredRow.value = null,
                                            child: InkWell(
                                              onTap: () {
                                                int available = product
                                                        .availableUnits ??
                                                    0;
                                                if (available > 0) {
                                                  currentOrderController
                                                      .addItemToCart(
                                                          product);
                                                } else {
                                                  showOutOfStockDialogue(
                                                      context, product);
                                                }
                                              },
                                              child: tableCell(product
                                                  .unitPurchasePrice
                                                  .toStringAsFixed(2)),
                                            ),
                                          ),
                                          MouseRegion(
                                            onEnter: (_) =>
                                                hoveredRow.value = index,
                                            onExit: (_) =>
                                                hoveredRow.value = null,
                                            child: InkWell(
                                              onTap: () {
                                                int available = product
                                                        .availableUnits ??
                                                    0;
                                                if (available > 0) {
                                                  currentOrderController
                                                      .addItemToCart(
                                                          product);
                                                } else {
                                                  showOutOfStockDialogue(
                                                      context, product);
                                                }
                                              },
                                              child: tableCell(product
                                                          .unitSalePrice ==
                                                      null
                                                  ? '0.0'
                                                  : product.unitSalePrice!
                                                      .toDouble()
                                                      .toStringAsFixed(2)),
                                            ),
                                          ),
                                          MouseRegion(
                                            onEnter: (_) =>
                                                hoveredRow.value = index,
                                            onExit: (_) =>
                                                hoveredRow.value = null,
                                            child: InkWell(
                                              onTap: () {
                                                int available = product
                                                        .availableUnits ??
                                                    0;
                                                if (available > 0) {
                                                  currentOrderController
                                                      .addItemToCart(
                                                          product);
                                                } else {
                                                  showOutOfStockDialogue(
                                                      context, product);
                                                }
                                              },
                                              child: tableCell(
                                                  product.expiryDate),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                const CurrentOrderWidget(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> showOutOfStockDialogue(
      BuildContext context, ProductModel product) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('${product.name} is out of stock!'),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: MyColors.greenColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Ok',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          );
        });
  }
}

class CurrentOrderWidget extends StatelessWidget {
  const CurrentOrderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentOrderController = Get.put(CurrentOrderController());
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Current Order',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              flex: 10,
              child: Container(
                  padding: const EdgeInsets.only(top: 8),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Obx(
                    () => currentOrderController.orderItems.isEmpty
                        ? const Center(
                            child: Text('No Items Yet'),
                          )
                        : ListView.builder(
                            itemCount: currentOrderController.orderItems.length,
                            itemBuilder: ((context, index) {
                              OrderItem orderItem =
                                  currentOrderController.orderItems[index];
                              return CartItemWidget(
                                id: orderItem.productId,
                                itemName: orderItem.name,
                                price: orderItem.salePrice,
                                quantity: orderItem.quantity,
                                onRemove: () {
                                  currentOrderController.removeItemFromCart(
                                    orderItem,
                                  );
                                },
                                onQuantityChanged: (val) {
                                  currentOrderController.updateQuantity(
                                    orderItem.productId,
                                    val,
                                  );
                                },
                              );
                            }),
                          ),
                  )),
            ),
            const SizedBox(
              height: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Obx(
                  () => Text(
                    'Total Items: ${currentOrderController.orderItems.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Obx(
                  () => Text(
                    'Total Amount: ${currentOrderController.currentOrder.value.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Discount: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      width: 150,
                      child: TextField(
                        controller: currentOrderController.discountController,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                          hintText: 'Enter Discount',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            try {
                              double discount = double.parse(value);
                              currentOrderController.setDiscount(discount);
                            } catch (e) {
                              // Handle parsing error if needed
                              print('Error parsing discount: $e');
                            }
                          } else {
                            currentOrderController.setDiscount(0.0);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Obx(
                  () => Text(
                    'Net Amount: ${currentOrderController.currentOrder.value.netAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (currentOrderController.orderItems.isNotEmpty) {
                      final ordersController = Get.put(OrdersController());
                      currentOrderController.updateTotals();
                      currentOrderController.currentOrder.update((order) {
                        order?.items =
                            currentOrderController.orderItems.toList();
                      });
                      ordersController
                          .addOrder(currentOrderController.currentOrder.value);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ReceiptDialog(
                              order: currentOrderController.currentOrder.value);
                        },
                      ).then((_) {
                        currentOrderController.clearOrder();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: MyColors.greenColor,
                  ),
                  child: const Text(
                    'Add Order',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
