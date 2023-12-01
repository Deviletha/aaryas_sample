import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Config/ApiHelper.dart';
import 'login_page.dart';
import 'select_address.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String? base = "https://aryaas.hawkssolutions.com/basicapi/public/";
  Map? cList;
  List? cartAddList;
  int index = 0;
  String? uID;
  bool isLoading = true;
  bool isLoggedIn = false;

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
    setState(() {
      isLoading = true;
    });

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
        debugPrint('cartpage successful:');
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
        debugPrint('cartpage successful:');
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
        debugPrint('cartpage successful:');

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
          "MY CART",
          style:
              TextStyle(color: Colors.teal[900], fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoggedIn
          ? isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                children: [
                  Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "${cartAddList!.length} Items in Cart",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                            onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return SelectAddress();
                                  }),
                                ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shadowColor: Colors.teal[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      topLeft: Radius.circular(10)),
                                )),
                            child: Text("Place Order"))
                      ],
                    ),
                  ),
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .5,
                    ),
                    itemCount:
                    cartAddList == null ? 0 : cartAddList?.length,
                    itemBuilder: (context, index) => getCartList(index),
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                  ),
                ],
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
                        backgroundColor: Colors.teal,
                        shadowColor: Colors.teal[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topLeft: Radius.circular(10)),
                        )),
                    child: Text(
                      "Please LogIn",
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget getCartList(int index) {
    var image = base! + cartAddList![index]["image"];
    int quantity = cartAddList![index]["quantity"];
    int price = cartAddList![index]["price"];
    int totalAmount = quantity * price;
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                borderRadius: BorderRadius.circular(20), // Image border
                child: SizedBox.fromSize(
                  size: Size.fromRadius(71), // Image radius
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            cartAddList == null
                ? Text("null data")
                : Text(
              cartAddList![index]["product"].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
            SizedBox(
              height: 10,
            ),
            Text(
              totalAmount.toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green),
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      decrementQty(
                        cartAddList![index]["product_id"].toString(),
                        cartAddList![index]["size"].toString(),
                      );
                    },
                    icon: Icon(Icons.remove_circle_outline_rounded)),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      cartAddList![index]["quantity"].toString(),
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    )),
                IconButton(
                    onPressed: () {
                      incrementQty(
                        cartAddList![index]["product_id"].toString(),
                        cartAddList![index]["size"].toString(),
                      );
                    },
                    icon: Icon(Icons.add_circle_outline_rounded)),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  removeFromCart(
                    cartAddList![index]["product_id"].toString(),
                    cartAddList![index]["size"].toString(),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shadowColor: Colors.teal[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                    )),
                child: Text(
                  "Remove Item",
                ))
          ],
        ),
      ),
    );
  }
}
