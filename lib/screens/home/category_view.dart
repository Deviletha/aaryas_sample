import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config/ApiHelper.dart';
import '../../Config/image_url_const.dart';
import '../../theme/colors.dart';

class CategoryView extends StatefulWidget {
  final String itemname;

  final int id;

  const CategoryView({
    Key? key,
    required this.itemname,
    required this.id,
  }) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  String? wID;

  List<dynamic>? prCategoryList;
  bool isLoading = true;
  String? uID;
  String? data;

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    uID = prefs.getString("UID");
    apiForWishlist();
  }

  Map? prList;
  Map? prList1;
  List? finalPrList;

  Future<void> apiForWishlist() async {

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
        checkUser();
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

  apiForAddCart(String id, String pName, String amount, String tax, String category, String psize, String combinationId) async {
    var response = await ApiHelper().post(endpoint: "cart/add", body: {
      "userid": uID,
      "productid": id,
      "product": pName,
      "price": amount,
      "quantity": "1",
      "tax": tax,
      "category": category,
      "size": "size",
      "psize": psize,
      "pcolor": "pcolor",
      "combination": combinationId
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('add to art api successful:');

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

  bool isInWishlist = false; // Add this variable

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
            checkUser();
            Fluttertoast.showToast(
              msg: "Added to Wishlist",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            isInWishlist = true; // Set isInWishlist to true
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


    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('get products api successful:');
        prCategoryList = jsonDecode(response) as List<dynamic>?;
      });
    } else {
      debugPrint('api failed:');
    }
  }

  void _showDetailsBottomSheet(Map<String, dynamic> itemDetails) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        var image = UrlConstants.base + itemDetails["image"].toString();
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 250,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CachedNetworkImage(
                  imageUrl: image,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/aryas_logo.png",
                            ),
                            colorFilter: ColorFilter.mode(
                                Colors.grey, BlendMode.color))),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        apiForAddCart(
                            itemDetails["id"].toString(),
                            itemDetails["combinationName"].toString(),
                          itemDetails["combinationPrice"].toString(),
                          itemDetails["tax_id"].toString(),
                          itemDetails["categories"].toString(),
                          itemDetails["combinationSize"].toString(),
                          itemDetails["combinationId"].toString()
                        );

                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          )),
                      child: Text("ADD")),
                ],
              ),
              SizedBox(height: 10),
              Text(
                itemDetails["name"].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Text(
                itemDetails["description"].toString(),
                style: TextStyle(fontSize: 16, color: Color(ColorT.greyColor)),
              ),
              SizedBox(height: 10),
              Text(
                "₹ ${itemDetails["combinationPrice"]}",
                style: TextStyle(
                  color: Color(ColorT.themeColor),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Add more details as needed
            ],
          ),
        );
      },
    );
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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child:
        isLoading? Center(
          child: CircularProgressIndicator(
            color: Color(ColorT.themeColor),
          ),
        ) :
        ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: prCategoryList?.length ?? 0,
          itemBuilder: (context, index) => getCatView(index),
        ),
      ),
    );
  }

  Widget getCatView(int index1) {
    var image = UrlConstants.base + prCategoryList![index1]["image"].toString();
    var pID = prCategoryList![index1]["id"].toString();
    var combID = prCategoryList![index1]["combinationId"].toString();

    // Check if the current item is in the wishlist
    bool isInWishlist = finalPrList != null &&
        finalPrList!.any((item) => item["combinationId"].toString() == combID);

    return InkWell(
      onTap: () {
        _showDetailsBottomSheet(prCategoryList![index1]);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                width: 150,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CachedNetworkImage(
                  imageUrl: image,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/aryas_logo.png",), colorFilter: ColorFilter.mode(Colors.grey, BlendMode.color))),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      prCategoryList == null
                          ? 'Loading...'
                          : prCategoryList![index1]["name"].toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(ColorT.greyColor),
                          fontSize: 15),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      prCategoryList == null
                          ? 'Loading...'
                          : prCategoryList![index1]["description"].toString(),
                      maxLines: 2,
                      style: TextStyle(
                          color: Color(ColorT.greyColor), fontSize: 12),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      prCategoryList == null
                          ? 'Loading...'
                          : "₹ ${prCategoryList![index1]["combinationPrice"]}",
                      style: const TextStyle(
                        color: Color(ColorT.themeColor),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: IconButton(
                  onPressed: () {
                    if (isInWishlist) {
                      removeFromWishlist(pID);
                    } else {
                      addToWishlist(pID, combID);
                    }
                  },
                  icon: isInWishlist ? Icon(
                    Iconsax.heart5,
                    color: Colors.white,
                    // Change icon color based on isInWishlist
                    size: 25,
                  ): Icon(
                    Iconsax.heart,
                    color: Colors.white,
                    // Change icon color based on isInWishlist
                    size: 25,
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
