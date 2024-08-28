// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderData _$OrderDataFromJson(Map<String, dynamic> json) => OrderData(
      ClientID: (json['ClientID'] as num).toInt(),
      CustomerID: (json['CustomerID'] as num).toInt(),
      Subtotal: (json['Subtotal'] as num).toInt(),
      Tax: (json['Tax'] as num).toInt(),
      TaxAmt: (json['TaxAmt'] as num).toInt(),
      Charges: (json['Charges'] as num).toInt(),
      ChargesAmt: (json['ChargesAmt'] as num).toInt(),
      Total: (json['Total'] as num?)?.toInt(),
      Remark: json['Remark'] as String,
      lstSaleOrderTran: (json['lstSaleOrderTran'] as List<dynamic>?)
          ?.map((e) => CartData.fromJson(e as Map<String, dynamic>))
          .toList(),
      OrderNumber: json['OrderNumber'] as String?,
      Year: json['Year'] as String?,
      Month: json['Month'] as String?,
      Day: json['Day'] as String?,
    );

Map<String, dynamic> _$OrderDataToJson(OrderData instance) => <String, dynamic>{
      'ClientID': instance.ClientID,
      'CustomerID': instance.CustomerID,
      'Subtotal': instance.Subtotal,
      'Tax': instance.Tax,
      'TaxAmt': instance.TaxAmt,
      'Charges': instance.Charges,
      'ChargesAmt': instance.ChargesAmt,
      'Total': instance.Total,
      'Remark': instance.Remark,
      'lstSaleOrderTran': instance.lstSaleOrderTran,
      'OrderNumber': instance.OrderNumber,
      'Year': instance.Year,
      'Month': instance.Month,
      'Day': instance.Day,
    };
