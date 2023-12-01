import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/ApiHelper.dart';

class CategoryView extends StatefulWidget {
  final String itemname;
  final String description;
  final String price;
  final String url;
  final int id;

  const CategoryView({
    Key? key,
    required this.itemname,
    required this.description,
    required this.price,
    required this.url,
    required this.id,
  }) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  String? base = "https://aryaas.hawkssolutions.com/basicapi/public/";
  List<dynamic>? prCategoryList;
  List<dynamic>? wsCategoryList;
  bool isLoading = false;
  String? uID;
  String? data;

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    uID = prefs.getString("UID");
  }

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
        data = response.toString();
        wsCategoryList = jsonDecode(data!) as List<dynamic>?;

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
    }
  }

  apiForProductsByCategory() async {
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
        prCategoryList = jsonDecode(response) as List<dynamic>?;
      });
    } else {
      debugPrint('api failed:');
    }
  }

  @override
  void initState() {
    super.initState();
    apiForProductsByCategory();
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
                  itemCount: prCategoryList?.length ?? 0,
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
    var image = base! + prCategoryList![index]["image"].toString();
    var pID = prCategoryList![index]["id"].toString();
    var combID = prCategoryList![index]["combinationId"].toString();
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
              prCategoryList == null
                  ? 'Loading...'
                  : prCategoryList![index]["name"].toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              prCategoryList == null
                  ? 'Loading...'
                  : prCategoryList![index]["price"].toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              prCategoryList == null
                  ? 'Loading...'
                  : prCategoryList![index]["description"].toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ElevatedButton(
                onPressed: () {
                  addToWishlist(pID, combID);
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
