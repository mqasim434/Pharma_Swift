import 'package:hive/hive.dart';

part 'purchase_model.g.dart';

@HiveType(typeId: 0)
class PurchaseModel {
  @HiveField(0)
  final String purchaseId;

  @HiveField(1)
  final String? purchaseDate;

  @HiveField(2)
  final String? productTitle;

  @HiveField(3)
  final int? unitsInPack;

  @HiveField(4)
  final String? batchNumber;

  @HiveField(5)
  final String? company;

  @HiveField(6)
  final double? packPurchasePrice;

  @HiveField(7)
  final double? unitPurchasePrice;

  @HiveField(8)
  final String? expiryDate;

  @HiveField(9)
  String? category;

  @HiveField(10)
  int? availablePacks;

  @HiveField(11)
  int? availableUnits;

  @HiveField(12)
  bool isSingleUnit;

  @HiveField(13)
  String? formula;

  @HiveField(14)
  String? strength;

  PurchaseModel({
    required this.purchaseId,
    required this.purchaseDate,
    required this.productTitle,
    required this.unitsInPack,
    required this.isSingleUnit,
    required this.availablePacks,
    required this.availableUnits,
    required this.batchNumber,
    required this.company,
    required this.category,
    required this.packPurchasePrice,
    required this.unitPurchasePrice,
    required this.expiryDate,
    required this.strength,
    required this.formula,
  });
}
