import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order_app/api/apiservice.dart';
import 'package:order_app/controller/product_controller.dart';
import 'package:order_app/database/database_helper.dart';
import 'package:order_app/widget/action_bar_view.dart';
import 'package:order_app/widget/small_text.dart';
import 'package:order_app/widget/title_text.dart';

import '../../model/menu_data.dart';
import '../../model/product_data.dart';
import '../../value/app_color.dart';
import '../../value/app_setting.dart';
import '../../value/app_string.dart';
import '../../widget/add_product_dialog.dart';
import '../../widget/regular_text.dart';

class ProductPage extends StatefulWidget {
  final int clientId;
  final int subMenuId;
  final String subMenu;

  const ProductPage(
      {super.key,
      required this.clientId,
      required this.subMenuId,
      required this.subMenu});

  @override
  State<ProductPage> createState() =>
      _ProductPageState(clientId, subMenuId, subMenu);
}

class _ProductPageState extends State<ProductPage> {
  ApiService apiService = Get.find();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String _subMenu = AppString.all_product;
  final ProductController productController = Get.put(ProductController());
  int _subMenuId = 0;
  final int clientId;
  bool _isShowRefresh = false, _isSearch = false;
  String _searchValue = "";
  TextEditingController search_controller = new TextEditingController();

  _ProductPageState(this.clientId, this._subMenuId, this._subMenu);

  @override
  void initState() {
    super.initState();
  }

  void _reloadData(
      {required int subMenuId,
      required String subMenuName,
      required bool isSearch,
      String? searchValue}) {
    setState(() {
      _subMenu = subMenuName;
      _subMenuId = subMenuId;
      _isSearch = isSearch;
      if (searchValue != null) _searchValue = searchValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          key: _key,
          body: SafeArea(
            child: Column(
              children: [
                ActionBarView(
                  clientId: clientId,
                  pageTitle: AppString.product,
                ),
                Container(
                  height: 1,
                  color: AppColor.primary_800,
                ),
                Container(
                  color: AppColor.primary_700,
                  child: Container(
                    margin: EdgeInsets.only(right: 5),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: search_controller,
                            cursorColor: AppColor.accent,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.search,
                            onTap: () {
                              print("on tap");
                            },
                            onChanged: (value) {
                              setState(() {
                                if (value.isNotEmpty) {
                                  _isShowRefresh = true;
                                } else {
                                  _isShowRefresh = false;
                                }
                              });
                            },
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _reloadData(
                                    subMenuId: 0,
                                    subMenuName: "${AppString.search} $value",
                                    isSearch: true,
                                    searchValue: value);
                              } else {
                                _reloadData(
                                    subMenuId: 0,
                                    subMenuName: AppString.all_product,
                                    isSearch: false);
                              }
                            },
                            style: TextStyle(color: AppColor.white),
                            decoration: InputDecoration(
                              hintText: AppString.search,
                              hintStyle: TextStyle(color: AppColor.white),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.lightBlue,
                              ),
                              suffixIcon: _isShowRefresh
                                  ? IconButton(
                                      onPressed: () {
                                        search_controller.text = "";
                                        setState(() {
                                          _isShowRefresh = false;
                                        });
                                        _reloadData(
                                            subMenuId: 0,
                                            subMenuName: AppString.all_product,
                                            isSearch: false);
                                      },
                                      icon: const Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                      ))
                                  : Container(),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _key.currentState!.openEndDrawer(); //<-- SEE HERE
                          },
                          icon: const Icon(Icons.menu),
                          color: AppColor.white,
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_subMenu,style:Theme.of(context).textTheme.bodyText1),
                    /* SmallText(
                      text: _subMenu,
                      color: Colors.black87,
                    ), */
                  ),
                ),
                Expanded(
                    child: FutureBuilder<List<ProductData>>(
                        future: DatabaseHelper()
                            .getProduct(_subMenuId, _isSearch, _searchValue),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            productController.getRxProduct(snapshot.data!);
                            return _productList();
                          } else if (snapshot.hasError) {
                            return RegularText(text: snapshot.error.toString());
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        }))
              ],
            ),
          ),
          endDrawer: FutureBuilder<List<MenuData>>(
              future: apiService.getMenu(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<MenuData> menu = snapshot.data!;
                  return _drawer(menu);
                } else if (snapshot.hasError) {
                  return RegularText(text: snapshot.error.toString());
                }
                return const Center(child: CircularProgressIndicator());
              })),
    );
  }

  Widget _productList() {
    return ListView.builder(
        itemCount: productController.lstRxProduct.length,
        itemBuilder: (BuildContext context, int index) {
          ProductData item = productController.lstRxProduct[index];
          return Card(
            child: ListTile(
              onTap: () => _productDetailDialog(item),
              leading: Obx(() =>
                  productController.lstRxProduct[index].Quantity == null ||
                          productController.lstRxProduct[index].Quantity == 0
                      ? Image.asset("assets/images/logo.png")
                      : Badge(
                          badgeContent: Obx(() => Text(
                              productController.lstRxProduct[index].Quantity
                                  .toString(),
                              style: TextStyle(color: AppColor.white))),
                          badgeColor: AppColor.primary,
                          elevation: 0,
                          child: Image.asset("assets/images/logo.png"),
                        )),
              title: Text(item.ProductName.toString()),
              subtitle: item.SalePrice.toString().length > 3
                  ? Text(AppSetting.formatter.format(item.SalePrice).toString())
                  : Text(item.SalePrice.toString()),
              trailing: IconButton(
                onPressed: () {
                  _addProductDialog(index, item);
                },
                icon: const Icon(
                  Icons.add_circle,
                  color: AppColor.accent,
                ),
                iconSize: 35.0,
              ),
            ),
          );
        });
  }

  Future<void> _productDetailDialog(ProductData data) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(AppString.product_detail),
            content: SingleChildScrollView(
                child: ListBody(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TitleText(
                          text: data.ProductName.toString(),
                          color: AppColor.primary,
                        ),
                        const SizedBox(height: 10),
                        data.SalePrice.toString().length > 3
                            ? Text( AppSetting.formatter
                                    .format(data.SalePrice)
                                    .toString(),style:Theme.of(context).textTheme.headline6)                           
                            : Text( data.SalePrice.toString(),style:Theme.of(context).textTheme.headline6)                         
                      ],
                    ),
                    Flexible(child: Image.asset("assets/images/logo.png"))
                  ],
                ),
                Text( data.Description.toString(),style:Theme.of(context).textTheme.bodyText1)             
              ],
            )),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    AppString.close,
                    style: TextStyle(color: Colors.blueGrey),
                  )),
            ],
          );
        });
  }

  Widget _drawer(List<MenuData> data) {
    return Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(AppString.categories,style:Theme.of(context).textTheme.headline6),                
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return _buildMenuList(data[index]);
                  },
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildMenuList(MenuData list) {
    if (list.subMenu!.isEmpty) {
      return Builder(builder: (context) {
        return ListTile(
            onTap: () {
              _reloadData(
                  subMenuId: list.id!,
                  subMenuName: list.name.toString(),
                  isSearch: false);
              _key.currentState!.closeEndDrawer();
            },
            leading: const SizedBox(width: 10),
            title: Text(list.name.toString()));
      });
    } else {
      return ExpansionTile(
        leading: const Icon(Icons.arrow_drop_down),
        title: Text(list.name.toString()),
        children: list.subMenu!.map(_buildMenuList).toList(),
      );
    }
  }

  Future<void> _addProductDialog(int index, ProductData data) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AddProductDialog(index: index, data: data);
        });
  }
}
