// ignore_for_file: prefer_const_constructors

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/components/table_cell.dart';
import 'package:pharmacy_pos/components/update_product_dialogue.dart';
import 'package:pharmacy_pos/components/view_product_dialogue.dart';
import 'package:pharmacy_pos/controllers/products_controller.dart';
import 'package:pharmacy_pos/models/product_model.dart';
import 'package:pharmacy_pos/utils/colors.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  void saveProductsAsPdf(List<ProductModel> productList) async {
    final pdf = pw.Document();

    // Add content to the PDF
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text(
              "Product List",
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FlexColumnWidth(3), // Product Name
                1: pw.FlexColumnWidth(2), // Formula
                2: pw.FlexColumnWidth(2), // Category
                3: pw.FlexColumnWidth(3), // Company
                4: pw.FlexColumnWidth(2), // Retail Price
                5: pw.FlexColumnWidth(2), // Sale Price
              },
              children: [
                // Header row
                pw.TableRow(
                  children: [
                    pw.Text("Product Name",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Formula",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Category",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Company",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Available Units",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Purchase Price",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Sale Price",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                // Product rows
                ...productList.map((product) {
                  return pw.TableRow(
                    children: [
                      pw.Text(product.name),
                      pw.Text(product.formula ?? "N/A"),
                      pw.Text(product.category),
                      pw.Text(product.company),
                      pw.Text(product.availableUnits.toString()),
                      pw.Text(product.unitPurchasePrice.toString()),
                      pw.Text(product.unitSalePrice?.toString() ?? "N/A"),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        );
      },
    ));
    // Let the user pick the destination folder\
    String? selectedDirectory = 'NAN';
    selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      // Save the PDF to the selected folder
      final file = File("$selectedDirectory/product_list.pdf");
      await file.writeAsBytes(await pdf.save());

      // Notify the user
      Get.snackbar(
          "PDF Saved", "File saved at ${selectedDirectory}/product_list.pdf");
    } else {
      // Notify the user if no folder was selected
      Get.snackbar("Save Cancelled", "No destination folder selected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsController = Get.put(ProductsController());
    List<ProductModel> filteredProducts =
        productsController.aggregateProductQuantities();

    List<ProductModel> lowStockProducts = filteredProducts.where((product) {
      if (product.isSingleUnit) {
        return product.availableUnits! <= 5;
      } else {
        return product.availablePacks! <= 2;
      }
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Low Stock Alerts",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf, color: Colors.black),
            onPressed: () {
              saveProductsAsPdf(lowStockProducts);
            },
          ),
        ],
        backgroundColor: MyColors.greenColor,
      ),
      body: Column(
        children: [
          // Header row
          Container(
            color: MyColors.greenColor,
            child: Table(
              border: TableBorder.all(color: Colors.white),
              columnWidths: const {
                0: FlexColumnWidth(2), // Product Name
                1: FlexColumnWidth(2), // Formula
                2: FlexColumnWidth(1), // Category
                3: FlexColumnWidth(1), // Category
                4: FlexColumnWidth(1), // Category
                5: FlexColumnWidth(1), // Category
                6: FlexColumnWidth(1), // Available Units
                7: FlexColumnWidth(1), // Available Packs
                8: FlexColumnWidth(1), // Reorder Level
              },
              children: [
                TableRow(
                  children: [
                    tableCell('Product Name', isHeader: true),
                    tableCell('Formula', isHeader: true),
                    tableCell('Category', isHeader: true),
                    tableCell('Company', isHeader: true),
                    tableCell('Balance', isHeader: true),
                    tableCell('Packs', isHeader: true),
                    tableCell('Expiry', isHeader: true),
                    tableCell('Actions', isHeader: true),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: lowStockProducts.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.4),
                      child: Text('No Out of Stock Products'),
                    )
                  : Table(
                      border: TableBorder.all(color: Colors.grey),
                      columnWidths: const {
                        0: FlexColumnWidth(2), // Product Name
                        1: FlexColumnWidth(2), // Product Category
                        2: FlexColumnWidth(1), // Formula
                        3: FlexColumnWidth(1), // Formula
                        4: FlexColumnWidth(1), // Formula
                        5: FlexColumnWidth(1), // Available Stock
                        6: FlexColumnWidth(1), // Available Stock
                        7: FlexColumnWidth(1), // Actions
                      },
                      children: lowStockProducts.map((product) {
                        return TableRow(
                          children: [
                            tableCell(product.name),
                            tableCell(product.formula ?? 'N/A'),
                            tableCell(product.category ?? 'N/A'),
                            tableCell(product.company ?? 'N/A'),
                            tableCell(product.availableUnits.toString()),
                            tableCell(product.isSingleUnit
                                ? 'N/A'
                                : '${product.availablePacks.toString()} Packs'),
                            tableCell(product.expiryDate),
                            tableCell(
                              '',
                              hasProductActions: true,
                              viewProduct: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ViewProductDialogue(
                                          product: product);
                                    });
                              },
                              editProduct: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return UpdateProductDialogue(
                                          product: product);
                                    });
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
                                              productsController.deleteProduct(
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
            ),
          ),
        ],
      ),
    );
  }
}
