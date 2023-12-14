import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/ApiHelper.dart';
import '../../Config/image_url_const.dart';
import '../../theme/colors.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String? uID;
  Map? search;
  Map? search1;
  List? searchList;
  String? searchKeyword;
  int index = 0;


  Map? prList;
  Map? prList1;
  List? finalPrList;
  bool isLoading = true;


  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    uID = prefs.getString("UID");
    apiForWishlist();
  }

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


  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  bool isInWishlist = false; // Add this variable

  addToWishlist(String id, String combination) async {

        // CombinationId does not exist, add to wishlist
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
          });
        } else {
          debugPrint('Add to wishlist failed:');
        }
      }


  void _performSearch() async {
    setState(() {
      searchKeyword = _searchController.text.trim();
    });

    var response = await ApiHelper().post(endpoint: "common/allSearch", body: {
      "key": searchKeyword,
      "offset": "0",
      "pageLimit": "10",
    }).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('search successful:');
        search = jsonDecode(response);
        search1 = search!["data"];
        searchList = search1!["pageData"];
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {},
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
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "₹ ${itemDetails["price"]}",
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Search Items",
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for restaurants and food',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _performSearch,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                ),
              ),
            ),
            ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: searchList == null ? 0 : searchList?.length,
              itemBuilder: (context, index) => getSearchList(index),
            )
          ],
        ),
      ),
    );
  }

  Widget getSearchList(int index) {
    var image = UrlConstants.base + searchList![index]["image"].toString();
    var price = "₹${searchList![index]["price"]}";
    var pID = searchList![index]["id"].toString();
    var combID = searchList![index]["combinationId"].toString();

    // Check if the current item is in the wishlist
     isInWishlist = finalPrList != null &&
        finalPrList!.any((item) => item["combinationId"].toString() == combID);
    return InkWell(
      onTap: () {
        _showDetailsBottomSheet(searchList![index]);
      },
      child: Card(
          color: Colors.grey.shade50,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  width: 120,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      searchList == null
                          ? Text("null data")
                          : Text(
                              searchList![index]["name"].toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        price,
                        style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(ColorT.themeColor)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        searchList![index]["description"].toString(),
                        maxLines: 2,
                        style:  TextStyle(fontWeight: FontWeight.bold, color: Color(ColorT.greyColor)),
                      ),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
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
                  ),),
              ],
            ),
          )),
    );
  }
}
