import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:aaryas_sample/Config/ApiHelper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  String? uID;
  bool isLoading = true;
  bool isLoggedIn = false;
  GlobalKey<RefreshIndicatorState> refreshKey =
  GlobalKey<RefreshIndicatorState>();

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

  String? base = "https://aryaas.hawkssolutions.com/basicapi/public/";
  String? wID;


  Map? prList;
  Map? prList1;
  List? finalPrList;
  int index = 0;

  Future<void> apiCall() async {
    setState(() {
      isLoading = true;
    });

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

  Future<void> refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    await apiCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "WISHLIST",
          style: TextStyle(color: Colors.teal[900], fontWeight: FontWeight.bold),
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
          : finalPrList == null || finalPrList!.isEmpty
          ? Center(
        child: Image.asset("assets/wishlist-empty.jpg"),
      )
          : RefreshIndicator(
        key: refreshKey,
        onRefresh: refreshPage,
        child: ListView.builder(
          itemCount: finalPrList == null ? 0 : finalPrList?.length,
          itemBuilder: (context, index) => getWishlist(index),
        ),
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
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

  Widget getWishlist(int index) {
    var image = base! + finalPrList![index]["image"];
    var price = "₹ ${finalPrList![index]["combinationPrice"]}";
    wID = finalPrList![index]["wishlistId"].toString();
    return Card(
      child: ListTile(
          title: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          finalPrList![index]["name"].toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          finalPrList![index]["description"].toString(),
                          maxLines: 2,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          price,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: TextButton(
            onPressed: () {
              removeFromWishlist(wID!);
            },
            child: Text(
              "Remove",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          )),
    );
  }
}
