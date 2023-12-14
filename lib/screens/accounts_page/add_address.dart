import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/ApiHelper.dart';
import '../../theme/colors.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  String? uID;


  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uID = prefs.getString("UID");
    });
  }

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final localityController = TextEditingController();
  final postalController = TextEditingController();
  final addressController = TextEditingController();
  final locationController = TextEditingController();
  final stateController = TextEditingController();

  Future<void> addAddress() async {
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

      print(latitude);
      print(longitude);

      var response =
          await ApiHelper().post(endpoint: "user/saveAddress", body: {
        "first_name": nameController.text.toString(),
        "contact": contactController.text.toString(),
        "locality": localityController.text.toString(),
        "postal": postalController.text.toString(),
        "address": addressController.text.toString(),
        "location": locationController.text.toString(),
        "state": stateController.text.toString(),
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
        "userid": uID.toString()
      });
      print(response);
      if (response != null) {
        setState(() {
          debugPrint('save address API successful:');

          if (kDebugMode) {
            print(response);
          }
        });
        // Navigate back to the previous page after the API call is successful
        Navigator.pop(context);
      } else {
        debugPrint('API failed:');
      }
    } catch (err) {
      debugPrint('An error occurred: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              addAddress();
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
            child: Text("Add Address", ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Text(
            "Haii, User!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 35, color: Color(ColorT.themeColor), fontWeight: FontWeight.bold),
          ),
          Text(
            "Complete your profile",
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 1
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                prefixIcon:
                    Icon(Icons.account_circle_outlined, color: Colors.black),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                    borderRadius: BorderRadius.zero),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your name';
                } else {
                  return null;
                }
              },
              textInputAction: TextInputAction.next,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: TextFormField(
              controller: localityController,
              decoration: InputDecoration(
                prefixIcon:
                    Icon(Icons.location_city_rounded, color: Colors.black),
                labelText: "City",
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.zero),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your city';
                } else {
                  return null;
                }
              },
              textInputAction: TextInputAction.next,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: TextFormField(
              controller: contactController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon:
                    Icon(Icons.phone_android_outlined, color: Colors.black),
                labelText: "Mobile",
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.zero),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your Number';
                } else {
                  return null;
                }
              },
              textInputAction: TextInputAction.next,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: "Address",
                prefixIcon: Icon(Icons.mail_outlined, color: Colors.black),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.zero),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your address';
                } else {
                  return null;
                }
              },
              textInputAction: TextInputAction.next,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: TextFormField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: "Town",
                prefixIcon: Icon(Icons.villa_outlined, color: Colors.black),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.zero),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your town';
                } else {
                  return null;
                }
              },
              textInputAction: TextInputAction.next,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: postalController,
              decoration: InputDecoration(
                labelText: "Pin code",
                prefixIcon:
                    Icon(Icons.person_pin_circle_outlined, color: Colors.black),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.zero),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter you pin code';
                } else {
                  return null;
                }
              },
              textInputAction: TextInputAction.next,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
            child: TextFormField(
              controller: stateController,
              decoration: InputDecoration(
                labelText: "State",
                prefixIcon: Icon(
                  Icons.edit_location_alt_outlined,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.zero),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your state';
                } else {
                  return null;
                }
              },
              textInputAction: TextInputAction.done,
            ),
          )
        ],
      ),
    );
  }
}
