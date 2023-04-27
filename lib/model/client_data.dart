import 'package:json_annotation/json_annotation.dart';
part 'client_data.g.dart';

@JsonSerializable()
class ClientData{
  int ClientID;
  String? ClientName;
  String? ClientPassword;
  String? ShopName;
  String? Phone;
  int DivisionID;
  int TownshipID;
  String? Address;
  bool IsSalePerson;
  String? DivisionName;
  String? TownshipName;
  String? Token;

  ClientData({
    required this.ClientID,
    required this.ClientName,
    required this.ClientPassword,
    required this.ShopName,
    required this.Phone,
    required this.DivisionID,
    required this.TownshipID,
    required this.Address,
    required this.IsSalePerson,
    required this.DivisionName,
    required this.TownshipName,
    required this.Token
  });

  factory ClientData.fromJson(Map<String, dynamic> json) => _$ClientDataFromJson(json);
  Map<String, dynamic> toJson() => _$ClientDataToJson(this);
}