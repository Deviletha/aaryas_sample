import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/ApiHelper.dart';
import '../../Config/image_url_const.dart';
import '../../theme/colors.dart';
import '../product_view/product_view.dart';

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

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    uID = prefs.getString("UID");
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  addToWishlist(String id, String comId) async {
    var response = await ApiHelper().post(endpoint: "wishList/add", body: {
      "userid": uID,
      "productid": id,
      "combination": comId
    }).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('add wishlist api successful:');

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
                    hintText: 'Search...',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => _searchController.clear(),
                    ),
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _performSearch,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
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
    return InkWell(
      onTap: () {
        _showDetailsBottomSheet(searchList![index]);

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ProductView(
        //         id: searchList![index]["id"].toString(),
        //         productName: searchList![index]["name"].toString(),
        //         url: image,
        //         description: searchList![index]["description"].toString(),
        //         amount: price,
        //         combinationId: searchList![index]["id"].toString(),
        //         quantity: searchList![index]["quantity"].toString(),
        //         category: searchList![index]["categories"].toString(),
        //         psize: "0"),
        //   ),
        // );
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
                        addToWishlist(pID, pID);
                      },
                      icon: Icon(
                        Iconsax.heart,
                        size: 25,
                        color: Colors.white,
                      )),
                )
              ],
            ),
          )),
    );
  }
}
