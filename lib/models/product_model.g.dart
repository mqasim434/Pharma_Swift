// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 1;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      formula: fields[3] as String?,
      strength: fields[4] as String?,
      company: fields[5] as String,
      batchNumber: fields[6] as String,
      barcode: fields[7] as String?,
      isSingleUnit: fields[16] as bool,
      unitPurchasePrice: fields[9] as double,
      unitSalePrice: fields[10] as double?,
      unitsInPack: fields[11] as int?,
      packPurchasePrice: fields[12] as double?,
      packPurchaseGSTIncluded: fields[20] as double?,
      packSalePrice: fields[13] as double?,
      availableUnits: fields[8] as int?,
      availablePacks: fields[14] as int?,
      expiryDate: fields[15] as String,
      reorderLevel: fields[17] as int?,
      gst: fields[18] as double?,
      margin: fields[19] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.formula)
      ..writeByte(4)
      ..write(obj.strength)
      ..writeByte(5)
      ..write(obj.company)
      ..writeByte(6)
      ..write(obj.batchNumber)
      ..writeByte(7)
      ..write(obj.barcode)
      ..writeByte(8)
      ..write(obj.availableUnits)
      ..writeByte(9)
      ..write(obj.unitPurchasePrice)
      ..writeByte(10)
      ..write(obj.unitSalePrice)
      ..writeByte(11)
      ..write(obj.unitsInPack)
      ..writeByte(12)
      ..write(obj.packPurchasePrice)
      ..writeByte(13)
      ..write(obj.packSalePrice)
      ..writeByte(14)
      ..write(obj.availablePacks)
      ..writeByte(15)
      ..write(obj.expiryDate)
      ..writeByte(16)
      ..write(obj.isSingleUnit)
      ..writeByte(17)
      ..write(obj.reorderLevel)
      ..writeByte(18)
      ..write(obj.gst)
      ..writeByte(19)
      ..write(obj.margin)
      ..writeByte(20)
      ..write(obj.packPurchaseGSTIncluded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
