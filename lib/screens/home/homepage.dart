import 'dart:async';
import 'dart:convert';
import 'package:aaryas_sample/Config/ApiHelper.dart';
import 'package:aaryas_sample/constants/title_widget.dart';
import 'package:aaryas_sample/screens/home/widgets/category_card.dart';
import 'package:aaryas_sample/screens/home/widgets/popular_item_card.dart';
import 'package:aaryas_sample/screens/home/widgets/recent_order_card.dart';
import 'package:aaryas_sample/screens/home/widgets/top_pick_card.dart';
import 'package:aaryas_sample/screens/home/widgets/viewcart_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Config/image_url_const.dart';
import '../../theme/colors.dart';
import '../cartpage/cart_page.dart';
import '../product_view/product_view.dart';
import 'notification_page.dart';
import '../orders/order_details.dart';
import 'search_page.dart';
import 'category_view.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? uID;

  bool isLoading = false;

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uID = prefs.getString("UID");
    });
    getMyOrders();
    apiForCart();
    apiForWishlist();
  }

  ///OrderList
  Map? order;
  Map? order1;
  List? orderList;

  ///CategoryList
  List? categoryList;

  ///ProductList
  String? data;
  Map? productList;
  Map? productList1;
  List? finalProductList;

  ///PopularProductList
  Map? popularList;
  Map? popularList1;
  List? finalPopularList;

  Map? cList;
  List? cartList;

  apiForCart() async {
    var response = await ApiHelper().post(endpoint: "cart/get", body: {
      "userid": uID,
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('cartpage successful:');
        cList = jsonDecode(response);
        cartList = cList!["cart"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  getMyOrders() async {
    var response =
        await ApiHelper().post(endpoint: "common/getMyOrders", body: {
      "userid": uID,
      "offset": "0",
      "pageLimit": "20",
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('get address api successful:');
        order = jsonDecode(response);
        order1 = order!["data"];
        orderList = order1!["pageData"];
      });
    } else {
      debugPrint('API failed');
    }
  }

  apiForCategory() async {
    setState(() {
      isLoading = true;
    });

    var response = await ApiHelper().post(endpoint: "categories", body: {
      "offset": "0",
      "pageLimit": "5",
      "table": "categories"
    }).catchError((err) {});

    setState(() {
      Timer(const Duration(seconds: 3), () {
        isLoading = false;
      });
    });
    if (response != null) {
      setState(() {
        debugPrint('get products api successful:');
        categoryList = jsonDecode(response);
      });
    } else {
      debugPrint('api failed:');
    }
  }

  apiForAllProducts() async {
    setState(() {
      isLoading = true;
    });

    var response =
        await ApiHelper().post(endpoint: "products/ByCombination", body: {
      "offset": "0",
      "pageLimit": "50",
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('get products api successful:');
        data = response.toString();
        productList = jsonDecode(response);
        productList1 = productList!["pagination"];
        finalProductList = productList1!["pageData"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  apiForPopularProducts() async {
    setState(() {
      isLoading = true;
    });

    var response =
        await ApiHelper().post(endpoint: "products/ByCombination", body: {
      "offset": "0",
      "pageLimit": "8",
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('get products api successful:');
        data = response.toString();
        popularList = jsonDecode(response);
        popularList1 = popularList!["pagination"];
        finalPopularList = popularList1!["pageData"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  Map? prList;
  Map? prList1;
  List? finalPrList;

  Future<void> apiForWishlist() async {
    var response = await ApiHelper().post(endpoint: "wishList/get", body: {
      "userid": uID,
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('wishlist api successful:');
        prList = jsonDecode(response);
        prList1 = prList!["pagination"];
        finalPrList = prList1!["pageData"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  Future<void> removeFromWishlist(String id) async {
    var response = await ApiHelper().post(endpoint: "wishList/removeByProduct", body: {
      "userid" : uID,
      "productid": id,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('Remove api successful:');
        apiForWishlist();

        Fluttertoast.showToast(
          msg: "Removed product",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } else {
      debugPrint('api failed:');
    }
  }

  bool isInWishlist = false; // Add this variable

  addToWishlist(String id, String combination) async {
    var response = await ApiHelper().post(
      endpoint: "wishList/add",
      body: {
        "userid": uID,
        "productid": id,
        "combination": combination,
      },
    ).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('add wishlist api successful:');
        apiForWishlist();

        Fluttertoast.showToast(
          msg: "Added to Wishlist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        isInWishlist = true; // Set isInWishlist to true
      });
    } else {
      debugPrint('Add to wishlist failed:');
    }
  }

  @override
  void initState() {
    apiForCategory().then((_) {
      apiForAllProducts();
      apiForPopularProducts();
      checkUser();
    });

    super.initState();
  }

  apiForAddCart(String id, String pName, String amount, String tax,
      String category, String psize, String combinationId) async {
    var response = await ApiHelper().post(endpoint: "cart/add", body: {
      "userid": uID,
      "productid": id,
      "product": pName,
      "price": amount,
      "quantity": "1",
      "tax": tax,
      "category": category,
      "size": "size",
      "psize": psize,
      "pcolor": "pcolor",
      "combination": combinationId
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('add to art api successful:');

        Fluttertoast.showToast(
          msg: "Item added to Cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } else {
      debugPrint('api failed:');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 70,
        leadingWidth: 200,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ARYAS",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "Chembumukku",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),
              )
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Notifications();
                    },
                  )),
              icon: Icon(
                Icons.notifications_outlined,
                color: Colors.black45,
              )),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      bottomNavigationBar: Visibility(
        visible: cartList != null && cartList!.isNotEmpty,
        child: ViewCartTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CartPage()), // Replace with your cart page
            );
          },
        ),
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return Search();
                    }),
                  ),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Search for restaurants and food",
                          style: TextStyle(
                              fontSize: 15, color: Colors.grey.shade800),
                        ),
                        Icon(Iconsax.search_normal)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: orderList != null && orderList!.isNotEmpty,
            child: Column(
              children: [
                Heading(text: "Recent Orders"),
                Container(
                  child: isLoading
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                1, // Set a fixed count for shimmer effect
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                height: 100, // Adjust the height as needed
                              );
                            },
                          ),
                        )
                      : ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: orderList == null ? 0 : 1,
                          itemBuilder: (context, index) => getOrderList(index),
                        ),
                ),
              ],
            ),
          ),
          const Heading(text: "Category"),
          Container(
            child: isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CarouselSlider.builder(
                      itemCount: 5, // Set a fixed count for shimmer effect
                      itemBuilder: (context, index, realIndex) {
                        return getCategoryRow(index);
                      },
                      options: CarouselOptions(
                        height: 350,
                        aspectRatio: 15 / 6,
                        viewportFraction: .6,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        onPageChanged: (index, reason) {},
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  )
                : CarouselSlider.builder(
                    itemCount: categoryList == null ? 0 : categoryList?.length,
                    itemBuilder: (context, index, realIndex) {
                      return getCategoryRow(index);
                    },
                    options: CarouselOptions(
                      height: 350,
                      aspectRatio: 12 / 6,
                      viewportFraction: .75,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: false,
                      enlargeCenterPage: false,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      onPageChanged: (index, reason) {},
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
          ),
          SizedBox(
            height: 10,
          ),
          Heading(text: "Popular Items"),
          Container(
            child: isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: 8,
                      // Set a fixed count for shimmer effect
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        );
                      },
                    ),
                  )
                : GridView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.2,
                    ),
                    itemCount:
                        finalPopularList == null ? 0 : finalPopularList?.length,
                    itemBuilder: (context, index) => getPopularRow(index),
                  ),
          ),
          const Heading(text: "Top Picks For You"),
          Container(
              child: isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CarouselSlider.builder(
                        itemCount:
                            categoryList == null ? 0 : categoryList?.length,
                        itemBuilder: (context, index, realIndex) {
                          return getCategoryRow(index);
                        },
                        options: CarouselOptions(
                          height: 200,
                          aspectRatio: 15 / 6,
                          viewportFraction: .55,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: false,
                          enlargeCenterPage: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          onPageChanged: (index, reason) {},
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    )
                  : CarouselSlider.builder(
                      itemCount:
                          categoryList == null ? 0 : categoryList?.length,
                      itemBuilder: (context, index, realIndex) {
                        return getCategoryImage(index);
                      },
                      options: CarouselOptions(
                        height: 200,
                        aspectRatio: 15 / 6,
                        viewportFraction: .85,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        enlargeCenterPage: false,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        onPageChanged: (index, reason) {},
                        scrollDirection: Axis.horizontal,
                      ),
                    )),
          const Heading(text: "Today's Featured"),
          Container(
            child: isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 10, // Set a fixed count for shimmer effect
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          height: 100, // Adjust the height as needed
                        );
                      },
                    ),
                  )
                : ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        finalProductList == null ? 0 : finalProductList?.length,
                    itemBuilder: (context, index) => getProducts(index),
                  ),
          ),
        ],
      ),
    );
  }

  void _showDetailsBottomSheet(Map<String, dynamic> itemDetails) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        var image = UrlConstants.base + itemDetails["image"].toString();

        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 250,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CachedNetworkImage(
                  imageUrl: image,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/aryas_logo.png",
                            ),
                            colorFilter: ColorFilter.mode(
                                Colors.grey, BlendMode.color))),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        apiForAddCart(
                            itemDetails["id"].toString(),
                            itemDetails["combinationName"].toString(),
                            itemDetails["combinationPrice"].toString(),
                            "",
                            itemDetails["category"].toString(),
                            itemDetails["combinationSize"].toString(),
                            itemDetails["combinationId"].toString());
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          )),
                      child: Text("ADD")),
                ],
              ),
              SizedBox(height: 10),
              Text(
                itemDetails["combinationName"].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Text(
                itemDetails["description"].toString(),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "₹ ${itemDetails["combinationPrice"]}",
                style: TextStyle(
                  color: Color(ColorT.themeColor),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Add more details as needed
            ],
          ),
        );
      },
    );
  }

  Widget getPopularRow(int index) {
    var image = UrlConstants.base + finalPopularList![index]["image"];
    var itemName = finalPopularList![index]["combinationName"].toString();
    return PopularItemTile(
      onTap: () {
        _showDetailsBottomSheet(finalPopularList![index]);
      },
      imagePath: image,
      itemName: itemName,
    );
  }

  Widget getCategoryImage(int index) {
    if (categoryList == null) {
      return Container();
    }
    var image = UrlConstants.base + categoryList![index]["image"];

    return TopPicksTile(
      imagePath: image,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryView(
              itemname: categoryList![index]["name"].toString(),
              id: categoryList![index]["id"],
            ),
          ),
        );
      },
    );
  }

  Widget getCategoryRow(int index) {
    if (categoryList == null) {
      return Container(); // Handle the case when categoryList is null
    }
    var image = UrlConstants.base + categoryList![index]["image"];
    var itemName = categoryList![index]["name"].toString();

    return CategoryTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryView(
              itemname: categoryList![index]["name"].toString(),
              id: categoryList![index]["id"],
            ),
          ),
        );
      },
      itemName: itemName,
      description: categoryList![index]["description"].toString(),
      imagePath: image,
    );
  }

  Widget getProducts(int index) {
    var image = UrlConstants.base + finalProductList![index]["image"];
    var price = "₹${finalProductList![index]["combinationPrice"]}";
    var pID = finalProductList![index]["id"].toString();
    var combID = finalProductList![index]["combinationId"].toString();

    // Check if the current item is in the wishlist
    bool isInWishlist = finalPrList != null &&
        finalPrList!.any((item) => item["combinationId"].toString() == combID);

    return Card(
      child: InkWell(
        onTap: () {
          // _showDetailsBottomSheet(finalProductList![index]);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductView(
                position: index,
                id: finalProductList![index]["id"].toString(),
                productName:
                    finalProductList![index]["combinationName"].toString(),
                url: image,
                description: finalProductList![index]["description"].toString(),
                amount: finalProductList![index]["combinationPrice"].toString(),
                combinationId:
                    finalProductList![index]["combinationId"].toString(),
                quantity: finalProductList![index]["quantity"].toString(),
                category: finalProductList![index]["category"].toString(),
                psize: finalProductList![index]["combinationSize"].toString(),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                height: 150,
                width: 150,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CachedNetworkImage(
                  imageUrl: image,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/aryas_logo.png",
                            ),
                            colorFilter: ColorFilter.mode(
                                Colors.grey, BlendMode.color))),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    finalProductList == null
                        ? Text("null data")
                        : Text(
                            finalProductList![index]["combinationName"]
                                .toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      finalProductList![index]["description"].toString(),
                      maxLines: 2,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          price,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(ColorT.themeColor)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            pID = finalProductList![index]["id"].toString();
                            combID = finalProductList![index]["combinationId"]
                                .toString();
                            if (isInWishlist) {
                              removeFromWishlist(pID);
                            } else {
                              addToWishlist(pID, combID);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shadowColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              )),
                          child: Row(
                            children: [
                              Text(
                                "FAV",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              isInWishlist
                                  ? Icon(
                                      Iconsax.heart5,
                                      color: Colors.white,
                                      // Change icon color based on isInWishlist
                                      size: 17,
                                    )
                                  : Icon(
                                      Iconsax.heart,
                                      color: Colors.white,
                                      // Change icon color based on isInWishlist
                                      size: 17,
                                    )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getOrderList(int index) {
    var image = UrlConstants.base + orderList![index]["image"].toString();
    return RecentOrdersTile(
      itemName: orderList![index]["cartName"].toString(),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetails(
              id: orderList![index]["id"].toString(),
            ),
          ),
        );
      },
      imagePath: image,
    );
  }
}
