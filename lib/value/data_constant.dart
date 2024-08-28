import '../model/menu_data.dart';
import '../model/product_data.dart';
import '../model/sub_menu_data.dart';

class DataConstant {
  static List<ProductData> getProduct() {
    List<ProductData> lstProduct = List.empty();

    ProductData data = ProductData(
        ProductID: 1,
        SubMenuID: 1,
        Code: '1',
        ProductName: 'Product1',
        SalePrice: 1000);
    lstProduct.add(data);

    return lstProduct;
  }

  static List<MenuData> getMenu() {
    List<MenuData> lstMenu = List.empty();

    List<MenuData> lstSubMenu = List.empty();
    MenuData subData = MenuData(id: 1, name: "");
    lstSubMenu.add(subData);
    subData = MenuData(id: 2, name: "");
    lstSubMenu.add(subData);
    MenuData data = MenuData(id: 1, name: "", subMenu: lstSubMenu);

    lstMenu.add(data);

    return lstMenu;
  }

  static List<SubMenuData> getSubMenu() {
    List<SubMenuData> lstSubMenu = List.empty();

    SubMenuData data=SubMenuData(subMenuId: 1, subMenuName: "");
    lstSubMenu.add(data);

    return lstSubMenu;
  }
}
