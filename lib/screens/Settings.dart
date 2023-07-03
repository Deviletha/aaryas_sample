import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SETTINGS",style:
        TextStyle(color: Colors.teal[900], fontWeight: FontWeight.bold),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.person_outline_outlined,
                  size: 25,
                ),
                SizedBox(
                  width: 10,
                ),
                TextButton(
                    onPressed: () {},
                    child: Text("Edit Profile",
                        style: TextStyle(fontSize: 20)))
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.keyboard_outlined,
                  size: 25,
                ),
                SizedBox(
                  width: 10,
                ),
                TextButton(
                    onPressed: () {},
                    child: Text("Change Password",
                        style: TextStyle(fontSize: 20)))
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.logout_outlined,
                  size: 25,
                ),
                SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: () async {
                    // Clear the user session data
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove("UID");
                    Fluttertoast.showToast(
                      msg: "Logged out",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(color: Colors.teal,fontSize: 20),
                  ),
                )

              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
