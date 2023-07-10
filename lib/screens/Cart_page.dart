import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Config/ApiHelper.dart';
import 'Login_page.dart';

class Cart_page extends StatefulWidget {
  const Cart_page({Key? key}) : super(key: key);

  @override
  State<Cart_page> createState() => _Cart_pageState();
}

class _Cart_pageState extends State<Cart_page> {
  String? base = "https://aryaas.hawkssolutions.com/basicapi/public/";
  Map? clist;
  List? CartaddList;
  Map? order;
  Map? orderlist;
  List? FinalOrderlist;
  int index = 0;
  var CID;
  String? UID;
  bool isLoading = true;
  bool isLoggedIn = false;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    UID = prefs.getString("UID");
    print(UID);
    setState(() {
      isLoggedIn = UID != null;
    });
    if (isLoggedIn) {
      APIforCart();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  APIforCart() async {
    setState(() {
      isLoading = true;
    });

    var response = await ApiHelper().post(endpoint: "cart/get", body: {
      "userid": UID,
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('cartpage successful:');
        clist = jsonDecode(response);
        CartaddList = clist!["cart"];

        Fluttertoast.showToast(
          msg: "cartpage success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } else {
      debugPrint('api failed:');
      Fluttertoast.showToast(
        msg: "cartpage loading failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  incrementQty(
    String productID,
    String Size,
  ) async {
    var response = await ApiHelper().post(endpoint: "cart/increment", body: {
      "userid": UID,
      "productid": productID,
      "size": Size,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('cartpage successful:');
        clist = jsonDecode(response);
        CartaddList = clist!["cart"];

        Fluttertoast.showToast(
          msg: "increased count",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } else {
      debugPrint('api failed:');
      Fluttertoast.showToast(
        msg: "failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  decrementQty(String productId, String size) async {
    var response = await ApiHelper().post(endpoint: "cart/decrement", body: {
      "userid": UID,
      "productid": productId,
      "size": size,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('cartpage successful:');
        clist = jsonDecode(response);
        CartaddList = clist!["cart"];

        Fluttertoast.showToast(
          msg: "decreased count",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } else {
      debugPrint('api failed:');
      Fluttertoast.showToast(
        msg: "failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  removeFromCart(String productId, String size) async {
    var response = await ApiHelper().post(endpoint: "cart/remove", body: {
      "userid": UID,
      "productid": productId,
      "size": size,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('cartpage successful:');
        clist = jsonDecode(response);
        CartaddList = clist!["cart"];

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
      Fluttertoast.showToast(
        msg: "failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  PlaceOrderApi() async {
    var response = await ApiHelper().post(endpoint: "cart/placeOrder", body: {
      "id": UID,
      "address": "address",
      "amount": "amount",
      "paid": "paid",
      "latitude": "latitude",
      "longitude": "longitude",
      "delivery_note": "delivery_note",
      "tip" : "tip"
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('place order api successful:');
        order = jsonDecode(response);
        orderlist = order!["data"];
        FinalOrderlist = orderlist!["pageData"];

        Fluttertoast.showToast(
          msg: "Order Placed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } else {
      debugPrint('api failed:');
      Fluttertoast.showToast(
        msg: "failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("MY CART",style:
        TextStyle(color: Colors.teal[900], fontWeight: FontWeight.bold),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoggedIn
          ? isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .5,
        ),
        itemCount: CartaddList == null ? 0 : CartaddList?.length,
        itemBuilder: (context, index) => getCartList(index),
      )
          : Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset("assets/img_1.png"),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage())
                );
              },style: ElevatedButton.styleFrom(
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
    var image = base! + CartaddList![index]["image"];
    int quantity = CartaddList![index]["quantity"];
    int price = CartaddList![index]["price"];
    int totalamount = quantity * price;
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
            CartaddList == null
                ? Text("null data")
                : Text(
                    CartaddList![index]["product"].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
            SizedBox(
              height: 10,
            ),
            Text(
              totalamount.toString(),
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
                        CartaddList![index]["product_id"].toString(),
                        CartaddList![index]["size"].toString(),
                      );
                    },
                    icon: Icon(Icons.remove_circle_outline_rounded)),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      CartaddList![index]["quantity"].toString(),
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    )),
                IconButton(
                    onPressed: () {
                      incrementQty(
                        CartaddList![index]["product_id"].toString(),
                        CartaddList![index]["size"].toString(),
                      );
                    },
                    icon: Icon(Icons.add_circle_outline_rounded)),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  removeFromCart(
                    CartaddList![index]["product_id"].toString(),
                    CartaddList![index]["size"].toString(),
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
