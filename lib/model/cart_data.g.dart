// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartData _$CartDataFromJson(Map<String, dynamic> json) => CartData(
      productId: (json['ProductID'] as num).toInt(),
      quantity: (json['Quantity'] as num).toInt(),
      productName: json['ProductName'] as String,
      salePrice: (json['SalePrice'] as num).toInt(),
      photoUrl: json['photoUrl'] as String?,
      amount: (json['Amount'] as num).toInt(),
    )
      ..saleOrderId = (json['saleOrderId'] as num?)?.toInt()
      ..orderId = (json['orderId'] as num?)?.toInt();

Map<String, dynamic> _$CartDataToJson(CartData instance) => <String, dynamic>{
      'saleOrderId': instance.saleOrderId,
      'ProductID': instance.productId,
      'Quantity': instance.quantity,
      'ProductName': instance.productName,
      'SalePrice': instance.salePrice,
      'photoUrl': instance.photoUrl,
      'Amount': instance.amount,
      'orderId': instance.orderId,
    };
