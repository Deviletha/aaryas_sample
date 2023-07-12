import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/ApiHelper.dart';

class Category_View extends StatefulWidget {
  final String itemname;
  final String description;
  final String price;
  final String url;
  final int id;

  const Category_View({
    Key? key,
    required this.itemname,
    required this.description,
    required this.price,
    required this.url,
    required this.id,
  }) : super(key: key);

  @override
  State<Category_View> createState() => _Category_ViewState();
}

class _Category_ViewState extends State<Category_View> {
  String? base = "https://aryaas.hawkssolutions.com/basicapi/public/";
  List<dynamic>? prcategorylist;
  List<dynamic>? wscategorylist;
  bool isLoading = false;
  String? UID;
  String? data;

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    UID = prefs.getString("UID");
    print(UID);
  }


  addTowishtist(String id, String combination) async {
    var response = await ApiHelper().post(
      endpoint: "wishList/add",
      body: {
        "userid": UID,
        "productid": id,
        "combination": combination,
      },
    ).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('addwishlist api successful:');
        data = response.toString();
        wscategorylist = jsonDecode(data!) as List<dynamic>?;

        Fluttertoast.showToast(
          msg: "Added to Wishlist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } else {
      debugPrint('Add to wishlist failed:');
      Fluttertoast.showToast(
        msg: "Add to wishlist failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }


  ApiforProductsBycategory() async {
    var response = await ApiHelper().post(
      endpoint: "categories/getProducts",
      body: {
        "table": "products",
        "id": widget.id.toString(),
      },
    ).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('get products api successful:');
        prcategorylist = jsonDecode(response) as List<dynamic>?;
        Fluttertoast.showToast(
          msg: "Success",
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
  void initState() {
    super.initState();
    ApiforProductsBycategory();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.itemname,
          style: TextStyle(
            color: Colors.teal[900],
            fontWeight: FontWeight.bold,
          ),
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
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: prcategorylist?.length ?? 0,
                  itemBuilder: (context, index) => getCatView(index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getCatView(int index) {
    var image = base! + prcategorylist![index]["image"].toString();
    var PID = prcategorylist![index]["id"].toString();
    var CombID = prcategorylist![index]["combinationId"].toString();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox.fromSize(
                size: Size.fromRadius(90),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              prcategorylist == null
                  ? 'Loading...'
                  : prcategorylist![index]["name"].toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              prcategorylist == null
                  ? 'Loading...'
                  :  prcategorylist![index]["price"].toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              prcategorylist == null
                  ? 'Loading...'
                  : prcategorylist![index]["description"].toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ElevatedButton(
                onPressed: () {
                  addTowishtist(PID, CombID);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shadowColor: Colors.teal[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                ),
                child: Icon(Icons.favorite_sharp),
              ),
            )
          ],
        ),
      ),
    );
  }
}
