import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pharmacy_pos/models/product_model.dart';
import 'db_helper.dart';

class ProductsDBController extends GetxController {
  final Box<ProductModel> _productsBox = Hive.box<ProductModel>(DBHelper.productBoxName);

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
  Future<void> updateProduct(int index, ProductModel updatedProduct) async {
    await _productsBox.putAt(index, updatedProduct);
    loadProducts(); // Refresh the list
  }

  /// Delete a product by index
  Future<void> deleteProduct(int index) async {
    await _productsBox.deleteAt(index);
    loadProducts(); // Refresh the list
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
