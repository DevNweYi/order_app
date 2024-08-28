import 'package:json_annotation/json_annotation.dart';

import 'cart_data.dart';
part 'order_data.g.dart';

@JsonSerializable()
class OrderData {
  int ClientID;
  int CustomerID;
  int Subtotal;
  int Tax;
  int TaxAmt;
  int Charges;
  int ChargesAmt;
  int? Total;
  String Remark;
  List<CartData>? lstSaleOrderTran;
  String? OrderNumber;
  String? Year;
  String? Month;
  String? Day;

  OrderData(
      {required this.ClientID,
      required this.CustomerID,
      required this.Subtotal,
      required this.Tax,
      required this.TaxAmt,
      required this.Charges,
      required this.ChargesAmt,
      required this.Total,
      required this.Remark,
      required this.lstSaleOrderTran,
      required this.OrderNumber,
      required this.Year,
      required this.Month,
      required this.Day});

  factory OrderData.fromJson(Map<String, dynamic> json) =>
      _$OrderDataFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDataToJson(this);
}
