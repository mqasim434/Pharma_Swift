import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/components/floating_action_buttons.dart';
import 'package:pharmacy_pos/components/update_product_dialogue.dart';
import 'package:pharmacy_pos/components/view_product_dialogue.dart';
import 'package:pharmacy_pos/controllers/filter_controller.dart';
import 'package:pharmacy_pos/controllers/products_controller.dart';
import 'package:pharmacy_pos/components/table_cell.dart';
import 'package:pharmacy_pos/utils/colors.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final productsController =
        Get.put<ProductsController>(ProductsController());
    final FiltersController filtersController = Get.put(FiltersController());

    return Scaffold(
      body: Column(
        children: [
          // Header Section
          Container(
            color: MyColors.greenColor,
            height: MediaQuery.of(context).size.height * 0.09,
            child: Center(
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Products',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
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
                        if (value.isEmpty) {
                          filtersController.switchSearchingStatus(false);
                          filtersController.updateFilteredProducts(
                              productsController.productList);
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
          ),
          // Table Section
          Expanded(
            child: Column(
              children: [
                // Fixed Table Header
                Container(
                  color: MyColors.greenColor,
                  child: Table(
                    border: TableBorder.all(color: Colors.white),
                    columnWidths: const {
                      0: FlexColumnWidth(2), // Name column
                      1: FlexColumnWidth(2), // Formula column
                      2: FlexColumnWidth(1), // Category column
                      3: FlexColumnWidth(1), // Batch column
                      4: FlexColumnWidth(1), // Balance column
                      5: FlexColumnWidth(1), // Balance column
                      6: FlexColumnWidth(1), // Balance column
                      7: FlexColumnWidth(1), // Retail Price column
                      8: FlexColumnWidth(1), // Expiry column
                      9: FlexColumnWidth(1), // Actions Price column
                    },
                    children: [
                      TableRow(
                        children: [
                          tableCell('Name', isHeader: true),
                          tableCell('Formula', isHeader: true),
                          tableCell('Category', isHeader: true),
                          tableCell('Company', isHeader: true),
                          tableCell('Batch', isHeader: true),
                          tableCell('Balance', isHeader: true),
                          tableCell('Packs', isHeader: true),
                          tableCell('Unit Price', isHeader: true),
                          tableCell('Expiry', isHeader: true),
                          tableCell('Actions', isHeader: true),
                        ],
                      ),
                    ],
                  ),
                ),
                // Scrollable Table Rows
                Expanded(
                  child: Obx(() {
                    if (filtersController.filteredProducts.isEmpty) {
                      return const Center(
                        child: Text('No Products Yet'),
                      );
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Table(
                        border: TableBorder.all(color: Colors.grey),
                        columnWidths: const {
                          0: FlexColumnWidth(2), // Name column
                          1: FlexColumnWidth(2), // Formula column
                          2: FlexColumnWidth(1), // Category column
                          3: FlexColumnWidth(1), // Batch column
                          4: FlexColumnWidth(1), // Batch column
                          5: FlexColumnWidth(1), // Balance column
                          6: FlexColumnWidth(1), // Balance column
                          7: FlexColumnWidth(1), // Retail Price column
                          8: FlexColumnWidth(1), // Expiry column
                          9: FlexColumnWidth(1), // Actions Price column
                        },
                        children:
                            filtersController.filteredProducts.map((product) {
                          return TableRow(
                            children: [
                              tableCell(product.name),
                              tableCell(product.formula ?? 'N/A'),
                              tableCell(product.category ?? 'N/A'),
                              tableCell(product.company ?? 'N/A'),
                              tableCell(product.batchNumber ?? 'N/A'),
                              tableCell(product.availableUnits.toString()),
                              tableCell((product.availablePacks == null ||
                                      product.availablePacks == 0)
                                  ? 'N/A'
                                  : product.availablePacks.toString()),
                              tableCell(product.unitSalePrice == null
                                  ? '0.0'
                                  : product.unitSalePrice!
                                      .toDouble()
                                      .toStringAsFixed(2)),
                              tableCell(product.expiryDate),
                              tableCell(
                                'Actions',
                                hasProductActions: true,
                                viewProduct: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ViewProductDialogue(
                                        product: product,
                                      );
                                    },
                                  );
                                },
                                editProduct: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return UpdateProductDialogue(
                                        product: product,
                                      );
                                    },
                                  );
                                },
                                deleteProduct: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                            'Are you sure to delete ${product.name}'),
                                        actions: [
                                          TextButton(
                                              style: TextButton.styleFrom(
                                                  backgroundColor: Colors.red),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'No',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                          TextButton(
                                              style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      MyColors.greenColor),
                                              onPressed: () {
                                                productsController
                                                    .deleteProduct(
                                                        product.id.toString());
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Yes',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const FloatingActionButtons(),
    );
  }
}
