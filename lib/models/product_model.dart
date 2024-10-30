import 'package:hive/hive.dart';
import 'package:pharmacy_pos/utils/enums.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
class ProductModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String type; // Pill, Capsule, Syrup, Injection

  @HiveField(2)
  String formula;

  @HiveField(3)
  String vendor;

  @HiveField(4)
  double? strength; // mg or ml (for pills and capsules)

  @HiveField(15)
  double unitPrice; // Price per unit (for syrups, pills, etc.)

  @HiveField(7)
  int? unitsPerBlister; // Pills per blister (optional)

  @HiveField(6)
  int? blistersPerPack; // For pills/capsules

  @HiveField(8)
  int? totalBlisters; // Total available blisters (optional)

  @HiveField(9)
  int? totalPacks; // Total packs available (optional)

  @HiveField(5)
  int? availableUnits; // Total units (individual pills/capsules)

  @HiveField(10)
  int? quantity; // Syrups/Injections: Number of bottles or vials

  @HiveField(11)
  DateTime expiryDate;

  @HiveField(12)
  String batchNumber;

  @HiveField(13)
  String rackNo; // Storage rack number

  @HiveField(14)
  bool isSingleUnit; // True if it’s a single unit (default: true)

  @HiveField(16)
  double? pricePerBlister; // Price per blister (optional)

  @HiveField(17)
  double? pricePerPack; // Price per pack (optional)

  @HiveField(18)
  String? barcode; // Price per pack (optional)

  ProductModel({
    required this.name,
    required this.type,
    required this.formula,
    required this.vendor,
    this.strength,
    this.availableUnits,
    this.barcode,
    this.blistersPerPack,
    this.unitsPerBlister,
    this.totalBlisters,
    this.totalPacks,
    this.quantity,
    required this.expiryDate,
    required this.batchNumber,
    required this.rackNo,
    this.isSingleUnit = true, // Default value is true
    required this.unitPrice,
    this.pricePerBlister,
    this.pricePerPack,
  });

}
