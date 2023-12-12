import 'dart:convert';
import 'package:aaryas_sample/screens/product_view/widgets/relatedItemsCard.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/ApiHelper.dart';
import '../../Config/image_url_const.dart';
import '../../theme/colors.dart';
import '../registration/login_page.dart';

class ProductView extends StatefulWidget {
  final String productName;
  final String url;
  final String description;
  final String amount;
  final String id;
  final int position;
  final String combinationId;
  final String quantity;
  final String category;
  final String psize;

  const ProductView(
      {Key? key,
      required this.productName,
      required this.url,
      required this.description,
      required this.amount,
      required this.id,
      required this.combinationId,
      required this.quantity,
      required this.category,
      required this.psize,
      required this.position})
      : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  int index = 0;
  Map? cList;
  List? cartList;
  String? uID;
  bool isLoading = true;
  String? data;
  Map? productList;
  Map? productList1;
  List? finalProductList;
  List? relatedProductList;

  String? productID;
  String? productName;
  String? offerPrice;
  String? category;
  String? pSize;
  String? combinationId;

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
        relatedProductList =
            finalProductList![widget.position]["relatedProduct"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    uID = prefs.getString("UID");
    apiForAllProducts();
  }

  apiForCart(String prID, String productName, String price, String category,
      String pSize, String combinationId) async {
    var response = await ApiHelper().post(endpoint: "cart/add", body: {
      "userid": uID,
      "productid": prID,
      "product": productName,
      "price": price,
      "quantity": "1",
      "tax": "tax",
      "category": category,
      "size": "size",
      "psize": pSize,
      "pcolor": "pcolor",
      "combination": combinationId
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('cartpage successful:');
        cList = jsonDecode(response);
        cartList = cList!["cart"];

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

  Future<void> checkLoggedIn(
      BuildContext context,
      String prID,
      String productName,
      String price,
      String category,
      String pSize,
      String combinationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginId = prefs.getString('UID');

    if (loginId != null && loginId.isNotEmpty) {
      // User is logged in, proceed with adding to cart
      apiForCart(
        prID,
        productName,price, category,pSize,combinationId
      );
    } else {
      // User is not logged in, navigate to LoginPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productName,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            SizedBox(
              height: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  clipBehavior: Clip.antiAlias,
                    child: Image.network(widget.url, fit: BoxFit.cover),),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "₹ ${widget.amount}",
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  widget.productName.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  widget.description.toString(),
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        checkLoggedIn(context,widget.id, widget.productName,widget.amount,widget.category,widget.psize, widget.combinationId);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(ColorT.themeColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                      child: Text("Add to Cart"),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Related Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            isLoading
                ? Center(
                  child: CircularProgressIndicator(
                      color: Color(ColorT.themeColor),
                    ),
                )
                : CarouselSlider.builder(
                    itemCount: relatedProductList == null
                        ? 0
                        : relatedProductList?.length,
                    itemBuilder: (context, index, realIndex) {
                      return getProducts(index);
                    },
                    options: CarouselOptions(
                      height: 250,
                      aspectRatio: 15 / 6,
                      viewportFraction: .55,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      reverse: false,
                      autoPlay: true,
                      enlargeCenterPage: false,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      onPageChanged: (index, reason) {},
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget getProducts(int index) {
    if (relatedProductList == null || relatedProductList![index] == null) {
      return Container();
    }
    var image = UrlConstants.base +
        (relatedProductList![index]["image"] ?? "").toString();
    var actualPrice = relatedProductList![index]["price"].toString() ?? "";

    var stock = relatedProductList![index]["quantity"];
    bool isStockAvailable = stock != null && int.parse(stock.toString()) > 0;

    return RelatedItemTile(
      actualPrice: actualPrice,
      itemName: relatedProductList![index]["name"].toString(),
      imagePath: image,
      onPressed: () {
        if (isStockAvailable) {
          productID = relatedProductList![index]["id"].toString();
          productName = relatedProductList![index]["name"].toString();
          offerPrice = relatedProductList![index]["price"].toString();
          category = relatedProductList![index]["category"].toString();
          pSize = relatedProductList![index]["size"].toString();
          combinationId =
              relatedProductList![index]["combinationid"].toString();
          checkLoggedIn(
              context, productID! , productName!, offerPrice!,category!, pSize!, combinationId!);
        } else {
          Fluttertoast.showToast(
              msg: "Product is out of stock!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },

    );
  }
}
