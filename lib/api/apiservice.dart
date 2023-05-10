import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/client_data.dart';
import '../model/menu_data.dart';
import '../model/notification_data.dart';
import '../model/order_data.dart';
import '../model/product_data.dart';
import '../model/sub_menu_data.dart';
part 'apiservice.g.dart';

@RestApi (baseUrl: "http://bosasp-001-site18.gtempurl.com/api/")
// @RestApi (baseUrl: "http://192.168.99.185/InventoryWebService/api/")
abstract class ApiService{
  factory ApiService(Dio dio) = _ApiService;

  @GET("menu")
  Future<List<MenuData>>? getMenu();

  @GET("product/GetProduct")
  Future<List<ProductData>>? getProduct();

  @POST("client/InsertClient")
  Future<int> insertClient(@Body() ClientData clientData);

  @GET("client/CheckClient")
  Future<ClientData> checkClientByPhone(@Query("phone") String phone);

  @GET("client/CheckClient")
  Future<ClientData> checkClient(@Query("phone") String phone,@Query("isSalePerson") bool isSalePerson);

  @POST("client/UpdateClientPassword")
  Future<void> updateClientPassword(@Query("clientId") int clientId,@Query("password") String password);

  @POST("saleorder")
  Future<String> sendOrder(@Body() OrderData orderData);

  @GET("saleorder/GetOrder")
  Future<List<OrderData>> getOrder(@Query("clientId") int clientId,@Query("isOrderFinished") bool isOrderFinished);

  @GET("clientnoti/GetClientNotification")
  Future<List<NotificationData>> getNotification(@Query("clientId") int clientId,@Query("isForStatusBar") bool isForStatusBar);

  @GET("clientnoti/GetClientNotiCount")
  Future<int> getNotificationCount(@Query("clientId") int clientId);

  @POST("clientnoti/DeleteAllClientNotification")
  Future<void> deleteAllNotification(@Query("clientId") int clientId);

  @GET("submenu/GetSubMenu")
  Future<List<SubMenuData>> getSubMenu();

}