import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pharmacy_pos/models/order_model.dart';
import 'package:pharmacy_pos/models/product_model.dart';

class DBHelper {
  static Future<void> init() async {
    final directory = await getApplicationSupportDirectory();
    Hive.init('${directory.path}/Data');
    print(directory.path);

    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(OrderModelAdapter());
    Hive.registerAdapter(OrderItemAdapter());
  }

  static Future<void> close() async {
    await Hive.close();
  }
}
