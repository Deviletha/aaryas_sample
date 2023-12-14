import 'dart:convert';
import 'package:aaryas_sample/Config/ApiHelper.dart';
import 'package:aaryas_sample/screens/bottom_nav_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/colors.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Map? user;
  List? userList;
  String? uID;
  bool showPass = true;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  apiForLogin() async {
    String username = usernameController.text.toString();
    String password = passwordController.text.toString();
    if (username.isNotEmpty && password.isNotEmpty) {
      var response =
      await ApiHelper().post(endpoint: "common/authenticate", body: {
        'username': username,
        'password': password,
      }).catchError((err) {});

      if (response != null) {
        var jsonResponse = jsonDecode(response);
        if (jsonResponse is List && jsonResponse.isNotEmpty) {
          if (jsonResponse[0]["error"] == "username or password is incorrect") {
            // Username or password is incorrect
            debugPrint('API failed:');
            Fluttertoast.showToast(
              msg: "Username or password is incorrect",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          } else {
            // Successful login
            setState(() {
              debugPrint('API successful:');
              userList = jsonResponse;
              if (kDebugMode) {
                print(response);
              }
            });
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString("UID", userList![0]["id"].toString());

            Fluttertoast.showToast(
              msg: "Login success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BottomNav()),
            );
          }
        }
      } else {
        // API call failed
        debugPrint('API failed:');
        Fluttertoast.showToast(
          msg: "Login failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      // Username or password is empty
      Fluttertoast.showToast(
        msg: "Please enter username and password",
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
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              "Login",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 40, bottom: 20),
              child: TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Iconsax.user),
                  hintText: "Phone Number",
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none)
                ),
                textInputAction: TextInputAction.next,
                validator: (uname) {
                  if (uname!.isEmpty || !uname.contains('')) {
                    return 'Enter a valid Phone Number';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 20, bottom: 20),
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
                        showPass == true
                            ? Iconsax.eye_slash
                            : Iconsax.eye,
                      )),
                  hintText: "Password",
                  labelText: "Password",
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none)
                ),
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
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    apiForLogin();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(ColorT.themeColor),
                    shadowColor:Color(ColorT.themeColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10),
                      ),
                    ),
                  ),
                  child: Text("Login"),
                ),
              ),
            ),
            TextButton(
              child: Text("Don't have an account? Sign Up",
                  style: TextStyle(fontSize: 15, color: Colors.black45)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignupPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
