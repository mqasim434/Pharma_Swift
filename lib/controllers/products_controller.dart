import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/database/products_db_helper.dart';
import 'package:pharmacy_pos/models/product_model.dart';

class ProductsController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController formulaController = TextEditingController();
  final TextEditingController strengthController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController batchNumberController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController unitPurchasePriceController =
      TextEditingController();
  final TextEditingController unitSalePriceController = TextEditingController();
  final TextEditingController packPurchasePriceController =
      TextEditingController();
  final TextEditingController packSalePriceController = TextEditingController();
  final TextEditingController availableUnitsController =
      TextEditingController();
  final TextEditingController unitsInPackController = TextEditingController();
  final TextEditingController availablePacksController =
      TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController gstController = TextEditingController();
  final TextEditingController packPurchaseGSTIncludedController =
      TextEditingController();
  final TextEditingController marginController = TextEditingController();

  RxString selectedCategory = 'Tablets'.obs;
  String? expiryDate;
  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxBool isSingleUnit = false.obs;

  final formKey = GlobalKey<FormState>();

  ProductsDBHelper _productsDBHelper = ProductsDBHelper();


  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
  }

  Future<int> _getNextProductId() async {
    final idBox = await Hive.openBox('product_ids');
    int lastId = idBox.get('lastProductId', defaultValue: 0);
    int nextId = lastId + 1;
    await idBox.put('lastProductId', nextId);
    return nextId;

  }

  // Fetch all products
  Future<void> fetchAllProducts() async {
    productList.value = await _productsDBHelper.getAllProducts();
  }

  final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');

  List<ProductModel> getExpiredProducts() {
    final now = DateTime.now();
    return productList.where((product) {
      try {
        final expiryDate = dateFormatter.parse(product.expiryDate);
        return expiryDate.isBefore(now);
      } catch (e) {
        return false; // Skip invalid dates
      }
    }).toList();
  }

  Future<void> updateAvailableUnitsAndPacks({
    required String productId,
    required int updatedUnits,
  }) async {
    try {
      // Find the product by ID
      final product = productList.firstWhere((p) => p.id == productId);

      // Update available units
      product.availableUnits = updatedUnits;

      // Calculate available packs
      if (product.unitsInPack != null && product.unitsInPack! > 0) {
        product.availablePacks = (updatedUnits ~/ product.unitsInPack!);
      } else {
        product.availablePacks = 0; // Default to 0 if unitsInPack is invalid
      }

      // Update the product in the database
      await _productsDBHelper.updateProduct(productId, product);

      // Refresh the product list
      await fetchAllProducts();

      print('Product updated successfully');
    } catch (e) {
      print('Error updating available units and packs: $e');
    }
  }

  List<ProductModel> getNearExpiryProducts() {
    final now = DateTime.now();
    final threshold = now.add(Duration(days: 180));
    return productList.where((product) {
      try {
        final expiryDate = dateFormatter.parse(product.expiryDate);
        return expiryDate.isAfter(now) && expiryDate.isBefore(threshold);
      } catch (e) {
        return false; // Skip invalid dates
      }
    }).toList();
  }

  List<ProductModel> aggregateProductQuantities() {
    var groupedProducts = groupBy(productList, (product) => product.name);
    return groupedProducts.entries.map((entry) {
      var aggregatedProduct = entry.value.first;
      aggregatedProduct.availableUnits = entry.value
          .fold(0, (sum, product) => sum! + (product.availableUnits ?? 0));
      aggregatedProduct.availablePacks = entry.value
          .fold(0, (sum, product) => sum! + (product.availablePacks ?? 0));
      return aggregatedProduct;
    }).toList();
  }

  // Add a new product
  Future<void> addProduct({ProductModel? productModel}) async {
    if (productModel != null || formKey.currentState!.validate()) {
      final int newId = await _getNextProductId();

      final product = productModel ??
          ProductModel(
            id: newId.toString(), // Assign the next sequential ID from Hive
            name: nameController.text.isNotEmpty
                ? nameController.text
                : 'Unknown',
            category: selectedCategory.value,
            formula: formulaController.text.isNotEmpty
                ? formulaController.text
                : 'N/A',
            strength: strengthController.text,
            company: companyController.text.isNotEmpty
                ? companyController.text
                : 'N/A',
            batchNumber: batchNumberController.text.isNotEmpty
                ? batchNumberController.text
                : 'N/A',
            barcode: barcodeController.text.isNotEmpty
                ? barcodeController.text
                : 'N/A',
            isSingleUnit: isSingleUnit.value,
            gst: double.tryParse(gstController.text) ?? 0,
            margin: double.tryParse(marginController.text),
            unitPurchasePrice:
                double.tryParse(unitPurchasePriceController.text) ?? -1.0,
            unitSalePrice: double.tryParse(unitSalePriceController.text),
            unitsInPack: int.tryParse(unitsInPackController.text),
            packPurchasePrice:
                double.tryParse(packPurchasePriceController.text),
            packPurchaseGSTIncluded:
                double.tryParse(packPurchaseGSTIncludedController.text),
            packSalePrice: double.tryParse(packSalePriceController.text),
            availableUnits:
                double.tryParse(availableUnitsController.text)!.toInt(),
            availablePacks: int.tryParse(availablePacksController.text),
            expiryDate: expiryDateController.text,
          );

      try {
        await _productsDBHelper.addProduct(product).then((value) {
          clearFields();
        });
        await fetchAllProducts();
      } catch (e) {
        print("Error adding product to database: $e");
      } finally {
      }
    }
  }

  // Update an existing product
  void updateProduct(String id) async {
    final updatedProduct = ProductModel(
      id: id,
      name: nameController.text,
      category: selectedCategory.value,
      formula: formulaController.text,
      strength: strengthController.text,
      company: companyController.text,
      batchNumber: batchNumberController.text,
      barcode: barcodeController.text,
      isSingleUnit: isSingleUnit.value,
      packPurchaseGSTIncluded: double.tryParse(gstController.text) ?? 0.0,
      gst: double.tryParse(gstController.text) ?? 0.0,
      margin: double.tryParse(marginController.text) ?? 0.0,
      unitPurchasePrice:
          double.tryParse(unitPurchasePriceController.text) ?? 0.0,
      unitSalePrice: double.tryParse(unitSalePriceController.text) ?? 0.0,
      unitsInPack: isSingleUnit.value
          ? null
          : int.tryParse(unitsInPackController.text) ?? 0,
      packPurchasePrice: isSingleUnit.value
          ? null
          : double.tryParse(packPurchasePriceController.text) ?? 0.0,
      packSalePrice: isSingleUnit.value
          ? null
          : double.tryParse(packSalePriceController.text) ?? 0.0,
      availableUnits: double.tryParse(availableUnitsController.text)!.toInt(),
      availablePacks: isSingleUnit.value
          ? null
          : int.tryParse(availablePacksController.text) ?? 0,
      expiryDate: expiryDateController.text,
    );

    await _productsDBHelper.updateProduct(id, updatedProduct).then((value) {
      clearFields();
      fetchAllProducts();
    });
  }

  // Delete a product by ID
  void deleteProduct(String id) async {
    await _productsDBHelper.deleteProductById(id);
    await fetchAllProducts();
  }

  Future<void> deleteAllProducts() async {
    try {
      await _productsDBHelper.deleteAllProducts(); // Calling the repo method
      await fetchAllProducts();
    } catch (e) {
      print("Error in controller while deleting all products: $e");
    }
  }

  // Clear text fields
  void clearFields() {
    nameController.clear();
    categoryController.clear();
    formulaController.clear();
    strengthController.clear();
    companyController.clear();
    batchNumberController.clear();
    barcodeController.clear();
    unitPurchasePriceController.clear();
    unitSalePriceController.clear();
    gstController.clear();
    marginController.clear();
    packPurchasePriceController.clear();
    packSalePriceController.clear();
    availableUnitsController.clear();
    unitsInPackController.clear();
    availablePacksController.clear();
    packPurchaseGSTIncludedController.clear();
    expiryDateController.clear();
  }
}
