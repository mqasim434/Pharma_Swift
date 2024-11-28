import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/components/add_purchase_dialogue.dart';
import 'package:pharmacy_pos/components/table_cell.dart';
import 'package:pharmacy_pos/components/update_purchase_dialogue.dart';
import 'package:pharmacy_pos/components/view_purchase_dialogue.dart';
import 'package:pharmacy_pos/controllers/filter_controller.dart';
import 'package:pharmacy_pos/controllers/products_controller.dart';
import 'package:pharmacy_pos/controllers/purchases_filter_controller.dart';
import 'package:pharmacy_pos/utils/colors.dart';

import '../controllers/purchase_controller.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  String selectedFilter = "Current Month"; // Default filter
  int? selectedMonth;
  int? selectedYear;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedMonth = now.month;
    selectedYear = now.year;
    Get.put<PurchasesFilterController>(PurchasesFilterController())
        .setMonthAndYear(selectedMonth!, selectedYear!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.greenColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const Text(
                  'Purchases',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (selectedFilter == 'All Purchases') {
                      Get.find<PurchasesFilterController>().showAllPurchases();
                    } else if (selectedFilter == 'Current Month') {
                      Get.find<PurchasesFilterController>().setMonthAndYear(
                          DateTime.now().month, DateTime.now().year);
                    } else {
                      Get.find<PurchasesFilterController>()
                          .setMonthAndYear(selectedMonth!, selectedYear!);
                    }
                  },
                  icon: const Icon(
                    Icons.restore,
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.215,
                  height: 40,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search by id/name/category/company...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    onChanged: (value) {
                      Get.find<PurchasesFilterController>()
                          .searchPurchases(value);
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
                    DropdownMenuItem(
                        value: "Current Month", child: Text("Current Month")),
                    DropdownMenuItem(
                        value: "Select Month & Year",
                        child: Text("Select Month & Year")),
                    DropdownMenuItem(
                        value: "All Purchases", child: Text("All Purchases")),
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
                      Get.find<PurchasesFilterController>()
                          .setMonthAndYear(selectedMonth!, selectedYear!);
                    } else if (value == "Select Month & Year") {
                      await _showMonthYearPicker(context);
                    } else if (value == "All Purchases") {
                      Get.find<PurchasesFilterController>().showAllPurchases();
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Content
          Expanded(
            child: Obx(() {
              var purchasesController =
                  Get.put<PurchaseController>(PurchaseController());

              var filterController = Get.put<PurchasesFilterController>(
                  PurchasesFilterController());

              var filteredPurchases =
                  filterController.isSearching.value
                      ? filterController.searchResults
                      : filterController.filteredPurchases;
              double totalPurchases = filteredPurchases.fold(
                0.0,
                (sum, purchase) {
                  if (purchase.isSingleUnit) {
                    return sum +
                        (purchase.unitPurchasePrice! *
                            purchase.availableUnits!);
                  } else {
                    return sum +
                        (purchase.packPurchasePrice! *
                            purchase.availablePacks!);
                  }
                },
              );

              return Column(
                children: [
                  // Total Purchases
                  Container(
                    color: MyColors.darkGreyColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Purchases: ${totalPurchases.toStringAsFixed(2)}',
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
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(1),
                      5: FlexColumnWidth(1),
                      6: FlexColumnWidth(1),
                      7: FlexColumnWidth(1),
                      8: FlexColumnWidth(1),
                      9: FlexColumnWidth(1),
                      10: FlexColumnWidth(1),
                      11: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration:
                            const BoxDecoration(color: MyColors.greenColor),
                        children: [
                          tableCell('Purchase ID', isHeader: true),
                          tableCell('Product Name', isHeader: true),
                          tableCell('Category', isHeader: true),
                          tableCell('Company', isHeader: true),
                          tableCell('Batch No', isHeader: true),
                          tableCell('Purchase Packs/Units', isHeader: true),
                          tableCell('Pack/Unit Purchase Price', isHeader: true),
                          tableCell('Total Purchase Price', isHeader: true),
                          tableCell('Expiry Date', isHeader: true),
                          tableCell('Purchase Date', isHeader: true),
                          tableCell('Actions', isHeader: true),
                        ],
                      ),
                    ],
                  ),
                  // Table Rows
                  Expanded(
                    child: filteredPurchases.isEmpty
                        ? const Center(
                            child: Text('No Purchases Found'),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children:
                                  filteredPurchases.reversed.map((purchase) {
                                return Table(
                                  border: TableBorder.all(color: Colors.grey),
                                  columnWidths: const {
                                    0: FlexColumnWidth(1),
                                    1: FlexColumnWidth(2),
                                    2: FlexColumnWidth(1),
                                    3: FlexColumnWidth(1),
                                    4: FlexColumnWidth(1),
                                    5: FlexColumnWidth(1),
                                    6: FlexColumnWidth(1),
                                    7: FlexColumnWidth(1),
                                    8: FlexColumnWidth(1),
                                    9: FlexColumnWidth(1),
                                    10: FlexColumnWidth(1),
                                    11: FlexColumnWidth(1),
                                  },
                                  children: [
                                    TableRow(
                                      children: [
                                        tableCell(purchase.purchaseId),
                                        tableCell(
                                            purchase.productTitle.toString()),
                                        tableCell(purchase.category.toString()),
                                        tableCell(purchase.company.toString()),
                                        tableCell(
                                            purchase.batchNumber.toString()),
                                        tableCell(purchase.availablePacks
                                                        .toString() ==
                                                    '0' ||
                                                purchase.availablePacks
                                                        .toString() ==
                                                    '0.0'
                                            ? purchase.availableUnits.toString()
                                            : purchase.availablePacks
                                                .toString()),
                                        tableCell(purchase.isSingleUnit
                                            ? (purchase.unitPurchasePrice)
                                                .toString()
                                            : (purchase.packPurchasePrice)
                                                .toString()),
                                        tableCell(purchase.isSingleUnit
                                            ? (purchase.unitPurchasePrice!
                                                        .toDouble() *
                                                    purchase.availableUnits!
                                                        .toInt())
                                                .toStringAsFixed(2)
                                            : (purchase.packPurchasePrice!
                                                        .toDouble() *
                                                    purchase.availablePacks!
                                                        .toInt())
                                                .toStringAsFixed(2)),
                                        tableCell(
                                            purchase.expiryDate.toString()),
                                        tableCell(
                                            purchase.purchaseDate.toString()),
                                        tableCell(
                                          'Actions',
                                          hasProductActions: true,
                                          viewProduct: () {
                                            showDialog(
                                                context: context,
                                                builder: (value) {
                                                  return ViewPurchaseDialogue(
                                                    purchaseModel: purchase,
                                                  );
                                                });
                                          },
                                          editProduct: () {
                                            showDialog(
                                                context: context,
                                                builder: (value) {
                                                  return UpdatePurchaseDialogue(
                                                    purchaseModel: purchase,
                                                  );
                                                }).then((value) {
                                              if (selectedFilter ==
                                                  'All Purchases') {
                                                Get.find<
                                                        PurchasesFilterController>()
                                                    .showAllPurchases();
                                              } else if (selectedFilter ==
                                                  'Select Month & Year') {
                                                Get.find<
                                                        PurchasesFilterController>()
                                                    .setMonthAndYear(
                                                        selectedMonth!,
                                                        selectedYear!);
                                              } else {
                                                Get.find<
                                                        PurchasesFilterController>()
                                                    .setMonthAndYear(
                                                        DateTime.now().month,
                                                        DateTime.now().year);
                                              }
                                            });
                                          },
                                          deleteProduct: () {
                                            showDialog(
                                              context: context,
                                              builder:
                                                  ((context) => AlertDialog(
                                                        title: Text(
                                                            'Are you sure to delete purchase(${purchase.purchaseId})?'),
                                                        actions: [
                                                          TextButton(
                                                            style: TextButton.styleFrom(
                                                                backgroundColor:
                                                                    MyColors
                                                                        .greenColor),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                              'No',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            style: TextButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red),
                                                            onPressed: () {
                                                              purchasesController
                                                                  .deletePurchaseById(
                                                                      purchase
                                                                          .purchaseId);
                                                              if (selectedFilter ==
                                                                  'All Purchases') {
                                                                Get.find<
                                                                        PurchasesFilterController>()
                                                                    .showAllPurchases();
                                                              } else if (selectedFilter ==
                                                                  'Select Month & Year') {
                                                                Get.find<
                                                                        PurchasesFilterController>()
                                                                    .setMonthAndYear(
                                                                        selectedMonth!,
                                                                        selectedYear!);
                                                              } else {
                                                                Get.find<PurchasesFilterController>().setMonthAndYear(
                                                                    DateTime.now()
                                                                        .month,
                                                                    DateTime.now()
                                                                        .year);
                                                              }
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                              'Yes',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.greenColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Select Product'),
                  IconButton(
                      onPressed: () {
                        Get.find<FiltersController>().updateFilteredProducts(
                            Get.find<ProductsController>().productList);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
              content: SizedBox(
                height: 400, // Adjust the height as needed
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'Search a Product'),
                      onChanged: (value) {
                        Get.find<FiltersController>().searchProducts(
                            value, Get.find<ProductsController>().productList);
                      },
                    ),
                    Expanded(
                      child: Obx(() {
                        return ListView.builder(
                          itemCount: Get.find<FiltersController>()
                              .filteredProducts
                              .length,
                          itemBuilder: (context, index) {
                            var product = Get.find<FiltersController>()
                                .filteredProducts[index];
                            return ListTile(
                              title: Text(
                                '${product.name} (${product.category}) (${product.strength}) (${product.formula})',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  'Company: ${product.company}     Batch: ${product.batchNumber}'),
                              onTap: () {
                                Get.find<PurchaseController>()
                                    .selectedProduct
                                    .value = product.name;
                                Get.find<PurchaseController>()
                                    .fillProductDetails(product);
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: ((context) =>
                                        const AddPurchaseDialogue()));
                                if (selectedFilter == 'All Purchases') {
                                  Get.find<PurchasesFilterController>()
                                      .showAllPurchases();
                                } else if (selectedFilter ==
                                    'Select Month & Year') {
                                  Get.find<PurchasesFilterController>()
                                      .setMonthAndYear(
                                          selectedMonth!, selectedYear!);
                                  setState(() {});
                                } else {
                                  Get.find<PurchasesFilterController>()
                                      .setMonthAndYear(DateTime.now().month,
                                          DateTime.now().year);
                                  setState(() {});
                                }
                              },
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
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
      selectedMonth = pickedDate.month;
      selectedYear = pickedDate.year;
      Get.find<PurchasesFilterController>()
          .setMonthAndYear(selectedMonth!, selectedYear!);
    }
  }
}
