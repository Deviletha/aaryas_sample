import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../Config/ApiHelper.dart';
import '../../Utils/imagepicker.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  String? uID;
  String? data;
  Map? responseData;
  List? dataList;
  int index = 0;
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
    apiCall();
    getUserAddress();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Profile",
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              dataList == null
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Container(
                            width: 120,
                            height: 30,
                            color: Colors.white,
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 80,
                            height: 20,
                            color: Colors.white,
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 120,
                            height: 20,
                            color: Colors.white,
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 80,
                            height: 20,
                            color: Colors.white,
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 100,
                            height: 20,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Card(
                          color: Colors.orange.shade50,
                          child: Column(
                            children: [
                              Text(
                                dataList![index]["first_name"].toString(),
                                style:
                                    TextStyle(fontSize: 35, letterSpacing: 1),
                              ),
                              Text(
                                dataList![index]["phone"].toString(),
                                style: const TextStyle(
                                    fontSize: 17, letterSpacing: 1),
                              ),
                              Text(
                                dataList![index]["email"].toString(),
                                style: const TextStyle(
                                    fontSize: 17, letterSpacing: 1),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              addressList == null ? 0 : addressList!.length,
                          itemBuilder: (context, index) => getAddressRow(index),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getAddressRow(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              addressList == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      addressList![index]["address"].toString(),
                      style: const TextStyle(fontSize: 17, letterSpacing: 1),
                    ),
              SizedBox(
                height: 5,
              ),
              Text(
                addressList![index]["phone"].toString(),
                style: const TextStyle(
                    fontSize: 17, letterSpacing: 1, color: Colors.red),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                addressList![index]["city"].toString(),
                style: const TextStyle(fontSize: 17, letterSpacing: 1),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                addressList![index]["pincode"].toString(),
                style: const TextStyle(fontSize: 17, letterSpacing: 1),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                addressList![index]["state"].toString(),
                style: const TextStyle(fontSize: 17, letterSpacing: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
