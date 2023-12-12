import 'package:aaryas_sample/screens/accounts_page/editprofile.dart';
import 'package:aaryas_sample/screens/accounts_page/password.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Do you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () async {
                Navigator.of(context).pop();

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
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
        ),
      ),
      body: Column(
        children: [
          Divider(
            thickness: 1,
          ),
          ListTile(
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChangeProfile();
            })),
            leading: Icon(
              Iconsax.profile_tick,
              color: Colors.black,
              size: 30,
            ),
            title: Text("Edit Profile", style: TextStyle(fontSize: 18)),
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChangeProfile();
            })),
            leading: Icon(
              Iconsax.keyboard,
              color: Colors.black,
              size: 30,
            ),
            title: Text("Change Password", style: TextStyle(fontSize: 18)),
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            onTap: () => _showLogoutConfirmationDialog(),
            leading: Icon(
              Iconsax.logout,
              color: Colors.black,
              size: 30,
            ),
            title: Text("Logout from App", style: TextStyle(fontSize: 18)),
          ),
          Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
