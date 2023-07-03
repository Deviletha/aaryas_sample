import 'dart:convert';
import 'package:aaryas_sample/Config/ApiHelper.dart';
import 'package:aaryas_sample/screens/BottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SignUp_page.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Map? user;
  List? UserList;

  bool showpass = true;

  final usernameController = TextEditingController();
  final passController = TextEditingController();

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? UID = prefs.getString("UID");
    print(UID);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Text("Login",style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 40, bottom: 20),
              child: TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.account_box_sharp),
                  hintText: "Phone Number",
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),),
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
                controller: passController,
                obscureText: showpass,
                obscuringCharacter: "*",
                decoration: InputDecoration(
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
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),),
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

            SizedBox(
              width: 350,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  // Get the entered username and password
                  String username = usernameController.text.toString();
                  String password = passController.text.toString();

                  // Check if the username and password are not empty
                  if (username.isNotEmpty && password.isNotEmpty) {
                    // Make the API call with the entered credentials
                    var response = await ApiHelper().post(endpoint: "common/authenticate", body: {
                      'username': username,
                      'password': password,
                    }).catchError((err) {});
                    if (response != null) {
                      // API call succeeded
                      setState(() {
                        debugPrint('API successful:');
                        UserList = jsonDecode(response);
                      });
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString("UID", UserList![0]["id"].toString());
                      checkUser();
                      Fluttertoast.showToast(
                        msg: "Login success",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      // Navigate to the home screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BottomNav()),
                      );
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
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shadowColor: Colors.teal[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),topRight: Radius.circular(10)),
                    )),
                child: Text("Login"),
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
