import 'package:order_app/model/cart_data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/product_data.dart';

class DatabaseHelper {
  late Database _db;
  static const String productTableName = "Product";
  static const String cartTableName = "Cart";

  Future<Database> _createDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, "order.db");
    _db = await openDatabase(path);
    await _db.execute(
        "CREATE TABLE IF NOT EXISTS $productTableName(ProductID INTEGER,SubMenuID INTEGER,Code TEXT,ProductName TEXT,SalePrice INTEGER,Description TEXT,PhotoUrl TEXT)");
    await _db.execute(
        "CREATE TABLE IF NOT EXISTS $cartTableName(ProductID INTEGER,Quantity INTEGER)");
    return _db;
  }

  Future<int> insertProduct(Map<String, dynamic> productData) async {
    _db = await _createDatabase();
    return await _db.insert(productTableName, productData);
  }

  Future<List<ProductData>> getProduct(int subMenuId,bool isSearch,[String? searchValue]) async {
    List<ProductData> list = [];
    _db = await _createDatabase();
    List<Map<String, dynamic>> lstProduct;
    if(!isSearch){
      if (subMenuId == 0) {
      lstProduct = await _db.rawQuery(
          "SELECT p.ProductID,SubMenuID,Code,ProductName,SalePrice,Description,PhotoUrl,Quantity FROM $productTableName p LEFT JOIN $cartTableName c ON p.ProductID=c.ProductID");
      } else {
        lstProduct = await _db.rawQuery(
            "SELECT p.ProductID,SubMenuID,Code,ProductName,SalePrice,Description,PhotoUrl,Quantity FROM $productTableName p LEFT JOIN $cartTableName c ON p.ProductID=c.ProductID WHERE SubMenuID=$subMenuId");
      }
    }else{
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
    int quantity=cartData["Quantity"];
    if(quantity==0){
      return await _db.rawDelete("DELETE FROM $cartTableName WHERE ProductID=$productId");
    }else{
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
    List<Map<String, dynamic>> lstCart = await _db.rawQuery("SELECT c.ProductID,ProductName,SalePrice,PhotoUrl,Quantity FROM $cartTableName c LEFT JOIN $productTableName p ON c.ProductID=p.ProductID");
    for (int i = 0; i < lstCart.length; i++) {
      Map cart = lstCart[i];
      CartData data = CartData(
          productId: cart["ProductID"],
          quantity: cart["Quantity"],
          productName: cart["ProductName"],
          salePrice: cart["SalePrice"],
          photoUrl: cart["PhotoUrl"],
          amount: cart["Quantity"]*cart["SalePrice"]);
      list.add(data);
    }
    return list;
  }

  Future<int> deleteAllCart() async {
    _db = await _createDatabase();
    return await _db.rawDelete("DELETE FROM $cartTableName");
  }

  Future<int> getTotalCartItem() async {
    int result=0;
    _db = await _createDatabase();
    List<Map<String, dynamic>> lstCart = await _db.rawQuery("SELECT Quantity FROM $cartTableName");
    for (int i = 0; i < lstCart.length; i++) {
      Map cart = lstCart[i];
      result+=cart["Quantity"] as int;
    }
    return result;
  }

  Future<int> getTotalCartAmount() async {
    int result=0;
    int quantity,salePrice;
    _db = await _createDatabase();
    List<Map<String, dynamic>> lstCart = await _db.rawQuery("SELECT Quantity,SalePrice FROM $cartTableName c INNER JOIN $productTableName p ON c.ProductID=p.ProductID");
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
    return await _db.rawDelete("DELETE FROM $cartTableName WHERE ProductID=$productId");
  }

}
