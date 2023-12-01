import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Config/ApiHelper.dart';
import 'login_page.dart';

class ProductView extends StatefulWidget {
  final String productName;
  final String url;
  final String description;
  final String amount;
  final String id;
  final String combinationId;
  final String quantity;
  final String category;
  final String psize;

  const ProductView(
      {Key? key,
      required this.productName,
      required this.url,
      required this.description,
      required this.amount,
      required this.id,
      required this.combinationId,
      required this.quantity,
      required this.category,
      required this.psize})
      : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  int index = 0;
  Map? cList;
  List? cartList;
  String? uID;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    uID = prefs.getString("UID");
  }

  apiForCart() async {
    var response = await ApiHelper().post(endpoint: "cart/add", body: {
      "userid": uID,
      "productid": widget.id.toString(),
      "product": widget.productName.toString(),
      "price": widget.amount.toString(),
      "quantity": "1",
      "tax": "tax",
      "category": widget.category.toString(),
      "size": "size",
      "psize": widget.psize.toString(),
      "pcolor": "pcolor",
      "combination": widget.combinationId.toString()
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('cartpage successful:');
        cList = jsonDecode(response);
        cartList = cList!["cart"];

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

  Future<void> checkLoggedIn(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginId = prefs.getString('UID');

    if (loginId != null && loginId.isNotEmpty) {
      // User is logged in, proceed with adding to cart
      apiForCart();
    } else {
      // User is not logged in, navigate to LoginPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productName,
          style:
              TextStyle(color: Colors.teal[900], fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10), // Image border
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(100), // Image radius
                      child: Image.network(widget.url, fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.amount.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.productName.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.description.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: ElevatedButton(
                      onPressed: () {
                        checkLoggedIn(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shadowColor: Colors.teal[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                          )),
                      child: Text("Add to Cart"),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
