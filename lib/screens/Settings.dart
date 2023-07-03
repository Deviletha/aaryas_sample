import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: Text("Settings"),
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
                    onPressed: () {},
                    child: Text("Logout",
                        style: TextStyle(fontSize: 20)))
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
