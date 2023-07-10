import 'dart:convert';
import 'package:aaryas_sample/Config/ApiHelper.dart';
import 'package:aaryas_sample/screens/Login_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String? UID;
  Map? signuplist;
  List? slist;

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    UID = prefs.getString("UID");
    print(UID);
  }

  bool showpass = true;
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

  apiforSignup() async {
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
      "latitude": latitudeController.text,
      "longitude": longitudeController.text,
    }).catchError((err) {});
    if (response != null) {
      setState(() async {
        debugPrint('api successful:');
        signuplist = jsonDecode(response);

        print(response);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("UID", signuplist![0]["id"].toString());
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
      Fluttertoast.showToast(
        msg: "failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  void initState() {
    apiforSignup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  padding:
                      const EdgeInsets.only(left: 10, right: 10,top: 10 ),
                  child: TextFormField(
                    controller: contactController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Contact",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
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
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 15, bottom: 15),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Email ID",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
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
                    controller: firstNameController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        hintText: "First Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
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
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Last Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
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
                    controller: addressController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Address",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
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
                        hintText: "State",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
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
                        hintText: "location",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
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
                        hintText: "Postal code",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
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
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: showpass,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                if (showpass) {
                                  showpass = false;
                                } else {
                                  showpass = true;
                                }
                              });
                            },
                            icon: Icon(
                              showpass == true
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            )),
                        hintText: "Password",
                        labelText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    textInputAction: TextInputAction.done,
                    validator: (Password) {
                      if (Password!.isEmpty || Password.length < 6) {
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
                    controller: latitudeController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Latitude",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter latitude';
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
                    controller: longitudeController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Longitude",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter longitude';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      apiforSignup();
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shadowColor: Colors.teal[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        )),
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
