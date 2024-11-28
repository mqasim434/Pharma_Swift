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

  // Deep copy method
  OrderModel copy() {
    return OrderModel(
      id: id,
      orderDate: orderDate,
      items: items.map((item) => item.copy()).toList(),
      totalAmount: totalAmount,
      discount: discount,
      netAmount: netAmount,
      customerName: customerName,
      notes: notes,
    );
  }
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

  // Deep copy method
  OrderItem copy() {
    return OrderItem(
      productId: productId,
      name: name,
      quantity: quantity,
      retailPrice: retailPrice,
      salePrice: salePrice,
      totalPrice: totalPrice,
      profit: profit,
      category: category,
      formula: formula,
      strength: strength,
      company: company,
    );
  }

  double getProfit() {
    return salePrice - retailPrice;
  }
}
