// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductData _$ProductDataFromJson(Map<String, dynamic> json) => ProductData(
      ProductID: (json['ProductID'] as num).toInt(),
      SubMenuID: (json['SubMenuID'] as num).toInt(),
      Code: json['Code'] as String,
      ProductName: json['ProductName'] as String,
      SalePrice: (json['SalePrice'] as num).toInt(),
      Description: json['Description'] as String?,
      PhotoUrl: json['PhotoUrl'] as String?,
      Quantity: (json['Quantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductDataToJson(ProductData instance) =>
    <String, dynamic>{
      'ProductID': instance.ProductID,
      'SubMenuID': instance.SubMenuID,
      'SalePrice': instance.SalePrice,
      'Code': instance.Code,
      'ProductName': instance.ProductName,
      'Description': instance.Description,
      'PhotoUrl': instance.PhotoUrl,
      'Quantity': instance.Quantity,
    };
