// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_product_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListProductResponseAdapter extends TypeAdapter<ListProductResponse> {
  @override
  final int typeId = 0;

  @override
  ListProductResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListProductResponse(
      data: (fields[0] as List).cast<ProductModel>(),
      pagination: fields[1] as Pagination,
    );
  }

  @override
  void write(BinaryWriter writer, ListProductResponse obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.pagination);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListProductResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
