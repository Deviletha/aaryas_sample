import 'dart:convert';

import 'package:aaryas_sample/screens/place_order/place_order.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../Config/ApiHelper.dart';
import '../../theme/colors.dart';
import '../accounts_page/add_address.dart';

class SelectAddress extends StatefulWidget {
  const SelectAddress({Key? key}) : super(key: key);

  @override
  State<SelectAddress> createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  String? uID;
  Map? address;
  List? addressList;

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
    getUserAddress();
  }

  getUserAddress() async {
    var response = await ApiHelper().post(endpoint: "user/getAddress", body: {
      "userid": uID,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('get address api successful:');
        address = jsonDecode(response);
        addressList = address!["status"];
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
          "Select your Address",
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAddress(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(ColorT.themeColor),
              shadowColor: Color(ColorT.themeColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            child: Text("Add New Address"),
          ),
        ),
      ),
      body: ListView(
        children: [
          addressList == null
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 100,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 100,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 100,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Text(
                      "Your Order will be shipped to this address",
                      style: TextStyle(fontSize: 15),
                    ),
                    ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: addressList == null ? 0 : addressList?.length,
                      itemBuilder: (context, index) => getAddressRow(index),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget getAddressRow(int index1) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceOrder(
              id: addressList![index1]["id"].toString(),
              latitude: addressList![index1]["latitude"].toString(),
              longitude: addressList![index1]["longitude"].toString(),
            ),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              addressList == null
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: double.infinity,
                        height: 20,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      addressList![index1]["address"].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
              SizedBox(height: 5),
              Text(
                addressList![index1]["phone"].toString(),
                style: TextStyle(color: Color(ColorT.greyColor)),
              ),
              SizedBox(height: 5),
              Text(
                addressList![index1]["city"].toString(),
                style: TextStyle(color: Color(ColorT.greyColor)),
              ),
              SizedBox(height: 5),
              Text(
                addressList![index1]["pincode"].toString(),
                style: TextStyle(color: Color(ColorT.greyColor)),
              ),
              SizedBox(height: 5),
              Text(
                addressList![index1]["state"].toString(),
                style: TextStyle(color: Color(ColorT.greyColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
