import 'dart:convert';
import 'package:aaryas_sample/screens/accounts_page/add_address.dart';
import 'package:aaryas_sample/screens/orders_page.dart';
import 'package:aaryas_sample/screens/accounts_page/settings.dart';
import 'package:aaryas_sample/screens/accounts_page/profile_pages.dart';
import 'package:aaryas_sample/screens/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Config/ApiHelper.dart';
import '../login_page.dart';

class Accounts extends StatefulWidget {
  const Accounts({Key? key}) : super(key: key);

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  String? uID;
  String? data;
  Map? responseData;
  List? dataList;
  int index = 0;
  bool isLoggedIn = false;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uID = prefs.getString("UID");
      isLoggedIn = uID != null;
    });
    apiCall();
  }

  Future<void> apiCall() async {
    try {
      var response = await ApiHelper().post(endpoint: "common/profile", body: {
        "id": uID,
      });
      if (response != null) {
        setState(() {
          debugPrint('profile api successful:');
          data = response.toString();
          responseData = jsonDecode(response);
          dataList = responseData?["data"];
        });
      } else {
        debugPrint('api failed:');
      }
    } catch (err) {
      debugPrint('An error occurred: $err');
    }
  }

  void openGmail() async {
    final url = "mailto:aryaashelp&support@gmail.com?subject=&body=";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Open Gmail"),
            content: Text("Are you sure"),
            actions: [
              TextButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Yes"),
                onPressed: () {
                  launch(
                      "mailto:aryaashelp&support@gmail.com?subject=  &body=  ");
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: isLoggedIn
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return Profile();
                      }),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.orangeAccent,
                      ),
                      height: 100,
                      child: Center(
                        child: dataList == null
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Text(
                                      '',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  title: Text(
                                    '',
                                    style: TextStyle(fontSize: 35),
                                  ),
                                  subtitle: Text(''),
                                ),
                              )
                            : ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    dataList![index]["first_name"][0]
                                        .toString(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                title: Text(
                                  dataList![index]["first_name"].toString(),
                                  style: TextStyle(fontSize: 35),
                                ),
                                subtitle: Text(
                                  dataList![index]["email"].toString(),
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return AddAddress();
                        }),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.add_home_outlined, size: 25),
                          SizedBox(width: 10),
                          Text("Add Address", style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return MyOrders();
                        }),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.shopping_bag_outlined, size: 25),
                          SizedBox(width: 10),
                          Text("My Orders", style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return Wishlist();
                        }),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.favorite_border_sharp, size: 25),
                          SizedBox(width: 10),
                          Text("My Wishlist", style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return Settings();
                        }),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.settings_outlined, size: 25),
                          SizedBox(width: 10),
                          Text("Settings", style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        openGmail();
                        // launch("mailto:aryaashelp&support@gmail.com?subject=  &body=  ");
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.help_outline_rounded,
                            size: 25,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Help & Support",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                ],
              ),
            )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset("assets/img_1.png"),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shadowColor: Colors.teal[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                      ),
                    ),
                    child: Text("Please LogIn"),
                  ),
                ],
              ),
            ),
    );
  }
}
