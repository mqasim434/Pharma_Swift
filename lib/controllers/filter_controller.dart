import 'package:get/get.dart';
import 'package:pharmacy_pos/controllers/products_controller.dart';
import 'package:pharmacy_pos/models/product_model.dart';

class FiltersController extends GetxController {
  RxString selectedLabel = "All".obs;
  RxList<ProductModel> filteredProducts = <ProductModel>[].obs;
  RxBool isSearching = false.obs;

  final ProductsController productsDBController =
      Get.put<ProductsController>(ProductsController());

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // Method to fetch products from the database
  void fetchProducts() {
    filteredProducts.value =
        productsDBController.productList; // Assuming products are fetched here
  }

  void changeLabel(String label) {
    selectedLabel.value = label;
    updateFilteredProducts(
        productsDBController.productList); // Update filtered products
  }

  void updateFilteredProducts(List<ProductModel> allProducts) {
    if (selectedLabel.value == 'All') {
      filteredProducts.value = allProducts; // Show all products
    } else {
      filteredProducts.value = allProducts
          .where((element) => element.category == selectedLabel.value)
          .toList(); // Filter products by selected label
    }
  }

  void switchSearchingStatus(bool value) {
    isSearching.value = value;
    if (!value) {
      filteredProducts.value = []; // Clear filtered products when not searching
    }
  }

  void searchProducts(String query, List<ProductModel> allProducts) {
    if (query.isEmpty) {
      filteredProducts.value =
          allProducts; // Reset to all products if query is empty
    } else {
      filteredProducts.value = allProducts.where((product) {
        final name = product.name?.toLowerCase() ?? '';
        final barcode = product.barcode?.toLowerCase() ?? '';
        final formula = product.formula?.toLowerCase() ?? '';
        final company = product.company?.toLowerCase() ?? '';

        return (name.isNotEmpty &&
                name != 'n/a' &&
                name.contains(query.toLowerCase())) ||
            (barcode.isNotEmpty &&
                barcode != 'n/a' &&
                barcode.contains(query.toLowerCase())) ||
            (company.isNotEmpty &&
                company != 'n/a' &&
                company.contains(query.toLowerCase())) ||
            (formula.isNotEmpty &&
                formula != 'n/a' &&
                formula.contains(query.toLowerCase()));
      }).toList();
    }
  }
}
