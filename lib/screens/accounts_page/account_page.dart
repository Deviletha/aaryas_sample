import 'dart:convert';
import 'package:aaryas_sample/screens/accounts_page/add_address.dart';
import 'package:aaryas_sample/screens/accounts_page/privacy_info.dart';
import 'package:aaryas_sample/screens/orders/orders_page.dart';
import 'package:aaryas_sample/screens/accounts_page/settings.dart';
import 'package:aaryas_sample/screens/accounts_page/profile_pages.dart';
import 'package:aaryas_sample/screens/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Config/ApiHelper.dart';
import '../../theme/colors.dart';
import '../registration/login_page.dart';

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
  bool isLoggedIn = true;
  bool isLoading = true;

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
      }).catchError((err) {});

      setState(() {
        isLoading = false;
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
          "Account",
        ),
      ),
      body: isLoggedIn
          ? isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Color(ColorT.themeColor),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
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
                            color: Color(ColorT.themeColor),
                          ),
                          height: 150,
                          child: Center(
                            child: dataList == null
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 50,
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
                                      radius: 40,
                                      backgroundColor: Colors.white,
                                      child: Text(
                                        dataList![index]["first_name"][0]
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Color(ColorT.greyColor),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    title: Text(
                                      dataList![index]["first_name"].toString(),
                                      style: TextStyle(
                                          fontSize: 35,
                                          color: Colors.white,
                                          letterSpacing: 1),
                                    ),
                                    subtitle: Text(
                                      dataList![index]["email"].toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return AddAddress();
                          }),
                        ),
                        leading: Icon(
                          Iconsax.home,
                          color: Colors.black,
                          size: 30,
                        ),
                        title:
                            Text("Add Address", style: TextStyle(fontSize: 20)),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return MyOrders();
                          }),
                        ),
                        leading: Icon(
                          Iconsax.bag_2,
                          color: Colors.black,
                          size: 30,
                        ),
                        title:
                            Text("My Orders", style: TextStyle(fontSize: 18)),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return Wishlist();
                          }),
                        ),
                        leading: Icon(
                          Iconsax.heart,
                          color: Colors.black,
                          size: 30,
                        ),
                        title:
                            Text("My Wishlist", style: TextStyle(fontSize: 18)),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return Settings();
                          }),
                        ),
                        leading: Icon(
                          Iconsax.setting,
                          color: Colors.black,
                          size: 30,
                        ),
                        title: Text("Settings", style: TextStyle(fontSize: 18)),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return PrivacyInfo();
                          }),
                        ),
                        leading: Icon(
                          Iconsax.security_safe,
                          color: Colors.black,
                          size: 30,
                        ),
                        title: Text("Privacy & Terms",
                            style: TextStyle(fontSize: 18)),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      ListTile(
                        onTap: () {
                          openGmail();
                          // launch("mailto:aryaashelp&support@gmail.com?subject=  &body=  ");
                        },
                        leading: Icon(
                          Iconsax.info_circle,
                          color: Colors.black,
                          size: 30,
                        ),
                        title: Text("Help & Support",
                            style: TextStyle(fontSize: 18)),
                      ),
                      Divider(
                        thickness: 1,
                      ),
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
                      backgroundColor: Color(ColorT.themeColor),
                      shadowColor: Color(ColorT.themeColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
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
