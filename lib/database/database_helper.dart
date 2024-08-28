import 'package:intl/intl.dart';
import 'package:order_app/model/cart_data.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../model/order_data.dart';
import '../model/product_data.dart';

class DatabaseHelper {
  late Database _db;
  static const String productTableName = "Product";
  static const String cartTableName = "Cart";
  static const String orderTableName = "Order";
  static const String orderMasterTableName = "OrderMaster";

  Future<Database> _createDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, "order.db");
    _db = await openDatabase(path);
    await _db.execute(
        "CREATE TABLE IF NOT EXISTS $productTableName(ProductID INTEGER,SubMenuID INTEGER,Code TEXT,ProductName TEXT,SalePrice INTEGER,Description TEXT,PhotoUrl TEXT)");
    await _db.execute(
        "CREATE TABLE IF NOT EXISTS $cartTableName(ProductID INTEGER,Quantity INTEGER)");
    await _db.execute(
        "CREATE TABLE IF NOT EXISTS $orderTableName(OrderID INTEGER,ProductName TEXT,Quantity INTEGER,SalePrice INTEGER,PhotoUrl TEXT,Amount INTEGER)");
    await _db.execute(
        "CREATE TABLE IF NOT EXISTS $orderMasterTableName(OrderID INTEGER PRIMARY KEY AUTOINCREMENT,OrderNumber TEXT,Day INTEGER,Month INTEGER,Year INTEGER,Total INTEGER)");
    return _db;
  }

  Future<int> insertProduct(Map<String, dynamic> productData) async {
    _db = await _createDatabase();
    return await _db.insert(productTableName, productData);
  }

  Future<List<ProductData>> getProduct(int subMenuId, bool isSearch,
      [String? searchValue]) async {
    List<ProductData> list = [];
    _db = await _createDatabase();
    List<Map<String, dynamic>> lstProduct;
    if (!isSearch) {
      if (subMenuId == 0) {
        lstProduct = await _db.rawQuery(
            "SELECT p.ProductID,SubMenuID,Code,ProductName,SalePrice,Description,PhotoUrl,Quantity FROM $productTableName p LEFT JOIN $cartTableName c ON p.ProductID=c.ProductID");
      } else {
        lstProduct = await _db.rawQuery(
            "SELECT p.ProductID,SubMenuID,Code,ProductName,SalePrice,Description,PhotoUrl,Quantity FROM $productTableName p LEFT JOIN $cartTableName c ON p.ProductID=c.ProductID WHERE SubMenuID=$subMenuId");
      }
    } else {
      lstProduct = await _db.rawQuery(
          "SELECT p.ProductID,SubMenuID,Code,ProductName,SalePrice,Description,PhotoUrl,Quantity FROM $productTableName p LEFT JOIN $cartTableName c ON p.ProductID=c.ProductID WHERE ProductName LIKE '%$searchValue%'");
    }
    for (int i = 0; i < lstProduct.length; i++) {
      Map product = lstProduct[i];
      ProductData data = ProductData(
          ProductID: product["ProductID"],
          SubMenuID: product["SubMenuID"],
          Code: product["Code"],
          ProductName: product["ProductName"],
          SalePrice: product["SalePrice"],
          Description: product["Description"],
          PhotoUrl: product["PhotoUrl"],
          Quantity: product["Quantity"]);
      list.add(data);
    }
    return list;
  }

  Future<int> deleteAllProduct() async {
    _db = await _createDatabase();
    return await _db.rawDelete("DELETE FROM $productTableName");
  }

  Future<int> insertCart(Map<String, dynamic> cartData) async {
    _db = await _createDatabase();
    int productId = cartData["ProductID"];
    int quantity = cartData["Quantity"];
    if (quantity == 0) {
      return await _db
          .rawDelete("DELETE FROM $cartTableName WHERE ProductID=$productId");
    } else {
      List<Map<String, dynamic>> lstCart = await _db
          .rawQuery("SELECT * FROM $cartTableName WHERE ProductID=$productId");
      if (lstCart.isEmpty) {
        return await _db.insert(cartTableName, cartData);
      } else {
        return await _db.update(cartTableName, cartData,
            where: "ProductID=$productId");
      }
    }
  }

  Future<List<CartData>> getCartData() async {
    List<CartData> list = [];
    _db = await _createDatabase();
    List<Map<String, dynamic>> lstCart = await _db.rawQuery(
        "SELECT c.ProductID,ProductName,SalePrice,PhotoUrl,Quantity FROM $cartTableName c LEFT JOIN $productTableName p ON c.ProductID=p.ProductID");
    for (int i = 0; i < lstCart.length; i++) {
      Map cart = lstCart[i];
      CartData data = CartData(
          productId: cart["ProductID"],
          quantity: cart["Quantity"],
          productName: cart["ProductName"],
          salePrice: cart["SalePrice"],
          photoUrl: cart["PhotoUrl"],
          amount: cart["Quantity"] * cart["SalePrice"]);
      list.add(data);
    }
    return list;
  }

  Future<int> deleteAllCart() async {
    _db = await _createDatabase();
    return await _db.rawDelete("DELETE FROM $cartTableName");
  }

  Future<int> getTotalCartItem() async {
    int result = 0;
    _db = await _createDatabase();
    List<Map<String, dynamic>> lstCart =
        await _db.rawQuery("SELECT Quantity FROM $cartTableName");
    for (int i = 0; i < lstCart.length; i++) {
      Map cart = lstCart[i];
      result += cart["Quantity"] as int;
    }
    return result;
  }

  Future<int> getTotalCartAmount() async {
    int result = 0;
    int quantity, salePrice;
    _db = await _createDatabase();
    List<Map<String, dynamic>> lstCart = await _db.rawQuery(
        "SELECT Quantity,SalePrice FROM $cartTableName c INNER JOIN $productTableName p ON c.ProductID=p.ProductID");
    for (int i = 0; i < lstCart.length; i++) {
      Map cart = lstCart[i];
      quantity = cart["Quantity"];
      salePrice = cart["SalePrice"];
      result += quantity * salePrice;
    }
    return result;
  }

  Future<int> deleteCart(int productId) async {
    _db = await _createDatabase();
    return await _db
        .rawDelete("DELETE FROM $cartTableName WHERE ProductID=$productId");
  }

  Future<String> insertOrder(List<CartData> lstData, int total) async {
    String orderNumber = "";

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    int? currentNumber = sharedPreferences.getInt("OrderNumber");
    currentNumber ??= 1;

    sharedPreferences.setInt("OrderNumber", currentNumber + 1);

    orderNumber = "#AP25800$currentNumber";

    _db = await _createDatabase();

    await _db.insert(orderMasterTableName, {
      "OrderNumber": orderNumber,
      "Day": DateFormat('d').format(DateTime.now()),
      "Month": DateFormat('M').format(DateTime.now()),
      "Year": DateFormat('y').format(DateTime.now()),
      "Total": total
    });

    List<Map<String, dynamic>> lstOrderID = await _db
        .rawQuery("SELECT Max(OrderID) AS OrderID FROM $orderMasterTableName");
    Map orderId = lstOrderID[0];
    int currentOrderId = orderId["OrderID"];

    for (dynamic i in lstData) {
      lstData[i].orderId = currentOrderId;
      Map<String, dynamic> orderData = lstData[i] as Map<String, dynamic>;

      await _db.insert(orderTableName, orderData);
    }

    return orderNumber;
  }

  Future<List<OrderData>> getOrder() async {
    List<OrderData> list = [];
    OrderData data;
    _db = await _createDatabase();
    List<Map<String, dynamic>> lstOrder = await _db.rawQuery(
        "SELECT OrderID,OrderNumber,Year,Month,Day,Total FROM $orderMasterTableName");
    for (int i = 0; i < lstOrder.length; i++) {
      int orderId = lstOrder[i]["OrderID"];
      String orderNumber = lstOrder[i]["OrderNumber"];
      String year = lstOrder[i]["Year"];
      String month = lstOrder[i]["Month"];
      String day = lstOrder[i]["Day"];
      int total = lstOrder[i]["Total"];

      List<Map<String, dynamic>> lstData = await _db.rawQuery(
          "SELECT ProductName,Quantity,SalePrice,PhotoUrl,Amount FROM $orderTableName WHERE OrderID=$orderId");

      List<CartData> lstCartData = [];
      for (int j = 0; j < lstOrder.length; j++) {
        lstCartData.add(CartData(
            productId: 0,
            quantity: (lstData[j]['Quantity'] as num).toInt(),
            productName: lstData[j]['ProductName'],
            salePrice: (lstData[j]['SalePrice'] as num).toInt(),
            amount: (lstData[j]['Amount'] as num).toInt()));
      }

      data = OrderData(
          ClientID: 0,
          CustomerID: 0,
          Subtotal: 0,
          Tax: 0,
          TaxAmt: 0,
          Charges: 0,
          ChargesAmt: 0,
          Total: total,
          Remark: '',
          lstSaleOrderTran: lstCartData,
          OrderNumber: orderNumber,
          Year: year,
          Month: month,
          Day: day);
      list.add(data);
    }
    return list;
  }

  Future<List<OrderData>> getEmptyOrder() async {
    List<OrderData> list = [];
    return list;
  }
}
