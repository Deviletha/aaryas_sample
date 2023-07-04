import 'dart:convert';
import 'package:aaryas_sample/Config/ApiHelper.dart';
import 'package:aaryas_sample/constants/Title_widget.dart';
import 'package:aaryas_sample/screens/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Product_view.dart';
import 'category_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? UID;


  bool isLoading = false; // Track API loading state

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    UID = prefs.getString("UID");
    print(UID);
  }

  String? base = "https://aryaas.hawkssolutions.com/basicapi/public/";
  List? categorylist;

  String? data;
  Map? productlist;
  Map? productlist1;
  List? Finalproductlist;

  ApiforCategory() async {
    setState(() {
      isLoading = true;
    });

    var response = await ApiHelper().post(endpoint: "categories", body: {
      "offset": "0",
      "pageLimit": "5",
      "table": "categories"
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('get products api successful:');
        categorylist = jsonDecode(response);

        Fluttertoast.showToast(
          msg: "Success ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
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
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }


  ApiforAllProducts() async {
    setState(() {
      isLoading = true;
    });

    var response = await ApiHelper().post(endpoint: "products/ByCombination", body: {
      "offset": "0",
      "pageLimit": "100",
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('get products api successful:');
        data = response.toString();
        productlist = jsonDecode(response);
        productlist1 = productlist!["pagination"];
        Finalproductlist = productlist1!["pageData"];

        Fluttertoast.showToast(
          msg: "Success ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
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
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  addTowishtist(String id, String combination) async {

    var response = await ApiHelper().post(endpoint: "wishList/add", body: {
      "userid": UID,
      "productid": id,
      "combination": combination
    }).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('addwishlist api successful:');
        data = response.toString();
        productlist = jsonDecode(response);
        productlist1 = productlist!["pagination"];
        Finalproductlist = productlist1!["pageData"];

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
      Fluttertoast.showToast(
        msg: "Add to wishlist failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  void initState() {
    ApiforCategory();
    ApiforAllProducts();
    checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "ARYAAS",
          style:
          TextStyle(color: Colors.teal[900], fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Icon(
            Icons.location_on,
            color: Colors.black,
          ),
          IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Wishlist();
                },
              )),
              icon: Icon(
                Icons.favorite,
                color: Colors.teal,
              )),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Container(
                  height: 45,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Search ",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      Icon(
                        Icons.search,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Heading(text: "Category"),
          Expanded(
            flex: 2,
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : GridView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.2,
              ),
              itemCount: categorylist == null ? 0 : categorylist?.length,
              itemBuilder: (context, index) => getCategoryRow(index),
            ),
          ),
          const Heading(text: "All Items"),
          Expanded(
            flex: 4,
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount:
              Finalproductlist == null ? 0 : Finalproductlist?.length,
              itemBuilder: (context, index) => getProducts(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget  getCategoryRow(int index) {
    var image = base! + categorylist![index]["image"];
    var itemName = categorylist![index]["name"].toString();

    return ListTile(
      onTap:  () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Category_View(
              url: image,
              itemname: categorylist![index]["name"].toString(),
              description: categorylist![index]["description"].toString(),
              price: categorylist![index]["price"].toString(),
              id: categorylist![index]["id"],
            ),
          ),
        );
      },
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            itemName,
          ),
          SizedBox(
            height: 3,
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(image),
            radius: 20,
          ),
        ],
      ),
    );
  }

  Widget getProducts(int index) {
    var image = base! + Finalproductlist![index]["image"];
    var price = "₹" + Finalproductlist![index]["combinationPrice"].toString();
    var PID = Finalproductlist![index]["id"].toString();
    var CombID = Finalproductlist![index]["combinationId"].toString();
    return Card(
      child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductView(
                  id: Finalproductlist![index]["id"].toString(),
                  productname:
                      Finalproductlist![index]["combinationName"].toString(),
                  url: image,
                  description:
                      Finalproductlist![index]["description"].toString(),
                  amount:
                      Finalproductlist![index]["combinationPrice"].toString(),
                  combinationId:
                      Finalproductlist![index]["combinationId"].toString(),
                  quantity: Finalproductlist![index]["quantity"].toString(),
                  category: Finalproductlist![index]["category"].toString(),
                  psize: Finalproductlist![index]["combinationSize"].toString(),
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
                        Finalproductlist == null
                            ? Text("null data")
                            : Text(
                                Finalproductlist![index]["combinationName"]
                                    .toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          Finalproductlist![index]["description"].toString(),
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
              addTowishtist(PID, CombID);
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
}
