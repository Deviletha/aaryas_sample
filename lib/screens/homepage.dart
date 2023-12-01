import 'dart:async';
import 'dart:convert';
import 'package:aaryas_sample/Config/ApiHelper.dart';
import 'package:aaryas_sample/constants/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'notification_page.dart';
import 'order_details.dart';
import 'product_view.dart';
import 'search_page.dart';
import 'category_view.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? uID;

  bool isLoading = false;
  bool isLoadingCategories = true; // Track API loading state

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uID = prefs.getString("UID");
    });
    getMyOrders();
  }

  String? base = "https://aryaas.hawkssolutions.com/basicapi/public/";

  ///OrderList
  Map? order;
  Map? order1;
  List? orderList;

  ///CategoryList
  List? categoryList;

  ///ProductList
  String? data;
  Map? productList;
  Map? productList1;
  List? finalProductList;

  ///PopularProductList
  Map? popularList;
  Map? popularList1;
  List? finalPopularList;
  int index = 0;

  getMyOrders() async {
    setState(() {
      isLoading = true;
    });
    var response =
        await ApiHelper().post(endpoint: "common/getMyOrders", body: {
      "userid": uID,
      "offset": "0",
      "pageLimit": "1",
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('get address api successful:');
        order = jsonDecode(response);
        order1 = order!["data"];
        orderList = order1!["pageData"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  apiForCategory() async {
    setState(() {
      isLoading = true;
    });

    var response = await ApiHelper().post(endpoint: "categories", body: {
      "offset": "0",
      "pageLimit": "5",
      "table": "categories"
    }).catchError((err) {});

    setState(() {
      Timer(const Duration(seconds: 3), () {
        isLoading = false;
      });
    });
    if (response != null) {
      setState(() {
        debugPrint('get products api successful:');
        categoryList = jsonDecode(response);
      });
    } else {
      debugPrint('api failed:');
    }
  }

  apiForAllProducts() async {
    setState(() {
      isLoading = true;
    });

    var response =
        await ApiHelper().post(endpoint: "products/ByCombination", body: {
      "offset": "0",
      "pageLimit": "50",
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('get products api successful:');
        data = response.toString();
        productList = jsonDecode(response);
        productList1 = productList!["pagination"];
        finalProductList = productList1!["pageData"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  apiForPopularProducts() async {
    setState(() {
      isLoading = true;
    });

    var response =
        await ApiHelper().post(endpoint: "products/ByCombination", body: {
      "offset": "0",
      "pageLimit": "8",
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('get products api successful:');
        data = response.toString();
        popularList = jsonDecode(response);
        popularList1 = popularList!["pagination"];
        finalPopularList = popularList1!["pageData"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  addToWishlist(String id, String combination) async {
    var response = await ApiHelper().post(endpoint: "wishList/add", body: {
      "userid": uID,
      "productid": id,
      "combination": combination
    }).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('add wishlist api successful:');
        data = response.toString();

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

  @override
  void initState() {
    apiForCategory().then((_) {
      setState(() {
        isLoadingCategories = false;
      });
    });
    apiForAllProducts();
    apiForPopularProducts();
    getMyOrders();
    checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "ARYAS",
          style:
              TextStyle(color: Colors.teal[900], fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Notifications();
                    },
                  )),
              icon: Icon(
                Icons.notifications_outlined,
                color: Colors.black45,
              )),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return Search();
                    }),
                  ),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: Colors.teal)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text("Search..."), Icon(Icons.search)],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Heading(text: "Recent Orders"),
          Container(
            child: isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 1, // Set a fixed count for shimmer effect
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          height: 100, // Adjust the height as needed
                        );
                      },
                    ),
                  )
                : ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: orderList == null ? 0 : orderList?.length,
                    itemBuilder: (context, index) => getOrderList(index),
                  ),
          ),
          const Heading(text: "Category"),
          Container(
            child: isLoadingCategories
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CarouselSlider.builder(
                      itemCount: 5, // Set a fixed count for shimmer effect
                      itemBuilder: (context, index, realIndex) {
                        return getCategoryRow(index);
                      },
                      options: CarouselOptions(
                        height: 300,
                        aspectRatio: 15 / 6,
                        viewportFraction: .6,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        onPageChanged: (index, reason) {},
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  )
                : CarouselSlider.builder(
                    itemCount: categoryList == null ? 0 : categoryList?.length,
                    itemBuilder: (context, index, realIndex) {
                      return getCategoryRow(index);
                    },
                    options: CarouselOptions(
                      height: 300,
                      aspectRatio: 15 / 6,
                      viewportFraction: .6,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: false,
                      enlargeCenterPage: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      onPageChanged: (index, reason) {},
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
          ),
          const Heading(text: "Popular Items"),
          Container(
            child: isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: 8,
                      // Set a fixed count for shimmer effect
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        );
                      },
                    ),
                  )
                : GridView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.2,
                    ),
                    itemCount:
                        finalPopularList == null ? 0 : finalPopularList?.length,
                    itemBuilder: (context, index) => getPopularRow(index),
                  ),
          ),
          const Heading(text: "Top Picks For You"),
          Container(
              child: isLoadingCategories
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CarouselSlider.builder(
                        itemCount:
                            categoryList == null ? 0 : categoryList?.length,
                        itemBuilder: (context, index, realIndex) {
                          return getCategoryRow(index);
                        },
                        options: CarouselOptions(
                          height: 200,
                          aspectRatio: 15 / 6,
                          viewportFraction: .8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: false,
                          enlargeCenterPage: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          onPageChanged: (index, reason) {},
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    )
                  : CarouselSlider.builder(
                      itemCount:
                          categoryList == null ? 0 : categoryList?.length,
                      itemBuilder: (context, index, realIndex) {
                        return getCategoryImage(index);
                      },
                      options: CarouselOptions(
                        height: 200,
                        aspectRatio: 15 / 6,
                        viewportFraction: .8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        enlargeCenterPage: false,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        onPageChanged: (index, reason) {},
                        scrollDirection: Axis.horizontal,
                      ),
                    )),
          const Heading(text: "All Items"),
          Container(
            child: isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 10, // Set a fixed count for shimmer effect
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          height: 100, // Adjust the height as needed
                        );
                      },
                    ),
                  )
                : ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        finalProductList == null ? 0 : finalProductList?.length,
                    itemBuilder: (context, index) => getProducts(index),
                  ),
          ),
        ],
      ),
    );
  }

  Widget getPopularRow(int index) {
    var image = base! + finalPopularList![index]["image"];
    var itemName = finalPopularList![index]["combinationName"].toString();
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductView(
              id: finalPopularList![index]["id"].toString(),
              productName:
                  finalPopularList![index]["combinationName"].toString(),
              url: image,
              description: finalPopularList![index]["description"].toString(),
              amount: finalPopularList![index]["combinationPrice"].toString(),
              combinationId:
                  finalPopularList![index]["combinationId"].toString(),
              quantity: finalPopularList![index]["quantity"].toString(),
              category: finalPopularList![index]["category"].toString(),
              psize: finalPopularList![index]["combinationSize"].toString(),
            ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(image),
            radius: 25,
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            itemName,
            style: TextStyle(fontSize: 12),
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget getCategoryImage(int index) {
    if (categoryList == null) {
      return Container();
    }
    var image = base! + categoryList![index]["image"];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryView(
              url: image,
              itemname: categoryList![index]["name"].toString(),
              description: categoryList![index]["description"].toString(),
              price: categoryList![index]["price"].toString(),
              id: categoryList![index]["id"],
            ),
          ),
        );
      },
      child: Container(
        height: 200,
        width: 330,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image:
                DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)),
      ),
    );
  }

  Widget getCategoryRow(int index) {
    if (categoryList == null) {
      return Container(); // Handle the case when categoryList is null
    }
    var image = base! + categoryList![index]["image"];
    var itemName = categoryList![index]["name"].toString();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryView(
              url: image,
              itemname: categoryList![index]["name"].toString(),
              description: categoryList![index]["description"].toString(),
              price: categoryList![index]["price"].toString(),
              id: categoryList![index]["id"],
            ),
          ),
        );
      },
      child: Container(
        height: 300,
        width: 250,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
            image:
                DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Text(
                itemName,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                categoryList![index]["description"].toString(),
                maxLines: 2,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getProducts(int index) {
    var image = base! + finalProductList![index]["image"];
    var price = "₹${finalProductList![index]["combinationPrice"]}";
    var pID = finalProductList![index]["id"].toString();
    var combID = finalProductList![index]["combinationId"].toString();
    return Card(
      child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductView(
                  id: finalProductList![index]["id"].toString(),
                  productName:
                      finalProductList![index]["combinationName"].toString(),
                  url: image,
                  description:
                      finalProductList![index]["description"].toString(),
                  amount:
                      finalProductList![index]["combinationPrice"].toString(),
                  combinationId:
                      finalProductList![index]["combinationId"].toString(),
                  quantity: finalProductList![index]["quantity"].toString(),
                  category: finalProductList![index]["category"].toString(),
                  psize: finalProductList![index]["combinationSize"].toString(),
                ),
              ),
            );
          },
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
                        finalProductList == null
                            ? Text("null data")
                            : Text(
                                finalProductList![index]["combinationName"]
                                    .toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          finalProductList![index]["description"].toString(),
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
          trailing: ElevatedButton(
            onPressed: () {
              addToWishlist(pID, combID);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shadowColor: Colors.teal[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                )),
            child: Icon(Icons.favorite_sharp),
          )),
    );
  }

  Widget getOrderList(int index) {
    var image = base! + orderList![index]["image"].toString();
    return Card(
        color: Colors.grey.shade50,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetails(
                  id: orderList![index]["id"].toString(),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            orderList == null
                                ? Text("null data")
                                : Text(
                                    "Order Placed",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              orderList![index]["cartName"].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
