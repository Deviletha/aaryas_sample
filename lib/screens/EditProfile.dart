import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/ApiHelper.dart';

class ChangeAddress extends StatefulWidget {
  const ChangeAddress({Key? key}) : super(key: key);

  @override
  State<ChangeAddress> createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> {
  String? UID;

  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailIdController = TextEditingController();



  Map? FinalUserlist;
  int index = 0;

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    UID = prefs.getString("UID");
    print(UID);

  }

  ChangeAddress() async {
    var response = await ApiHelper().post(
      endpoint: "common/updateProfile",
      body: {
        "first_name": firstnameController.text,
        "last_name": lastnameController.text,
        "email": emailIdController.text,
        "dob" : "21/06/1998",
        "id" : UID
      },
    ).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('edit profile api successful:');
        FinalUserlist = jsonDecode(response);


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
      Fluttertoast.showToast(
        msg: "Failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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
          style: TextStyle(color: Colors.teal[900]),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 10, right: 10, top: 20, bottom: 20),
            child: TextFormField(
              controller: firstnameController,
              decoration: InputDecoration(
                labelText: "First Name",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter a valid name';
                } else {
                  return null;
                }
              },
              textInputAction: TextInputAction.done,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10, right: 10, top: 20, bottom: 20),
            child: TextFormField(
              controller: lastnameController,
              decoration: InputDecoration(
                labelText: "Last Name",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
              ),validator: (value) {
              if (value!.isEmpty) {
                return 'Enter a valid name';
              } else {
                return null;
              }
            },
              textInputAction: TextInputAction.done,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10, right: 10, top: 20, bottom: 20),
            child: TextFormField(
              controller: emailIdController,
              decoration: InputDecoration(
                labelText: "Email Id ",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
              ),
              validator: (value) {
              if (value!.isEmpty || !value.contains('@')) {
                return 'Enter a valid Email ID';
              } else {
                return null;
              }
            },
              textInputAction: TextInputAction.done,
            ),
          ),
          SizedBox(
            width: 350,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                ChangeAddress();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shadowColor: Colors.teal[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  )),
              child: Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }
}
