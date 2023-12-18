import 'dart:convert';
import 'package:aaryas_sample/Config/ApiHelper.dart';
import 'package:aaryas_sample/screens/registration/login_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/colors.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String? uID;
  Map? signupList;

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    uID = prefs.getString("UID");
  }

  bool showPass = true;
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController postalController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  Future<void> apiForSignup() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // Handle case where user denies permission
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      double latitude = position.latitude;
      double longitude = position.longitude;

      var response = await ApiHelper().post(endpoint: "common/signUP", body: {
        "contact": contactController.text,
        "email": emailController.text,
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "address": addressController.text,
        "state": stateController.text,
        "location": locationController.text,
        "postal": postalController.text,
        "password": passwordController.text,
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
      }).catchError((err) {});
      if (response != null) {
        setState(() async {
          debugPrint('api successful:');
          signupList = jsonDecode(response);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("UID", signupList![0]["id"].toString());
          checkUser();
          Fluttertoast.showToast(
            msg: "Signup success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        });
      } else {
        debugPrint('api failed:');
      }
    } catch (err) {
      debugPrint('An error occurred: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "SignUp",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 5),
                  child: TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        labelText: "First Name",
                        prefixIcon: Icon(Iconsax.user, color: Colors.black),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a valid name';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                  child: TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                        fillColor: Colors.blue,
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        labelText: "Last Name",
                        prefixIcon: Icon(Iconsax.user, color: Colors.black),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a valid name';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        labelText: "Email ID",
                        prefixIcon: Icon(Iconsax.message, color: Colors.black),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Enter a valid Email ID';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                  child: TextFormField(
                    controller: contactController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        labelText: "Mobile",
                        prefixIcon: Icon(Iconsax.mobile, color: Colors.black),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter a valid Number";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: showPass,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
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
                              showPass == true
                                  ? Iconsax.eye_slash
                                  : Iconsax.eye,
                            )),
                        labelText: "Password",
                        prefixIcon: Icon(Iconsax.lock, color: Colors.black),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                    textInputAction: TextInputAction.done,
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
                      const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                  child: TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        labelText: "Address",
                        prefixIcon:
                            Icon(Iconsax.buildings, color: Colors.black),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a valid Address';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                  child: TextFormField(
                    controller: stateController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        labelText: "State",
                        prefixIcon: Icon(Iconsax.location, color: Colors.black),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a valid State';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                  child: TextFormField(
                    controller: locationController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        labelText: "Town",
                        prefixIcon: Icon(Iconsax.building, color: Colors.black),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a valid location';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                  child: TextFormField(
                    controller: postalController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        labelText: "Postal code",
                        prefixIcon: Icon(Iconsax.keyboard, color: Colors.black),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a valid Postal code';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      apiForSignup();
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (context) => LoginPage()));
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
                    child: Text("Sign Up"),
                  ),
                ),
                TextButton(
                  child: Text("Already have an account? Login",
                      style: TextStyle(fontSize: 15, color: Colors.black45)),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
