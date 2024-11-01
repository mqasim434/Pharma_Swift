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
      name: fields[0] as String,
      type: fields[1] as String,
      formula: fields[2] as String,
      vendor: fields[3] as String,
      strength: fields[4] as double?,
      availableUnits: fields[5] as int?,
      barcode: fields[18] as String?,
      blistersPerPack: fields[6] as int?,
      unitsPerBlister: fields[7] as int?,
      totalBlisters: fields[8] as int?,
      totalPacks: fields[9] as int?,
      quantity: fields[10] as int?,
      expiryDate: fields[11] as DateTime,
      batchNumber: fields[12] as String,
      rackNo: fields[13] as String,
      isSingleUnit: fields[14] as bool,
      unitPrice: fields[15] as double,
      pricePerBlister: fields[16] as double?,
      pricePerPack: fields[17] as double?,
      imageUrl: fields[19] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.formula)
      ..writeByte(3)
      ..write(obj.vendor)
      ..writeByte(4)
      ..write(obj.strength)
      ..writeByte(15)
      ..write(obj.unitPrice)
      ..writeByte(7)
      ..write(obj.unitsPerBlister)
      ..writeByte(6)
      ..write(obj.blistersPerPack)
      ..writeByte(8)
      ..write(obj.totalBlisters)
      ..writeByte(9)
      ..write(obj.totalPacks)
      ..writeByte(5)
      ..write(obj.availableUnits)
      ..writeByte(10)
      ..write(obj.quantity)
      ..writeByte(11)
      ..write(obj.expiryDate)
      ..writeByte(12)
      ..write(obj.batchNumber)
      ..writeByte(13)
      ..write(obj.rackNo)
      ..writeByte(14)
      ..write(obj.isSingleUnit)
      ..writeByte(16)
      ..write(obj.pricePerBlister)
      ..writeByte(17)
      ..write(obj.pricePerPack)
      ..writeByte(18)
      ..write(obj.barcode)
      ..writeByte(19)
      ..write(obj.imageUrl);
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
