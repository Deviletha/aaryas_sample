import 'dart:convert';
import 'package:aaryas_sample/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Config/ApiHelper.dart';
import '../Config/image_url_const.dart';
import 'registration/login_page.dart';
import 'place_order/select_address.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Map? cList;
  List? cartAddList;
  int index = 0;
  String? uID;
  bool isLoading = true;
  bool isLoggedIn = true;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    uID = prefs.getString("UID");
    if (kDebugMode) {
      print(uID);
    }
    setState(() {
      isLoggedIn = uID != null;
    });
    if (isLoggedIn) {
      apiForCart();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

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
        cartAddList = cList!["cart"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  incrementQty(
    String productID,
    String size,
  ) async {
    var response = await ApiHelper().post(endpoint: "cart/increment", body: {
      "userid": uID,
      "productid": productID,
      "size": size,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('increment qty successful:');
        apiForCart();
      });
    } else {
      debugPrint('api failed:');
    }
  }

  decrementQty(String productId, String size) async {
    var response = await ApiHelper().post(endpoint: "cart/decrement", body: {
      "userid": uID,
      "productid": productId,
      "size": size,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('decrement qty successful:');
        apiForCart();
      });
    } else {
      debugPrint('api failed:');
    }
  }

  removeFromCart(String productId, String size) async {
    var response = await ApiHelper().post(endpoint: "cart/remove", body: {
      "userid": uID,
      "productid": productId,
      "size": size,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('remove from cart successful:');
        apiForCart();
        Fluttertoast.showToast(
          msg: "Item Removed",
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "My Cart",
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "${cartAddList?.length ?? 0} Cart items",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return SelectAddress();
                        }),
                      ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(ColorT.themeColor),
                      shadowColor: Color(ColorT.themeColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )),
                  child: Text("Place Order"))
            ],
          ),
        ),
      ),
      body: isLoggedIn
          ? isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Color(ColorT.themeColor),
        ),
      )
          : ListView.builder(
        itemCount: cartAddList == null ? 0 : cartAddList?.length,
        itemBuilder: (context, index) => getCartList(index),
        physics: ScrollPhysics(),
        shrinkWrap: true,
      )
          : Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset("assets/img_1.png"),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(ColorT.themeColor),
                shadowColor: Color(ColorT.themeColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: Text("Please Log In"),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCartList(int index) {
    var image = UrlConstants.base + cartAddList![index]["image"];
    int quantity = cartAddList![index]["quantity"];
    int price = cartAddList![index]["price"];
    int totalAmount = quantity * price;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  width: 120,
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
                              image: AssetImage("assets/aryas_logo.png",), colorFilter: ColorFilter.mode(Colors.grey, BlendMode.color))),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cartAddList == null
                        ? Text("null data")
                        : Text(
                            cartAddList![index]["product"].toString(),
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "₹$totalAmount",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              decrementQty(
                                cartAddList![index]["product_id"].toString(),
                                cartAddList![index]["size"].toString(),
                              );
                            },
                            icon: Icon(
                              Icons.remove_circle_outline_rounded,
                              size: 25,
                            )),
                        Card(
                          color: Colors.grey.shade700,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 8, bottom: 8),
                            child: Text(
                              cartAddList![index]["quantity"].toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              incrementQty(
                                cartAddList![index]["product_id"].toString(),
                                cartAddList![index]["size"].toString(),
                              );
                            },
                            icon: Icon(
                              Icons.add_circle_outline_rounded,
                              size: 25,
                            )),
                        IconButton(
                            onPressed: () {
                              removeFromCart(
                                cartAddList![index]["product_id"].toString(),
                                cartAddList![index]["size"].toString(),
                              );
                            },
                            icon: Icon(
                              Iconsax.trash,
                              color: Colors.red,
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
