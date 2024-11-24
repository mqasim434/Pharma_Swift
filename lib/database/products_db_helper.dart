import 'package:hive/hive.dart';
import 'package:pharmacy_pos/models/product_model.dart';

class ProductsDBHelper {
  static const String _productBoxName = 'productsBox';

  // Open the box
  Future<Box<ProductModel>> _openBox() async {
    return await Hive.openBox<ProductModel>(_productBoxName);
  }

  // Add a new product
  Future<void> addProduct(ProductModel product) async {
    final box = await _openBox();
    await box.add(product);
  }

  // Update an existing product
  Future<void> updateProduct(String id, ProductModel updatedProduct) async {
  final box = await _openBox();

  // Find the key of the product with the given id.
  final key = box.keys.firstWhere(
    (key) => box.get(key)?.id == id,
    orElse: () => null, // Handle case if no matching product is found.
  );

  if (key != null) {
    await box.put(key, updatedProduct);
    print('Product with ID $id updated successfully.');
  } else {
    print('Product with ID $id not found.');
  }
}

  // Delete a product
  Future<void> deleteProductById(String id) async {
    final box = await _openBox();

    // Find the key associated with the product id
    final key = box.keys.firstWhere(
      (key) =>
          box.get(key)?.id == id, // Assuming each product has an 'id' field
      orElse: () => null,
    );

    // If the product with the given id is found, delete it
    if (key != null) {
      await box.delete(key);
    } else {
      print('Product with id $id not found.');
    }
  }

  // Retrieve all products
  Future<List<ProductModel>> getAllProducts() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> deleteAllProducts() async {
    final box = await _openBox();
    try {
      await box.clear(); // Deletes all products from the box
      print('All products deleted successfully');
    } catch (e) {
      print("Error deleting all products: $e");
    }
  }

  // Find a product by ID
  Future<ProductModel?> getProductById(String id) async {
    final box = await _openBox();
    try {
      return box.values.firstWhere((product) => product.id == id);
    } catch (e) {
      // If no product is found, return null
      return null;
    }
  }

  // Close the box (optional)
  Future<void> closeBox() async {
    final box = await _openBox();
    await box.close();
  }
}
