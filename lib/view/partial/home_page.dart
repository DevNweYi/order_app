import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order_app/controller/notification_controller.dart';
import 'package:order_app/model/sub_menu_data.dart';
import 'package:order_app/value/app_constant.dart';
import 'package:order_app/value/app_string.dart';
import 'package:order_app/widget/action_bar_view.dart';
import 'package:order_app/widget/add_product_dialog.dart';
import 'package:order_app/widget/regular_text.dart';
import 'package:order_app/widget/small_text.dart';

import '../../api/apiservice.dart';
import '../../controller/product_controller.dart';
import '../../database/database_helper.dart';
import '../../model/product_data.dart';
import '../../value/app_color.dart';
import '../../value/app_setting.dart';
import '../main_page.dart';

class HomePage extends StatefulWidget {
  final int clientId;
  const HomePage({super.key, required this.clientId});

  @override
  State<HomePage> createState() => _HomePageState(clientId);
}

class _HomePageState extends State<HomePage> {
  final int clientId;
  ApiService apiService = Get.find();
  final ProductController productController = Get.put(ProductController());

  _HomePageState(this.clientId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          FutureBuilder<int>(
              future: apiService.getNotificationCount(clientId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  NotificationController.notificationCount.value =
                      snapshot.data!;
                  return ActionBarView(
                    clientId: clientId,
                    pageTitle: 'home'.tr,
                  );
                } else if (snapshot.hasError) {
                  return RegularText(text: snapshot.error.toString());
                }
                return const Center(child: CircularProgressIndicator());
              }),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _slider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SmallText(
                              text: 'categories'.tr,
                              color: AppColor.primary,
                              size: 16,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return MainPage(
                                    clientId: clientId,
                                    currentIndex: 1,
                                    subMenuId: 0,
                                    subMenu: 'ALL',
                                  );
                                }));
                              },
                              child: Text('see_all'.tr,
                                  style: Theme.of(context).textTheme.bodyText2),
                            )
                          ],
                        ),
                      ),
                      FutureBuilder<List<SubMenuData>>(
                          future: apiService.getSubMenu(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return _category(snapshot.data!);
                            } else if (snapshot.hasError) {
                              return RegularText(
                                  text: snapshot.error.toString());
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          })
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(5),
                        child: SmallText(
                          text: 'new_product'.tr,
                          color: AppColor.primary,
                          size: 16,
                        ),
                      ),
                      FutureBuilder<List<ProductData>>(
                          future: DatabaseHelper().getProduct(0, false),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<ProductData> lstProduct = snapshot.data!;
                              List<ProductData> reversedList =
                                  List.from(lstProduct.reversed);
                              productController.getRxProduct(reversedList);
                              return _newProduct();
                            } else if (snapshot.hasError) {
                              return RegularText(
                                  text: snapshot.error.toString());
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          })
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(5),
                        child: SmallText(
                          text: 'promotion_item'.tr,
                          color: AppColor.primary,
                          size: 16,
                        ),
                      ),
                      FutureBuilder<List<ProductData>>(
                          future: DatabaseHelper().getProduct(0, false),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return _promotion(snapshot.data!);
                            } else if (snapshot.hasError) {
                              return RegularText(
                                  text: snapshot.error.toString());
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          })
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }

  Widget _newProduct() {
    return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(4, (index) {
          ProductData item = productController.lstRxProduct[index];
          return InkWell(
            onTap: () {
              _addProductDialog(index, item);
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 100,
                    height: 100,
                  ),
                  Text(item.ProductName,style: TextStyle(fontSize: 16),),                 
                  SizedBox(
                    height: 5,
                  ),
                  item.SalePrice > 3
                      ? Text(                         
                              "${AppSetting.formatter.format(item.SalePrice)} ${AppConstant.currency}")
                      : Text(
                         "${item.SalePrice} ${AppConstant.currency}")
                ],
              ),
            ),
          );
        }));
  }

  Future<void> _addProductDialog(int index, ProductData data) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AddProductDialog(index: index, data: data);
        });
  }

  Widget _promotion(List<ProductData> lstProduct) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        primary: false,
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          ProductData data = lstProduct[index];
          return Card(
            child: ListTile(
              leading: Image.asset(
                "assets/images/logo.png",
                width: 50,
                height: 50,
              ),
              title: Text(data.ProductName),
              subtitle: Row(
                children: [
                  (data.SalePrice + 1000) > 3
                      ? Text(
                          "${AppSetting.formatter.format(data.SalePrice + 1000)} ${AppConstant.currency}",
                          style: const TextStyle(
                              decoration: TextDecoration.lineThrough),
                        )
                      : Text(
                          "${data.SalePrice + 1000} ${AppConstant.currency}"),
                  SizedBox(
                    width: 5,
                  ),
                  data.SalePrice > 3
                      ? Text(
                          "${AppSetting.formatter.format(data.SalePrice)} ${AppConstant.currency}",
                        )
                      : Text("${data.SalePrice} ${AppConstant.currency}"),
                ],
              ),
            ),
          );
        });
  }

  Widget _category(List<SubMenuData> lstSubMenu) {
    return SizedBox(
      height: 100,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        children: lstSubMenu.map((data) {
          return InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return MainPage(
                  clientId: clientId,
                  currentIndex: 1,
                  subMenuId: data.subMenuId,
                  subMenu: data.subMenuName,
                );
              }));
            },
            child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: AppColor.primary_50,
                ),
                margin: EdgeInsets.all(5),
                height: 120,
                width: 120,
                alignment: Alignment.center,
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 50,
                      width: 50,
                    ),
                    SmallText(
                      text: data.subMenuName,
                      textOverflow: TextOverflow.ellipsis,
                    )
                  ],
                )),
          );
        }).toList(),
      ),
    );
  }

  Widget _slider() {
    return ListView(
      shrinkWrap: true,
      children: [
        CarouselSlider(
          items: [
            //1st Image of Slider
            Container(
              margin: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage("assets/images/slide1.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            //2nd Image of Slider
            Container(
              margin: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage("assets/images/slide2.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            //3rd Image of Slider
            Container(
              margin: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage("assets/images/slide3.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),


            //4th Image of Slider
            Container(
              margin: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage("assets/images/slide4.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),


            //5th Image of Slider
            Container(
              margin: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage("assets/images/slide5.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),

          ],

          //Slider Container properties
          options: CarouselOptions(
            height: 200.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 0.8,
          ),
        ),
      ],
    );
  }
}
