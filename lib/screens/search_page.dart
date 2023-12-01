import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/ApiHelper.dart';
import 'product_view.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String? base = "https://aryaas.hawkssolutions.com/basicapi/public/";
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

  addToWishlist(
    String id,
      String comId
  ) async {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Search Items",
            style: TextStyle(color: Colors.teal[900]),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
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
    var image = base! + searchList![index]["image"].toString();
    var price = "₹${searchList![index]["price"]}";
    var pID =  searchList![index]["id"].toString();
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductView(
                id: searchList![index]["id"].toString(),
                productName: searchList![index]["name"].toString(),
                url: image,
                description: searchList![index]["description"].toString(),
                amount: price,
                combinationId: searchList![index]["id"].toString(),
                quantity: searchList![index]["quantity"].toString(),
                category: searchList![index]["categories"].toString(),
                psize: "0"),
          ),
        );
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
                      size: Size.fromRadius(40), // Image radius
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      searchList == null
                          ? Text("null data")
                          : Text(
                        searchList![index]["name"].toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                      Text(
                        searchList![index]["description"].toString(),
                        maxLines: 2,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            addToWishlist(
                                pID,pID
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shadowColor: Colors.teal[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              )),
                          child: Icon(
                            Icons.favorite_outlined,
                            color: Colors.white,
                          ))
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
