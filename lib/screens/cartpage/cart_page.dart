import 'dart:convert';
import 'package:aaryas_sample/screens/cartpage/widgets/cart_card.dart';
import 'package:aaryas_sample/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/ApiHelper.dart';
import '../../Config/image_url_const.dart';
import '../registration/login_page.dart';
import '../place_order/select_address.dart';

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
    return CartTile(
      imagePath: image,
      price: totalAmount.toString(),
      quantity: quantity.toString(),
      itemName: cartAddList![index]["product"].toString(),
      onTap: () {
        removeFromCart(
          cartAddList![index]["product_id"].toString(),
          cartAddList![index]["size"].toString(),
        );
      },
      decrement: () {
        decrementQty(
          cartAddList![index]["product_id"].toString(),
          cartAddList![index]["size"].toString(),
        );
      },
      increment: () {
        incrementQty(
          cartAddList![index]["product_id"].toString(),
          cartAddList![index]["size"].toString(),
        );
      },
    );
  }
}
