import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../Config/ApiHelper.dart';
import '../Utils/imagepicker.dart';

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

  String? UID;
  String? datas;
  Map? responseData;
  List? dataList;
  int index = 0;
  Map? address;
  List? Addresslist;

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
    getUserAddress();
  }

  Future<void> Apicall() async {
    try {
      var response = await ApiHelper().post(endpoint: "common/profile", body: {
        "id": UID,
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

  getUserAddress() async {
    var response = await ApiHelper().post(endpoint: "user/getAddress", body: {
      "userid": UID,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('get address api successful:');
        address = jsonDecode(response);
        Addresslist = address!["status"];

        Fluttertoast.showToast(
          msg: "User Address",
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.teal[900]),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                  radius: 65,
                  backgroundImage: MemoryImage(_image!),
                )
                    : CircleAvatar(
                  radius: 65,
                  backgroundImage: AssetImage("assets/img_2.png"),
                ),
                IconButton(
                  onPressed: () {
                    selectImage();
                  },
                  icon: Icon(Icons.add_a_photo),
                ),
              ],
            ),
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
                Text(
                  dataList![index]["first_name"].toString(),
                  style: TextStyle(fontSize: 35),
                ),
                Text(
                  dataList![index]["phone"].toString(),
                ),
                Text(
                  dataList![index]["email"].toString(),
                ),
                Text(
                  dataList![index]["dob"].toString(),
                ),
                ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: Addresslist == null ? 0 : Addresslist!.length,
                  itemBuilder: (context, index) => getAddressRow(index),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }

  Widget getAddressRow(int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Addresslist == null
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : Text(
                      Addresslist![index]["address"]
                          .toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      Addresslist![index]["phone"]
                          .toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,color: Colors.red),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      Addresslist![index]["city"]
                          .toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      Addresslist![index]["pincode"]
                          .toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      Addresslist![index]["state"]
                          .toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),

              ],
        ),
      ),
    );
  }


}
