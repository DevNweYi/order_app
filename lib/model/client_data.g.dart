// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientData _$ClientDataFromJson(Map<String, dynamic> json) => ClientData(
      ClientID: (json['ClientID'] as num).toInt(),
      ClientName: json['ClientName'] as String?,
      ClientPassword: json['ClientPassword'] as String?,
      ShopName: json['ShopName'] as String?,
      Phone: json['Phone'] as String?,
      DivisionID: (json['DivisionID'] as num).toInt(),
      TownshipID: (json['TownshipID'] as num).toInt(),
      Address: json['Address'] as String?,
      IsSalePerson: json['IsSalePerson'] as bool,
      DivisionName: json['DivisionName'] as String?,
      TownshipName: json['TownshipName'] as String?,
      Token: json['Token'] as String?,
    );

Map<String, dynamic> _$ClientDataToJson(ClientData instance) =>
    <String, dynamic>{
      'ClientID': instance.ClientID,
      'ClientName': instance.ClientName,
      'ClientPassword': instance.ClientPassword,
      'ShopName': instance.ShopName,
      'Phone': instance.Phone,
      'DivisionID': instance.DivisionID,
      'TownshipID': instance.TownshipID,
      'Address': instance.Address,
      'IsSalePerson': instance.IsSalePerson,
      'DivisionName': instance.DivisionName,
      'TownshipName': instance.TownshipName,
      'Token': instance.Token,
    };
