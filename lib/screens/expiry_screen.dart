import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/controllers/products_controller.dart';
import 'package:pharmacy_pos/models/product_model.dart';
import 'package:pharmacy_pos/utils/colors.dart';

class ExpiryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsController = Get.put(ProductsController());
    final expiredProducts = productsController.getExpiredProducts();
    final nearExpiryProducts = productsController.getNearExpiryProducts();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.greenColor,
          title: const Text(
            "Expiry Table",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Expired'),
              Tab(text: 'Near Expiry'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProductDataTable(
                products: expiredProducts, title: 'Expired Products'),
            ProductDataTable(
                products: nearExpiryProducts, title: 'Near Expiry Products'),
          ],
        ),
      ),
    );
  }
}

class ProductDataTable extends StatelessWidget {
  final List<ProductModel> products;
  final String title;

  ProductDataTable({required this.products, required this.title});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.resolveWith(
              (states) => Colors.blueGrey[100]),
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Company')),
            DataColumn(label: Text('Batch')),
            DataColumn(label: Text('Available Units')),
            DataColumn(label: Text('Available Packs')),
            DataColumn(label: Text('Unit Price')),
            DataColumn(label: Text('Expiry Date')),
          ],
          rows: products.map((product) {
            return DataRow(cells: [
              DataCell(Text(product.id)),
              DataCell(Text(product.name)),
              DataCell(Text(product.category)),
              DataCell(Text(product.company)),
              DataCell(Text(product.batchNumber)),
              DataCell(Text(product.availableUnits?.toString() ?? '0')),
              DataCell(Text(product.isSingleUnit
                  ? 'N/A'
                  : product.availablePacks?.toString() ?? '0')),
              DataCell(Text(product.unitPurchasePrice.toStringAsFixed(2))),
              DataCell(Text(
                product.expiryDate.toString().substring(0, 10), // YYYY-MM-DD
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
