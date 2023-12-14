import 'dart:convert';

import 'package:aaryas_sample/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config/ApiHelper.dart';
import '../../Config/image_url_const.dart';
import 'order_details.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  String? uID;
  Map? order;
  Map? order1;
  List? orderList;

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

  getMyOrders() async {
    var response =
        await ApiHelper().post(endpoint: "common/getMyOrders", body: {
      "userid": uID,
      "offset": "0",
      "pageLimit": "10",
    }).catchError((err) {});
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
      appBar: AppBar(
        title: Text(
          "My Orders",
        ),
      ),
      body: ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: orderList == null ? 0 : orderList?.length,
        itemBuilder: (context, index) => getOrderList(index),
      ),
    );
  }

  Widget getOrderList(int index) {
    var image = UrlConstants.base + orderList![index]["image"].toString();
    var price = "₹${orderList![index]["total"]}";
    var statusNote = orderList![index]["status_note"].toString();

    Color statusColor = Colors.green; // Default color, you can change it as per your requirement

    // Set color based on status_note
    if (statusNote == "Order Placed") {
      statusColor = Colors.indigo;
    } else if (statusNote == "Cancelled") {
      statusColor = Colors.red;
    }

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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    orderList == null
                        ? Text("null data")
                        : Text(
                      orderList![index]["cartName"].toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      price,
                      style:  TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(ColorT.themeColor)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      orderList![index]["address"].toString(),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      orderList![index]["date"].toString(),
                      style: const TextStyle(color: Colors.grey, letterSpacing: .80),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    statusNote, style: TextStyle(
                    fontSize: 13, color: Colors.white, letterSpacing: .86
                  ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
