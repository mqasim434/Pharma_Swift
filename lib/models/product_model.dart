import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
class ProductModel extends HiveObject {
  @HiveField(0)
  String id; // Unique identifier for the product

  @HiveField(1)
  String name;

  @HiveField(2)
  String category;

  @HiveField(3)
  String? formula;

  @HiveField(4)
  String? strength;

  @HiveField(5)
  String company;

  @HiveField(6)
  String batchNumber;

  @HiveField(7)
  String? barcode;

  @HiveField(8)
  int? availableUnits;

  @HiveField(9)
  double unitPurchasePrice; // Retail price for individual units

  @HiveField(10)
  double? unitSalePrice; // Sale price for individual units, if applicable

  @HiveField(11)
  int? unitsInPack;

  @HiveField(12)
  double? packPurchasePrice; // Retail price for packs

  @HiveField(13)
  double? packSalePrice; // Sale price for packs, if applicable

  @HiveField(14)
  int? availablePacks;

  @HiveField(15)
  String expiryDate;

  @HiveField(16)
  bool isSingleUnit;

  @HiveField(17)
  int? reorderLevel;

  @HiveField(18)
  double? gst;

  @HiveField(19)
  double? margin;

  @HiveField(20)
  double? packPurchaseGSTIncluded;

  ProductModel({
    this.id = 'No Id',
    required this.name,
    required this.category,
    required this.formula,
    required this.strength,
    required this.company,
    required this.batchNumber,
    this.barcode,
    this.isSingleUnit = true,
    required this.unitPurchasePrice,
    this.unitSalePrice,
    this.unitsInPack,
    this.packPurchasePrice,
    this.packPurchaseGSTIncluded,
    this.packSalePrice,
    this.availableUnits,
    this.availablePacks,
    required this.expiryDate,
    this.reorderLevel,
    this.gst,
    this.margin,
  });
}
