import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pharmacy_pos/models/product_model.dart';
import 'db_helper.dart';

class ProductsDBController extends GetxController {
  final Box<ProductModel> _productsBox =
      Hive.box<ProductModel>(DBHelper.productBoxName);

  /// RxList to hold products reactively
  var products = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts(); // Load products when the controller is initialized
  }

  /// Load all products from Hive box
  void loadProducts() {
    products.value = _productsBox.values.toList();
  }

  /// Add a new product
  Future<void> addProduct(ProductModel product) async {
    await _productsBox.add(product);
    loadProducts(); // Refresh the list
  }

  /// Update a product by index
  Future<void> updateProductByName(String id, ProductModel updatedProduct) async {

    // Find the index of the product by name
    int index = _productsBox.values.toList().indexWhere((product) => product.name == id);

    // If the product is found, update it
    if (index != -1) {
      await _productsBox.putAt(index, updatedProduct);
    } else {
      // Handle the case where the product was not found
      throw Exception('Product not found');
    }
  }

  Future<void> deleteProductById(String id) async {
    try {
      // Find the product by comparing the id
      final productKey = _productsBox.keys.firstWhere(
        (key) => _productsBox.get(key)?.name == id,
        orElse: () => null,
      );

      if (productKey != null) {
        await _productsBox.delete(productKey);
        loadProducts();
        print("Product with ID $id deleted successfully.");
      } else {
        print("Product with ID $id not found.");
      }
    } catch (e) {
      print("An error occurred while deleting the product: $e");
    }
  }

  /// Delete all products
  Future<void> deleteAllProducts() async {
    await _productsBox.clear();
    loadProducts(); // Refresh the list
  }

  /// Get a product by index
  ProductModel? getProduct(int index) {
    return _productsBox.getAt(index);
  }
}
