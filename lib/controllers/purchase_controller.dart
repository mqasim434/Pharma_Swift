import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/models/product_model.dart';
import 'package:pharmacy_pos/models/purchase_model.dart';

class PurchaseController extends GetxController {
  var purchases = <PurchaseModel>[].obs;
  var filteredPurchases = <PurchaseModel>[].obs;
  var selectedProduct = ''.obs;
  var nameController = TextEditingController();
  var strengthController = TextEditingController();
  var formulaController = TextEditingController();
  var unitsInPackController = TextEditingController();
  var availablePacksController = TextEditingController();
  var availableUnitsController = TextEditingController();
  var batchNumberController = TextEditingController();
  var companyController = TextEditingController();
  var categoryController = TextEditingController();
  var packPurchasePriceController = TextEditingController();
  var unitPurchasePriceController = TextEditingController();
  var expiryDateController = TextEditingController();
  var searchController = TextEditingController();
  var purchaseDateController = TextEditingController();
  var monthController = TextEditingController();
  var expiryDate = ''.obs;

  RxBool isSingleUnit = false.obs;
  RxBool isSearching = false.obs;
  final formKey = GlobalKey<FormState>();
  final Box<PurchaseModel> purchaseBox = Hive.box<PurchaseModel>('purchases');
  final Box<int> idBox = Hive.box<int>('purchase_ids');


  @override
  void onInit() {
    super.onInit();
    loadPurchases();
    initializeIdBox();
    try {
      filterByMonth(DateFormat('MM/yyyy').format(DateTime.now()));
      monthController.text = DateFormat('MM/yyyy').format(DateTime.now());
    } catch (e) {
      print('Date parse error from init');
    }
    setCurrentPurchaseDate();
  }

  void initializeIdBox() {
    if (idBox.isEmpty) {
      idBox.put('latest_id', 0);
    }
  }

  void loadPurchases() {
    purchases.value = purchaseBox.values.toList();

    try {
      filterByMonth(DateFormat('MM/yyyy').format(DateTime.now()));
      filterByMonth(monthController.text);
    } catch (e) {
      print('Date parse error from load purchases');
    }
  }

  void setCurrentPurchaseDate() {
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd/MM/yyyy').format(now);
      purchaseDateController.text = formattedDate;
    } catch (e) {
      print('Date parse error from set current purchase date');
    }
  }

  void fillProductDetails(ProductModel product) {
    nameController.text = product.name;
    categoryController.text = product.category;
    companyController.text = product.company;
    formulaController.text = product.formula.toString();
    strengthController.text = product.strength.toString();
    batchNumberController.text = product.batchNumber;
    unitsInPackController.text = product.unitsInPack.toString();
    availablePacksController.text = product.availablePacks.toString();
    availableUnitsController.text = product.availableUnits.toString();
    isSingleUnit.value = product.isSingleUnit;
    packPurchasePriceController.text = product.packPurchasePrice.toString();
    unitPurchasePriceController.text = product.unitPurchasePrice.toString();
    expiryDateController.text = product.expiryDate;
    setCurrentPurchaseDate();
  }

  void addPurchase() {
    int latestId = idBox.get('latest_id', defaultValue: 0)!.toInt();
    int newId = latestId + 1;
    idBox.put('latest_id', newId);

    var purchase = PurchaseModel(
      purchaseId: newId.toString(),
      productTitle: selectedProduct.value,
      batchNumber: batchNumberController.text,
      isSingleUnit: isSingleUnit.value,
      strength: strengthController.text,
      formula: formulaController.text,
      unitsInPack: (double.tryParse(unitsInPackController.text) ?? 0.0).toInt(),
      availablePacks: isSingleUnit.value
          ? 0
          : (double.tryParse(availablePacksController.text) ?? 0.0).toInt(),
      availableUnits:
          (double.tryParse(availableUnitsController.text) ?? 0.0).toInt(),
      company: companyController.text,
      category: categoryController.text,
      packPurchasePrice: isSingleUnit.value
          ? 0.0
          : double.tryParse(packPurchasePriceController.text) ?? 0.0,
      unitPurchasePrice: double.parse(unitPurchasePriceController.text),
      expiryDate: expiryDateController.text,
      purchaseDate: purchaseDateController.text,
    );
    purchaseBox.add(purchase).then((value) => loadPurchases());
    // Refresh the purchases list
    clearFields();
  }

  void updatePurchase(String purchaseId) {
    // Find the index of the purchase to update based on the purchaseId
    int purchaseIndex = purchaseBox.values
        .toList()
        .indexWhere((purchase) => purchase.purchaseId == purchaseId);

    if (purchaseIndex != -1) {
      // Create a new updated PurchaseModel object
      var updatedPurchase = PurchaseModel(
        purchaseId: purchaseId,
        purchaseDate: purchaseDateController.text,
        productTitle: nameController.text,
        batchNumber: batchNumberController.text,
        isSingleUnit: isSingleUnit.value,
        strength: strengthController.text,
        formula: formulaController.text,
        unitsInPack:
            (double.tryParse(unitsInPackController.text) ?? 0.0).toInt(),
        availablePacks: isSingleUnit.value
            ? 0
            : (double.tryParse(availablePacksController.text) ?? 0.0).toInt(),
        availableUnits:
            (double.tryParse(availableUnitsController.text) ?? 0.0).toInt(),
        company: companyController.text,
        category: categoryController.text,
        packPurchasePrice: isSingleUnit.value
            ? 0.0
            : double.parse(packPurchasePriceController.text),
        unitPurchasePrice: double.parse(unitPurchasePriceController.text),
        expiryDate: expiryDateController.text,
      );

      // Update the existing purchase in the box
      purchaseBox.putAt(purchaseIndex, updatedPurchase);

      // Reload the purchases and clear input fields
      loadPurchases();
      clearFields();
    } else {
      print('Purchase with ID $purchaseId not found.');
    }
  }

  void deletePurchaseById(String purchaseId) {
    int index =
        purchases.indexWhere((purchase) => purchase.purchaseId == purchaseId);
    if (index != -1) {
      purchaseBox.deleteAt(index);
      loadPurchases(); // Refresh the purchases list
    }
  }

  void clearFields() {
    selectedProduct.value = '';
    unitsInPackController.clear();
    isSingleUnit.value = false;
    availablePacksController.clear();
    availableUnitsController.clear();
    batchNumberController.clear();
    companyController.clear();
    categoryController.clear();
    packPurchasePriceController.clear();
    unitPurchasePriceController.clear();
    expiryDateController.clear();
    expiryDate.value = '';
    setCurrentPurchaseDate();
  }

  double calculateTotalPurchases() {
    double total = 0;
    for (PurchaseModel purchaseModel in purchases) {
      total = total +
          (purchaseModel.isSingleUnit
              ? purchaseModel.unitPurchasePrice!.toDouble() *
                  purchaseModel.availableUnits!.toInt()
              : purchaseModel.packPurchasePrice!.toDouble() *
                  purchaseModel.availablePacks!.toInt());
    }
    return total;
  }

  void filterByMonth(String month) {
    try {
      // Ensure the input is trimmed and in the correct format
      month = month.trim();
      print('Received month: $month');

      // Validate that the input is not empty
      if (month.isEmpty) {
        throw const FormatException('Month string is empty');
      }

      // Parse the month string to get the start date of the month
      DateTime startDate = DateFormat('MM/yyyy').parse(month);
      print('Parsed start date: $startDate');

      // Calculate the end date of the month
      DateTime endDate = DateTime(startDate.year, startDate.month + 1, 1)
          .subtract(const Duration(days: 1));
      print('Calculated end date: $endDate');

      // Filter the purchases based on the start and end dates
      filteredPurchases.value = purchases.where((purchase) {
        DateTime purchaseDate =
            DateFormat('dd/MM/yyyy').parse(purchase.purchaseDate.toString());
        return purchaseDate.isAfter(startDate) &&
            purchaseDate.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();

      print('Filtered purchases: ${filteredPurchases.value}');
    } catch (e) {
      print('Invalid date format: $e (Received month: $month)');
    }
  }
}
