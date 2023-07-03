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
  Map<String, dynamic>? data1;
  List<dynamic>? datalist;
  int index = 0;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    UID = prefs.getString("UID");
    print(UID);
  }

  Apicall() async {
    var response = await ApiHelper().post(endpoint: "common/profile", body: {
      "userid": UID,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('profile api successful:');
        datas = response.toString();
        data1 = jsonDecode(response);
        datalist = data1?["data"];
        print(response);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "ACCOUNT",
          style:
              TextStyle(color: Colors.teal[900], fontWeight: FontWeight.bold),
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
                  color: Colors.orangeAccent),
              height: 100,
              child: Center(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text("name"),
                  ),
                  title: Text("FirstName",
                      // datalist![index]["first_name"].toString(),
                      style: TextStyle(fontSize: 35)),
                  subtitle: Text("emailId"),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.add_home_outlined, size: 25),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        "Add Address",
                        style: TextStyle(fontSize: 20),
                      ))
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 25),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return MyOrders();
                      },
                    )),
                    child: Text("My Orders", style: TextStyle(fontSize: 20)),
                  )
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.favorite_border_sharp, size: 25),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () =>
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Wishlist();
                            },
                          )),
                      child:
                          Text("My Wishlist", style: TextStyle(fontSize: 20)))
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.settings_outlined, size: 25),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () =>
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Settings();
                            },
                          )),
                      child: Text("Settings", style: TextStyle(fontSize: 20)))
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.help_outline_rounded,
                    size: 25,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text("Help & Support",
                          style: TextStyle(
                            fontSize: 20,
                          )))
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
