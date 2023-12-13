import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyInfo extends StatefulWidget {
  const PrivacyInfo({super.key});

  @override
  State<PrivacyInfo> createState() => _PrivacyInfoState();
}

class _PrivacyInfoState extends State<PrivacyInfo> {
  final String websiteUrl = "https://hotelaryas.com/privacy_policy";

  Future<void> _launchWebsite() async {
    try {
      if (await canLaunch(websiteUrl)) {
        await launch(websiteUrl);
      } else {
        throw 'Could not launch $websiteUrl';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Info"),
      ),
      body: ListView(
        children: [
          Divider(
            thickness: 1,
          ),
          ListTile(
            onTap: _launchWebsite,
            title: Text("Privacy Policy", style: TextStyle(fontSize: 18)),
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            onTap: () {},
            title: Text("Terms & Conditions", style: TextStyle(fontSize: 18)),
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            onTap: () {},
            title: Text("Cancellation & Refund Policy", style: TextStyle(fontSize: 18)),
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            onTap: () {},
            title: Text("Disclaimer Policy", style: TextStyle(fontSize: 18)),
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            onTap: () {},
            title: Text("Shipping & Delivery Policy", style: TextStyle(fontSize: 18)),
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            onTap: () {},
            title: Text("Contact Us", style: TextStyle(fontSize: 18)),
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            onTap: () {},
            title: Text("About Us", style: TextStyle(fontSize: 18)),
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            onTap: () {},
            title: Text("Privacy Policy", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
