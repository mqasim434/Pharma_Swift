import 'package:hive/hive.dart';

part 'sales_model.g.dart';

@HiveType(typeId: 8)
class SalesModel extends HiveObject {
  @HiveField(0)
  double amount;

  @HiveField(1)
  DateTime date;

  SalesModel({required this.amount, required this.date});
}
