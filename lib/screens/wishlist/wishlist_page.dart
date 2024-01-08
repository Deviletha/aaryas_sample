import 'dart:convert';
import 'package:aaryas_sample/screens/wishlist/widget/wishlistcard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:aaryas_sample/Config/ApiHelper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/image_url_const.dart';
import '../../theme/colors.dart';
import '../registration/login_page.dart';

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
                      backgroundColor: Color(ColorT.themeColor),
                      shadowColor: Color(ColorT.themeColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
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
    return WishlistTile(
      imagePath: image,
      categoryName: finalPrList![index1]["category"].toString(),
      itemName: finalPrList![index1]["combinationName"].toString(),
      price: price,
      onPressed: () {
        wID = finalPrList![index1]["wishlistId"].toString();
        removeFromWishlist(wID!);
      },
    );
  }
}
