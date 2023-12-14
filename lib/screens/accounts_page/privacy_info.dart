import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyInfo extends StatefulWidget {
  const PrivacyInfo({Key? key}) : super(key: key);

  @override
  State<PrivacyInfo> createState() => _PrivacyInfoState();
}

class _PrivacyInfoState extends State<PrivacyInfo> {

  final String privacyPolicyUrl = "https://hotelaryas.com/privacy_policy";
  final String termsConditionUrl = "https://hotelaryas.com/terms_and_conditions";
  final String refundPolicyUrl = "https://hotelaryas.com/refund_policy";
  final String shippingAndDeliveryPolicyUrl = "https://hotelaryas.com/shipping_policy";
  final String contactUsUrl = "https://hotelaryas.com/contact_us";
  final String aboutUsUrl = "https://hotelaryas.com";

  Future<void> _launchUrl(String url) async {
    try {
      final bool nativeLaunch = await launch(
        url,
        forceWebView: false,
        enableJavaScript: true,
      );

      if (!nativeLaunch) {
        throw 'Could not launch $url';
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
          Divider(thickness: 1),
          ListTile(
            onTap: () => _launchUrl(privacyPolicyUrl),
            title: Text("Privacy Policy", style: TextStyle(fontSize: 18)),
          ),
          Divider(thickness: 1),
          ListTile(
            onTap: () => _launchUrl(termsConditionUrl),
            title: Text("Terms & Conditions", style: TextStyle(fontSize: 18)),
          ),
          Divider(thickness: 1),
          ListTile(
            onTap: () => _launchUrl(refundPolicyUrl),
            title: Text("Cancellation & Refund Policy", style: TextStyle(fontSize: 18)),
          ),
          Divider(thickness: 1),
          ListTile(
            onTap: () => _launchUrl(shippingAndDeliveryPolicyUrl),
            title: Text("Shipping & Delivery Policy", style: TextStyle(fontSize: 18)),
          ),
          Divider(thickness: 1),
          ListTile(
            onTap: () => _launchUrl(contactUsUrl),
            title: Text("Contact Us", style: TextStyle(fontSize: 18)),
          ),
          Divider(thickness: 1),
          ListTile(
            onTap: () => _launchUrl(aboutUsUrl),
            title: Text("About Us", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
