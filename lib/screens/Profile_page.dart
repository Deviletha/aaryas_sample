import 'dart:convert';
import 'package:aaryas_sample/screens/Orders_page.dart';
import 'package:aaryas_sample/screens/Settings.dart';
import 'package:aaryas_sample/screens/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/ApiHelper.dart';

class Profile_page extends StatefulWidget {
  const Profile_page({Key? key}) : super(key: key);

  @override
  State<Profile_page> createState() => _Profile_pageState();
}

class _Profile_pageState extends State<Profile_page> {
  String? UID;
  String? datas;
  Map<String, dynamic>? responseData;
  List<dynamic>? dataList;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      UID = prefs.getString("UID");
      print(UID);
    });
    Apicall();
  }

  Future<void> Apicall() async {
    try {
      var response = await ApiHelper().post(endpoint: "common/profile", body: {
        "userid": "37",
      });
      if (response != null) {
        setState(() {
          debugPrint('profile api successful:');
          datas = response.toString();
          responseData = jsonDecode(response);
          dataList = responseData?["data"];
          print(responseData.toString());

          Fluttertoast.showToast(
            msg: "Success",
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
    } catch (err) {
      debugPrint('An error occurred: $err');
      Fluttertoast.showToast(
        msg: "An error occurred",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "ACCOUNT",
          style: TextStyle(
            color: Colors.teal[900],
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.orangeAccent,
              ),
              height: 100,
              child: Center(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text("name"),
                  ),
                  title: Text(
                    dataList != null && dataList!.isNotEmpty
                        ? dataList![0]["first_name"].toString()
                        : "",
                    style: TextStyle(fontSize: 35),
                  ),
                  subtitle: Text("emailId"),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.add_home_outlined, size: 25),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Add Address",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return MyOrders();
                  },
                )),
                child: Row(
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 25),
                    SizedBox(
                      width: 10,
                    ),
                    Text("My Orders", style: TextStyle(fontSize: 20))
                  ],
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Wishlist();
                  },
                )),
                child: Row(
                  children: [
                    Icon(Icons.favorite_border_sharp, size: 25),
                    SizedBox(
                      width: 10,
                    ),
                    Text("My Wishlist", style: TextStyle(fontSize: 20))
                  ],
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Settings();
                  },
                )),
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, size: 25),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Settings", style: TextStyle(fontSize: 20))
                  ],
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.help_outline_rounded,
                      size: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Help & Support",
                        style: TextStyle(
                          fontSize: 20,
                        ))
                  ],
                ),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
