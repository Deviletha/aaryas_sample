import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:aaryas_sample/Config/ApiHelper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {

  String? UID;

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
     UID = prefs.getString("UID");
    print(UID);
    APIcall();
  }

  String? base = "https://aryaas.hawkssolutions.com/basicapi/public/";
  var WID;
  Map? wslist;
  List? WsList;

  Map? prlist;
  Map? prlist1;
  List? Prlist;
  int index = 0;

  void initState() {
    super.initState();
    checkUser();
  }

  APIcall() async {
    var response = await ApiHelper().post(endpoint: "wishList/get", body: {
      "userid": UID,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('wishlist api successful:');
        prlist = jsonDecode(response);
        prlist1 = prlist!["pagination"];
        Prlist = prlist1!["pageData"];
        Fluttertoast.showToast(
          msg: "Wishlist page success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
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
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  removeFromWishtist(String id) async {
    var response = await ApiHelper().post(endpoint: "wishList/remove", body: {
      "id": id,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('Remove api successful:');
        prlist = jsonDecode(response);
        wslist = prlist!["pagination"];
        WsList = wslist!["pageData"];

        Fluttertoast.showToast(
          msg: "Removed product",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
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
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WishList"),
      ),
      backgroundColor: Colors.teal.shade50,
      body: ListView.builder(
        itemCount: Prlist == null ? 0 : Prlist?.length,
        itemBuilder: (context, index) => getWishlist(index),
      ),
    );
  }

  Widget getWishlist(int index) {
    var image = base! + Prlist![index]["image"];
    var price = "₹ " + Prlist![index]["combinationPrice"].toString();
    WID = Prlist![index]["wishlistId"].toString();
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
                        Prlist == null
                            ? Text("null data")
                            : Text(
                                Prlist![index]["name"].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          Prlist![index]["description"].toString(),
                          maxLines: 2,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          price,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green),
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
              removeFromWishtist(WID);
            },
            child: Text(
              "Remove",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          )),
    );
  }
}
