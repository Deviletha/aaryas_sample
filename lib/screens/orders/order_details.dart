import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/ApiHelper.dart';
import '../../Config/image_url_const.dart';
import '../../theme/colors.dart';

class OrderDetails extends StatefulWidget {
  final String id;

  const OrderDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final TextEditingController reasonController = TextEditingController();
  String? uID;
  Map? order;
  Map? order1;
  List? orderList;

  bool isLoading = true; // Add this variable

  Map? orderReturn;
  Map? returnList;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uID = prefs.getString("UID");
    });
    getMyOrders();
  }
  returnItem() async {
    var response = await ApiHelper().post(endpoint: "common/orderReturn", body: {
      "orderid": widget.id,
      "reason": reasonController.text,
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('return api successful:');
        orderReturn = jsonDecode(response);
        returnList = orderReturn!["data"];
        Fluttertoast.showToast(
          msg: "order returned successfully",
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

  getMyOrders() async {
    var response =
    await ApiHelper().post(endpoint: "common/getOrderDetails", body: {
      "orderid": widget.id,
      "offset": "0",
      "pageLimit": "10",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Order History",
        ),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Color(ColorT.themeColor),
        ),
      )
          : ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: orderList == null ? 0 : orderList?.length,
        itemBuilder: (context, index) => getOrderList(index),
      ),
    );
  }

  Widget getOrderList(int index) {
    var image = UrlConstants.base + orderList![index]["image"].toString();
    var price = "₹${orderList![index]["price"]}";
    var status = orderList![index]["status"];

    // Check if the status is -1
    bool isCancelable = status != -1;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.grey.shade100,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox.fromSize(
                        size: Size.fromRadius(40),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      orderList == null
                          ? Text("null data")
                          : Text(
                        orderList![index]["product"].toString(),
                        style: TextStyle(
                          letterSpacing: 1,
                          color: Color(ColorT.greyColor),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        orderList![index]["address"].toString(),
                        style: TextStyle(
                          letterSpacing: 1,
                          color: Color(ColorT.greyColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isCancelable)
                    SizedBox(
                      height: 10,
                    ),
                  if (isCancelable)
                    Card(
                      child: TextButton(
                        onPressed: () {
                          returnItem();
                        },
                        child: Text(
                          "Cancel Order",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
