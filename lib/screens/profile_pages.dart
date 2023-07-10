import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                ? CircularProgressIndicator() // Display a circular progress indicator
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
