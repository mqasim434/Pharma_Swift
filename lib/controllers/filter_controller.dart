import 'package:get/get.dart';
import 'package:pharmacy_pos/models/product_model.dart';
import 'package:pharmacy_pos/database/products_db_helper.dart';

class FiltersController extends GetxController {
  RxString selectedLabel = "All".obs;
  RxList<ProductModel> filteredProducts = <ProductModel>[].obs;
  RxBool isSearching = false.obs;

  final ProductsDBController productsDBController =
      Get.find<ProductsDBController>();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // Method to fetch products from the database
  void fetchProducts() {
    filteredProducts.value =
        productsDBController.products; // Assuming products are fetched here
  }

  void changeLabel(String label) {
    selectedLabel.value = label;
    updateFilteredProducts(
        productsDBController.products); // Update filtered products
  }

  void updateFilteredProducts(List<ProductModel> allProducts) {
    if (selectedLabel.value == 'All') {
      filteredProducts.value = allProducts; // Show all products
    } else {
      filteredProducts.value = allProducts
          .where((element) => element.type == selectedLabel.value)
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
      filteredProducts.value = allProducts
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList(); // Filter by query
    }
  }
}
