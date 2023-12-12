import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",

        ),
      ),
      body: Center(
        child: Text(
          "No Notification",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
