import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Config/ApiHelper.dart';
import '../Config/image_url_const.dart';
import '../theme/colors.dart';
import 'orders/orders_page.dart';

class PlaceOrder extends StatefulWidget {
  final String id;

  const PlaceOrder({Key? key, required this.id}) : super(key: key);

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  String? uID;
  Map? order;
  Map? orderList;
  List? finalOrderList;

  final tipController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uID = prefs.getString("UID");
      print("usee id " + uID!);
      apiForCart();
    });
  }

  bool isLoading = true;

  placeOrderApi() async {
    var response = await ApiHelper().post(endpoint: "cart/placeOrder", body: {
      "id": uID,
      "address": widget.id,
      "amount": " ",
      "paid": "1",
      "latitude": "1234",
      "longitude": "1234",
      "delivery_note": noteController.text,
      "tip": tipController.text
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('place order api successful:');
        print(response);
        Fluttertoast.showToast(
          msg: "Order Placed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyOrders(),
        ),
      );
    } else {
      debugPrint('place order api failed:');
    }
  }

  Map? cList;
  List? cartAddList;

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Checkout"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          blurRadius: 3,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    children: [
                      isLoading
                          ? CircularProgressIndicator()
                          : ListView.builder(
                              itemCount:
                                  cartAddList == null ? 0 : cartAddList?.length,
                              itemBuilder: (context, index) =>
                                  getCartList(index),
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                            ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: TextFormField(
                          controller: noteController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Add Additional Delivery Instructions",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter delivery note';
                            } else {
                              return null;
                            }
                          },
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade500,
                        blurRadius: 3,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: const [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Subtotal",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          Text(
                            "Rs.335.00",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery Charges",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            "Rs.0.00",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery Charges",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            "Rs.0.00",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery Charges",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            "Rs.0.00",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery Charges",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            "Rs.0.00",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Subtotal",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          Text(
                            "Rs.335.00",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade500,
                        blurRadius: 3,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: tipController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Tip (if any)",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'tip';
                      } else {
                        return null;
                      }
                    },
                    textInputAction: TextInputAction.done,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    placeOrderApi();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(ColorT.themeColor),
                    shadowColor:Color(ColorT.themeColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10),
                      ),
                    ),
                  ),
                  child: Text("Place Order"),
                ),
              ),
            ],
          ),
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
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(10), // Image border
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(30), // Image radius
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cartAddList == null
                        ? Text("null data")
                        : Text(
                            cartAddList![index]["product"].toString(),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
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
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  // crossAxisAlignment: WrapCrossAlignment.center,
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
                          size: 30,
                        )),
                    Card(
                      color: Colors.grey.shade700,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 8, bottom: 8),
                        child: Text(
                          cartAddList![index]["quantity"].toString(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
                          size: 30,
                        )),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
