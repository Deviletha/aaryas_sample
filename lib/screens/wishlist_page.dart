import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:aaryas_sample/Config/ApiHelper.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/image_url_const.dart';
import '../theme/colors.dart';
import 'registration/login_page.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
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
    setState(() {
      isLoggedIn = uID != null;
    });
    if (isLoggedIn) {
      apiCall();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  String? wID;

  Map? prList;
  Map? prList1;
  List? finalPrList;

  Future<void> apiCall() async {
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
    var response = await ApiHelper().post(endpoint: "wishList/remove", body: {
      "id": id,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('Remove api successful:');
        apiCall();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "My WishList",
        ),
      ),
      body: isLoggedIn
          ? isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Color(ColorT.themeColor),
                  ),
                )
              : finalPrList == null || finalPrList!.isEmpty
                  ? Center(
                      child: Image.asset("assets/wishlist-empty.jpg"),
                    )
                  : ListView.builder(
                      itemCount: finalPrList == null ? 0 : finalPrList?.length,
                      itemBuilder: (context, index) => getWishlist(index),
                    )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
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

  Widget getWishlist(int index1) {
    var image = UrlConstants.base + finalPrList![index1]["image"];
    var price = "₹ ${finalPrList![index1]["combinationPrice"]}";
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderRadius: BorderRadius.circular(20), // Image border
              child: SizedBox.fromSize(
                size: Size.fromRadius(60), // Image radius
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
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
                finalPrList == null
                    ? Text("null data")
                    : Text(
                        finalPrList![index1]["combinationName"].toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  finalPrList![index1]["category"].toString(),
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Card(
                color: Colors.grey.shade600,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    price,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey)
                ),
                child: TextButton(
                    onPressed: () {
                      wID = finalPrList![index1]["wishlistId"].toString();
                      removeFromWishlist(wID!);
                    },
                    child: Text(
                      "Remove Item",
                      style: TextStyle(color: Colors.black),
                    )
                    // Icon(Iconsax.trash, color: Colors.red,)
                    ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
