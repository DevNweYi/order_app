import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
part 'cart_data.g.dart';

@JsonSerializable()
class CartData{

  int? saleOrderId;
  @JsonKey(name:"ProductID")
  int productId;
  @JsonKey(name:"Quantity")
  int quantity;
  @JsonKey(name:"ProductName")
  String productName;
  @JsonKey(name:"SalePrice")
  int salePrice;
  String? photoUrl;
  @JsonKey(name:"Amount")
  int amount;

  CartData({required this.productId,required this.quantity,required this.productName,required this.salePrice,this.photoUrl,required this.amount});

  factory CartData.fromJson(Map<String, dynamic> json) => _$CartDataFromJson(json);
  Map<String, dynamic> toJson() => _$CartDataToJson(this);

  static Map<String,dynamic> insertCart({required int ProductID,required int Quantity}){
      return {
        "ProductID":ProductID,
        "Quantity":Quantity      
        };
    }

}