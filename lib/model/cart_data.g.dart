// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartData _$CartDataFromJson(Map<String, dynamic> json) => CartData(
      productId: json['ProductID'] as int,
      quantity: json['Quantity'] as int,
      productName: json['ProductName'] as String,
      salePrice: json['SalePrice'] as int,
      photoUrl: json['photoUrl'] as String?,
      amount: json['Amount'] as int,
    )..saleOrderId = json['saleOrderId'] as int?;

Map<String, dynamic> _$CartDataToJson(CartData instance) => <String, dynamic>{
      'saleOrderId': instance.saleOrderId,
      'ProductID': instance.productId,
      'Quantity': instance.quantity,
      'ProductName': instance.productName,
      'SalePrice': instance.salePrice,
      'photoUrl': instance.photoUrl,
      'Amount': instance.amount,
    };
