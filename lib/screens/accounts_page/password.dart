import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/ApiHelper.dart';
import '../../theme/colors.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final passwordController = TextEditingController();
  final newPassController = TextEditingController();
  String? uID;
  bool showPass = true;
  Map? passList;
  Map? passList1;
  Map? finalPassword;
  int index = 0;

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    uID = prefs.getString("UID");
  }

  changePassword() async {
    var response = await ApiHelper().post(
      endpoint: "common/resetPassword",
      body: {
        "id": uID,
        "password": newPassController.text,
      },
    ).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('change password api successful:');
        passList = jsonDecode(response);
        passList1 = passList!["status"];
        finalPassword = passList1!["user"];

        Fluttertoast.showToast(
          msg: "Password Changed",
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
      debugPrint('reset password failed:');
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
          "Change Password",
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              changePassword();
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
            child: Text("Change Password"),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
            child: TextFormField(
              controller: passwordController,
              obscureText: showPass,
              obscuringCharacter: "*",
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        if (showPass) {
                          showPass = false;
                        } else {
                          showPass = true;
                        }
                      });
                    },
                    icon: Icon(
                      showPass == true ? Iconsax.eye_slash : Iconsax.eye,
                    )),
                labelText: "New Password",
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              textInputAction: TextInputAction.next,
              validator: (password) {
                if (password!.isEmpty || password.length < 6) {
                  return "Enter a valid Password, length should be greater than 6";
                } else {
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
            child: TextFormField(
              controller: newPassController,
              obscureText: showPass,
              obscuringCharacter: "*",
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        if (showPass) {
                          showPass = false;
                        } else {
                          showPass = true;
                        }
                      });
                    },
                    icon: Icon(
                      showPass == true ? Iconsax.eye_slash : Iconsax.eye,
                    )),
                labelText: "Confirm Password",
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              textInputAction: TextInputAction.done,
              validator: (password) {
                if (password!.isEmpty || password.length < 6) {
                  return "Enter the same Password, as above";
                } else {
                  return null;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
