import 'package:hive/hive.dart';

part 'order_model.g.dart';

@HiveType(typeId: 2)
class OrderModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime orderDate;

  @HiveField(2)
  List<OrderItem> items;

  @HiveField(3)
  double totalAmount;

  @HiveField(4)
  double discount;

  @HiveField(5)
  double netAmount;

  @HiveField(6)
  String? customerName;

  @HiveField(7)
  String? notes;

  OrderModel({
    this.id = 'No ID',
    required this.orderDate,
    required this.items,
    required this.totalAmount,
    required this.discount,
    required this.netAmount,
    this.customerName,
    this.notes,
  });
}

@HiveType(typeId: 3)
class OrderItem {
  @HiveField(0)
  String productId;

  @HiveField(1)
  String name;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  double retailPrice;

  @HiveField(4)
  double salePrice;

  @HiveField(5)
  double totalPrice;

  @HiveField(6)
  double profit;

  @HiveField(7)
  String formula;

  @HiveField(8)
  String category;

  @HiveField(9)
  String strength;

  @HiveField(10)
  String company;

  OrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.retailPrice,
    required this.salePrice,
    required this.totalPrice,
    required this.profit,
    required this.category,
    required this.formula,
    required this.strength,
    required this.company,
  });

  double getProfit() {
    return salePrice - salePrice;
  }
}
