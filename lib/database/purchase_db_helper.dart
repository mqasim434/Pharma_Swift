import 'package:hive/hive.dart';
import 'package:pharmacy_pos/models/purchase_model.dart';

class PurchaseDBHelper {
  final Box<PurchaseModel> _purchaseBox = Hive.box<PurchaseModel>('purchases');

  Future<void> addPurchase(PurchaseModel purchase) async {
    await _purchaseBox.add(purchase);
  }

  Future<List<PurchaseModel>> getAllPurchases() async {
    return _purchaseBox.values.toList();
  }
}
