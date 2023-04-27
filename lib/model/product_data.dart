import 'package:json_annotation/json_annotation.dart';
part 'product_data.g.dart';

@JsonSerializable()
class ProductData{

  int ProductID;
  int SubMenuID;
  int SalePrice;
  String Code;
  String ProductName;
  String? Description;
  String? PhotoUrl;
  int? Quantity;

  ProductData({required this.ProductID,required this.SubMenuID,required this.Code,required this.ProductName,required this.SalePrice,this.Description,this.PhotoUrl,this.Quantity});

  factory ProductData.fromJson(Map<String, dynamic> json) => _$ProductDataFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDataToJson(this);

  static Map<String,dynamic> insertProduct(
    {required int ProductID,required int SubMenuID,required int SalePrice,required String Code,
    required String ProductName,String? Description,String? PhotoUrl}){
      return {
        "ProductID":ProductID,
        "SubMenuID":SubMenuID,
        "SalePrice":SalePrice,
        "Code":Code,
        "ProductName":ProductName,
        "Description":Description,
        "PhotoUrl":PhotoUrl
        };
    }

}