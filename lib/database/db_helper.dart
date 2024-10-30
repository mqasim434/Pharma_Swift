import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pharmacy_pos/models/product_model.dart';

class DBHelper {
  static const String productBoxName = 'productsBox';

  /// Initialize Hive and open necessary boxes
  static Future<void> init() async {
    await Hive.initFlutter(); // Initializes Hive with Flutter support

    // Register the Medicine adapter
    Hive.registerAdapter(ProductModelAdapter());

    // Open the products box
    await Hive.openBox<ProductModel>(productBoxName);
  }

  /// Close Hive boxes when the app exits
  static Future<void> close() async {
    await Hive.close();
  }
}
