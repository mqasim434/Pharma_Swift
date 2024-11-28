// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PurchaseModelAdapter extends TypeAdapter<PurchaseModel> {
  @override
  final int typeId = 0;

  @override
  PurchaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchaseModel(
      purchaseId: fields[0] as String,
      purchaseDate: fields[1] as String?,
      productTitle: fields[2] as String?,
      unitsInPack: fields[3] as int?,
      isSingleUnit: fields[12] as bool,
      availablePacks: fields[10] as int?,
      availableUnits: fields[11] as int?,
      batchNumber: fields[4] as String?,
      company: fields[5] as String?,
      category: fields[9] as String?,
      packPurchasePrice: fields[6] as double?,
      unitPurchasePrice: fields[7] as double?,
      expiryDate: fields[8] as String?,
      strength: fields[14] as String?,
      formula: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PurchaseModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.purchaseId)
      ..writeByte(1)
      ..write(obj.purchaseDate)
      ..writeByte(2)
      ..write(obj.productTitle)
      ..writeByte(3)
      ..write(obj.unitsInPack)
      ..writeByte(4)
      ..write(obj.batchNumber)
      ..writeByte(5)
      ..write(obj.company)
      ..writeByte(6)
      ..write(obj.packPurchasePrice)
      ..writeByte(7)
      ..write(obj.unitPurchasePrice)
      ..writeByte(8)
      ..write(obj.expiryDate)
      ..writeByte(9)
      ..write(obj.category)
      ..writeByte(10)
      ..write(obj.availablePacks)
      ..writeByte(11)
      ..write(obj.availableUnits)
      ..writeByte(12)
      ..write(obj.isSingleUnit)
      ..writeByte(13)
      ..write(obj.formula)
      ..writeByte(14)
      ..write(obj.strength);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
