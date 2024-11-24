import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/components/add_product_dialogue.dart';
import 'package:pharmacy_pos/controllers/products_controller.dart';
import 'package:pharmacy_pos/utils/colors.dart';

class FloatingActionButtons extends StatefulWidget {
  const FloatingActionButtons({super.key});

  @override
  State<FloatingActionButtons> createState() => _FloatingActionButtonsState();
}

class _FloatingActionButtonsState extends State<FloatingActionButtons> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    var productsController = Get.put<ProductsController>(ProductsController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: screenWidth * 0.1,
          child: FloatingActionButton(
            backgroundColor: MyColors.greenColor,
            onPressed: () {
              productsController.clearFields();
              showDialog(
                  context: context,
                  builder: (context) {
                    return const AddProductDialogue();
                  });
            },
            child: const Row(
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
        const SizedBox(
          width: 10,
        ),
        // SizedBox(
        //   width: screenWidth * 0.1,
        //   child: FloatingActionButton(
        //     onPressed: () async {
        //       FilePickerResult? result = await FilePicker.platform.pickFiles();

        //       if (result == null) {
        //         // No file selected
        //         return;
        //       } else {
        //         EasyLoading.show(status: 'Adding Products');
        //         final file = File(result.files.single.path!);
        //         final csvString = await file.readAsString();

        //         // Convert CSV string to a list of rows
        //         List<List<dynamic>> rows = const CsvToListConverter()
        //             .convert(csvString, eol: '\n', fieldDelimiter: ',');

        //         // Check if the CSV file has a header row
        //         bool hasHeader = rows.first[0] is String;

        //         // Parse each row and add to Hive
        //         for (int i = hasHeader ? 1 : 0; i < rows.length; i++) {
        //           var row = rows[i];

        //           try {
        //             // Ensure each element exists in the row to avoid null operator issues
        //             String name = row.length > 0 && row[0] != null
        //                 ? row[0].toString()
        //                 : '';
        //             String category = row.length > 1 && row[1] != null
        //                 ? row[1].toString()
        //                 : '';
        //             String formula = row.length > 2 && row[2] != null
        //                 ? row[2].toString()
        //                 : '';
        //             String? strength = row.length > 3 &&
        //                     row[3] != null &&
        //                     row[3].toString().isNotEmpty
        //                 ? (row[3].toString())
        //                 : '';
        //             String company = row.length > 4 && row[4] != null
        //                 ? row[4].toString()
        //                 : '';
        //             String batchNumber = row.length > 5 && row[5] != null
        //                 ? row[5].toString()
        //                 : '';
        //             String barcode = row.length > 6 && row[6] != null
        //                 ? row[6].toString()
        //                 : '';
        //             int? availableUnits = row.length > 7 && row[7] != null
        //                 ? int.tryParse(row[7].toString())
        //                 : null;
        //             double unitRetailPrice = row.length > 8 && row[8] != null
        //                 ? double.tryParse(row[8].toString()) ?? 0.0
        //                 : 0.0;
        //             double unitSalePrice = row.length > 9 && row[9] != null
        //                 ? double.tryParse(row[9].toString()) ?? 0.0
        //                 : 0.0;
        //             int? unitsInPack = row.length > 10 && row[10] != null
        //                 ? int.tryParse(row[10].toString())
        //                 : null;
        //             double? packRetailPrice = row.length > 11 &&
        //                     row[11] != null &&
        //                     row[11].toString().isNotEmpty
        //                 ? double.tryParse(row[11].toString())
        //                 : null;
        //             double? packSalePrice = row.length > 12 &&
        //                     row[12] != null &&
        //                     row[12].toString().isNotEmpty
        //                 ? double.tryParse(row[12].toString())
        //                 : null;
        //             int? availablePacks = row.length > 13 && row[13] != null
        //                 ? int.tryParse(row[13].toString())
        //                 : null;
        //             DateTime? expiryDate = row.length > 14 && row[14] != null
        //                 ? DateFormat('d/M/yyyy H:m').parse(row[14].toString())
        //                 : null;
        //             bool isSingleUnit = row.length > 15 && row[15] != null
        //                 ? row[15].toString().toLowerCase() == 'true'
        //                 : false;

        //             final product = ProductModel(
        //               name: name,
        //               category: category,
        //               formula: formula,
        //               strength: strength,
        //               company: company,
        //               batchNumber: batchNumber,
        //               barcode: barcode,
        //               availableUnits: availableUnits,
        //               unitRetailPrice: unitRetailPrice,
        //               unitSalePrice: unitSalePrice,
        //               unitsInPack: unitsInPack,
        //               packRetailPrice: packRetailPrice,
        //               packSalePrice: packSalePrice,
        //               availablePacks: availablePacks,
        //               expiryDate: DateFormat('dd/MM/yyyy')
        //                   .format(expiryDate as DateTime),
        //               isSingleUnit: isSingleUnit,
        //             );

        //             // Add product to the database
        //             await productsController.addProduct(productModel: product);
        //           } catch (e) {
        //             print("Error processing row $i: $e");
        //           } finally {
        //             EasyLoading.dismiss();
        //           }
        //         }
        //       }
        //     },
        //     child: const Icon(Icons.add),
        //   ),
        // ),
        // const SizedBox(
        //   width: 10,
        // ),
        // SizedBox(
        //   width: 200,
        //   child: FloatingActionButton(
        //     backgroundColor: Colors.red,
        //     onPressed: () {
        //       showDialog(
        //           context: context,
        //           builder: (context) {
        //             return AlertDialog(
        //               title: const Text('Are you Sure to Delet All Products?'),
        //               actions: [
        //                 TextButton(
        //                     onPressed: () {
        //                       Navigator.pop(context);
        //                     },
        //                     child: const Text('No')),
        //                 TextButton(
        //                     onPressed: () {
        //                       productsController.deleteAllProducts();
        //                       Navigator.pop(context);
        //                     },
        //                     child: const Text('Yes')),
        //               ],
        //             );
        //           });
        //     },
        //     child: const Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Icon(Icons.delete_forever, color: Colors.white),
        //         SizedBox(width: 8),
        //         Text(
        //           'Delete All Products',
        //           style: TextStyle(
        //             color: Colors.white,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // )
      ],
    );
  }
}
