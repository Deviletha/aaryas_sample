import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config/ApiHelper.dart';
import '../../theme/colors.dart';

class ChangeProfile extends StatefulWidget {
  const ChangeProfile({Key? key}) : super(key: key);

  @override
  State<ChangeProfile> createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  String? uID;

  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailIdController = TextEditingController();

  Map? finalUserList;
  int index = 0;

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    uID = prefs.getString("UID");
    if (kDebugMode) {
      print(uID);
    }
  }

  editProfile() async {
    var response = await ApiHelper().post(
      endpoint: "common/updateProfile",
      body: {
        "first_name": firstnameController.text,
        "last_name": lastnameController.text,
        "email": emailIdController.text,
        "dob": "21/06/1998",
        "id": uID
      },
    ).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('edit profile api successful:');
        finalUserList = jsonDecode(response);

        Fluttertoast.showToast(
          msg: "Profile Edited Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Navigate back to the settings page
        Navigator.pop(context);
      });
    } else {
      debugPrint('edit profile failed:');
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
        ),
      ),
      bottomNavigationBar:   Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: 350,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              editProfile();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(ColorT.themeColor),
              shadowColor:Color(ColorT.themeColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10),
                ),
              ),
            ),
            child: Text("Submit"),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
            child: TextFormField(
              controller: firstnameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.user, color: Colors.black, size: 20,),
                labelText: "First Name",
                border: OutlineInputBorder(
                    borderSide: BorderSide.none),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter a valid name';
                } else {
                  return null;
                }
              },
              textInputAction: TextInputAction.next,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
            child: TextFormField(
              controller: lastnameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.user, color: Colors.black, size: 20,),
                labelText: "Last Name",
                border: OutlineInputBorder(
                    borderSide: BorderSide.none),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter a valid name';
                } else {
                  return null;
                }
              },
              textInputAction: TextInputAction.next,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
            child: TextFormField(
              controller: emailIdController,
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.message, color: Colors.black, size: 20,),
                labelText: "Email Id ",
                border: OutlineInputBorder(
                    borderSide: BorderSide.none),
              ),
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Enter a valid Email ID';
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),
          ),
        ],
      ),
    );
  }
}
