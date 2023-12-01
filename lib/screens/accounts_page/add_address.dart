import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/ApiHelper.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {

  String? uID;
  String? data;
  Map? responseData;
  List? userAddressList;

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uID = prefs.getString("UID");
    });
    AddAddress();
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
      var response = await ApiHelper().post(endpoint: "user/saveAddress", body: {
        "name": nameController.text,
        "contact": contactController.text,
        "locality": localityController.text,
        "postal" : postalController.text,
        "address" : addressController.text,
        "location" : locationController.text,
        "state" : stateController.text,
        "latitude": "123",
        "longitude": "1234",
        "userid" : data
      });
      if (response != null) {
        setState(() {
          debugPrint('profile api successful:');
          data = response.toString();
          responseData = jsonDecode(response);
          if (responseData?["status"] is List<dynamic>) {
            userAddressList = responseData?["status"] as List<dynamic>?;
          } else {
            userAddressList = null; // or handle the case when the response is not a list
          }
          if (kDebugMode) {
            print(responseData.toString());
          }

        });
      }

      else {
        debugPrint('api failed:');

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
      body: ListView(
        children: [
          Text("Hey, User!",textAlign: TextAlign.center,
            style: TextStyle(fontSize: 35,color: Colors.teal[900]),),
          Text("Complete your profile",textAlign: TextAlign.center,),
          Padding(
            padding: const EdgeInsets.only(
                left: 10, right: 10, top: 20),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                prefixIcon: Icon(Icons.account_circle_outlined,color: Colors.black),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
              ),validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your name';
              } else {
                return null;
              }
            },
              textInputAction: TextInputAction.done,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10, right: 10, top: 20),
            child: TextFormField(
              controller: localityController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_city_rounded,color: Colors.black),
                labelText: "City",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
              ),validator: (value) {
              if (value!.isEmpty) {
                return 'Enter your city';
              } else {
                return null;
              }
            },
              textInputAction: TextInputAction.done,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10, right: 10, top: 20),
            child: TextFormField(
              controller: contactController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone_android_outlined,color: Colors.black),
                labelText: "Mobile",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
              ),validator: (value) {
              if (value!.isEmpty) {
                return 'Enter your Number';
              } else {
                return null;
              }
            },
              textInputAction: TextInputAction.done,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10, right: 10, top: 20),
            child: TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: "Address",
                prefixIcon: Icon(Icons.mail_outlined,color: Colors.black),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
              ),validator: (value) {
              if (value!.isEmpty) {
                return 'Enter your address';
              } else {
                return null;
              }
            },
              textInputAction: TextInputAction.done,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10, right: 10, top: 20),
            child: TextFormField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: "Town",
                prefixIcon: Icon(Icons.villa_outlined,color: Colors.black),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
              ),validator: (value) {
              if (value!.isEmpty) {
                return 'Enter your town';
              } else {
                return null;
              }
            },
              textInputAction: TextInputAction.done,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10, right: 10, top: 20),
            child: TextFormField(
              controller: postalController,
              decoration: InputDecoration(
                labelText: "Pin code",
                prefixIcon: Icon(Icons.person_pin_circle_outlined,color: Colors.black),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
              ),validator: (value) {
              if (value!.isEmpty) {
                return 'Enter you pin code';
              } else {
                return null;
              }
            },
              textInputAction: TextInputAction.done,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10, right: 10, top: 20, bottom: 20),
            child: TextFormField(
              controller: stateController,
              decoration: InputDecoration(
                labelText: "State",
                prefixIcon: Icon(Icons.edit_location_alt_outlined,color: Colors.black,),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
              ),validator: (value) {
              if (value!.isEmpty) {
                return 'Enter your state';
              } else {
                return null;
              }
            },
              textInputAction: TextInputAction.done,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: ElevatedButton(
              onPressed: () {
                AddAddress();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shadowColor: Colors.teal[300],minimumSize: Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  )),
              child: Text("Change Address"),
            ),
          ),
        ],
      ),
    );
  }
}