// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/components/add_product_dialogue.dart';
import 'package:pharmacy_pos/components/product_card.dart';
import 'package:pharmacy_pos/database/products_db_helper.dart';
import 'package:pharmacy_pos/models/product_model.dart';
import 'package:pharmacy_pos/utils/colors.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    Get.put<ProductsDBController>(ProductsDBController());
    var productsController = Get.find<ProductsDBController>();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 28.0, left: 28),
            child: Text(
              'Products',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: productsController.products.isEmpty
                ? Center(
                    child: Text('No Products Yet'),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: productsController.products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          productModel: productsController.products[index],
                          showActions: true,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: screenWidth * 0.1,
            child: FloatingActionButton(
              backgroundColor: MyColors.greenColor,
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) {
                    return AddProductDialogue();
                  }),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Add Product',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: screenWidth * 0.1,
            child: FloatingActionButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result == null) {
                  // No file selected
                  return;
                } else {
                  final file = File(result.files.single.path!);
                  final csvString = await file.readAsString();

                  // Convert CSV string to a list of rows
                  List<List<dynamic>> rows = const CsvToListConverter()
                      .convert(csvString, eol: '\n', fieldDelimiter: ',');

                  // Check if the CSV file has a header row
                  bool hasHeader = rows.first[0] is String;

                  // Parse each row and add to Hive
                  for (int i = hasHeader ? 1 : 0; i < rows.length; i++) {
                    var row = rows[i];

                    try {
                      final product = ProductModel(
                        name: row[0].toString(),
                        type: row[1].toString(),
                        formula: row[2].toString(),
                        vendor: row[3].toString(),
                        strength: row[4] != null && row[4].toString().isNotEmpty
                            ? double.tryParse(row[4].toString())
                            : null,
                        availableUnits: row[5] != null
                            ? int.tryParse(row[5].toString())
                            : null,
                        barcode: row[6]?.toString(),
                        blistersPerPack: row[7] != null
                            ? int.tryParse(row[7].toString())
                            : null,
                        unitsPerBlister: row[8] != null
                            ? int.tryParse(row[8].toString())
                            : null,
                        totalBlisters: row[9] != null
                            ? int.tryParse(row[9].toString())
                            : null,
                        totalPacks: row[10] != null
                            ? int.tryParse(row[10].toString())
                            : null,
                        quantity: row[11] != null
                            ? int.tryParse(row[11].toString())
                            : null,
                        expiryDate: DateTime.tryParse(row[12].toString()) ??
                            DateTime.now(), // Default if parsing fails
                        batchNumber: row[13].toString(),
                        rackNo: row[14].toString(),
                        isSingleUnit:
                            row[15].toString().toLowerCase() == 'true',
                        unitPrice: double.tryParse(row[16].toString()) ??
                            0.0, // Ensure it's parsed
                        pricePerBlister:
                            row[17] != null && row[17].toString().isNotEmpty
                                ? double.tryParse(row[17].toString())
                                : null,
                        pricePerPack:
                            row[18] != null && row[18].toString().isNotEmpty
                                ? double.tryParse(row[18].toString())
                                : null,
                        imageUrl: row.length > 19
                            ? row[19]?.toString()
                            : null, // Assuming CSV has image URL
                      );

                      // Add product to the database
                      productsController.addProduct(product);
                    } catch (e) {
                      print("Error processing row $i: $e");
                    }
                  }
                }
              },
              backgroundColor: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.file_copy, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Add CSV File',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 200,
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Are you Sure to Delet All Products?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No')),
                          TextButton(
                              onPressed: () {
                                productsController.deleteAllProducts();
                                Navigator.pop(context);
                              },
                              child: Text('Yes')),
                        ],
                      );
                    });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_forever, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Delete All Products',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
