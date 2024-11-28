import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/controllers/purchase_controller.dart';
import 'package:pharmacy_pos/models/purchase_model.dart';

class PurchasesFilterController extends GetxController {
  RxInt selectedMonth = DateTime.now().month.obs;
  RxInt selectedYear = DateTime.now().year.obs;
  RxList<PurchaseModel> filteredPurchases = <PurchaseModel>[].obs;
  RxList<PurchaseModel> searchResults = <PurchaseModel>[].obs;
  RxBool isSearching = false.obs;

  final PurchaseController purchaseController =
      Get.put<PurchaseController>(PurchaseController());

  @override
  void onInit() {
    super.onInit();
    fetchPurchases();
  }

  void showAllPurchases() {
    filteredPurchases.value =
        purchaseController.purchases; // Show all purchases
  }

  // Method to fetch purchases from the database
  void fetchPurchases() {
    filteredPurchases.value =
        purchaseController.purchases; // Assuming purchases are fetched here
  }

  void setMonthAndYear(int month, int year) {
    selectedMonth.value = month;
    selectedYear.value = year;
    updateFilteredPurchases(
        purchaseController.purchases); // Update filtered purchases
    update();
  }

  void updateFilteredPurchases(List<PurchaseModel> allPurchases) {
    filteredPurchases.value = allPurchases.where((purchase) {
      try {
        // Assuming the date format is 'dd/MM/yyyy'
        DateFormat format = DateFormat('dd/MM/yyyy');
        DateTime purchaseDateTime =
            format.parse(purchase.purchaseDate.toString());
        return purchaseDateTime.year == selectedYear.value &&
            purchaseDateTime.month == selectedMonth.value;
      } catch (e) {
        print('Error parsing date: ${purchase.purchaseDate}. Exception: $e');
        return false; // Exclude purchases with invalid date formats
      }
    }).toList(); // Filter purchases by selected month and year
  }

  void switchSearchingStatus(bool value) {
    isSearching.value = value;
    if (!value) {
      filteredPurchases.value =
          []; // Clear filtered purchases when not searching
    }
  }

  void searchPurchases(String query) {
    if (query.isEmpty) {
      isSearching.value = false;
      searchResults.clear();
    } else {
      isSearching.value = true;
      searchResults.value = filteredPurchases.where((purchase) {
        final productName = purchase.productTitle?.toLowerCase() ?? '';
        final id = purchase.purchaseId.toLowerCase();
        final category = purchase.category?.toLowerCase() ?? '';
        final company = purchase.company?.toLowerCase() ?? '';
        final batchNumber = purchase.batchNumber?.toLowerCase() ?? '';

        return (productName.isNotEmpty &&
                productName != 'n/a' &&
                productName.contains(query.toLowerCase())) ||
            (company.isNotEmpty &&
                company != 'n/a' &&
                company.contains(query.toLowerCase())) ||
            (batchNumber.isNotEmpty &&
                batchNumber != 'n/a' &&
                batchNumber.contains(query.toLowerCase())) ||
            (id.isNotEmpty &&
                id != 'n/a' &&
                id.contains(query.toLowerCase())) ||
            (category.isNotEmpty &&
                category != 'n/a' &&
                category.contains(query.toLowerCase()));
      }).toList();
    }
  }
}
