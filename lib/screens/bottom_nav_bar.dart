import 'package:aaryas_sample/screens/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'accounts_page/account_page.dart';
import 'homepage.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectIndex = 0;

  List body = <Widget>[HomePage(), CartPage(), Wishlist(), Accounts()];

  void onItemTapped(int index) {
    setState(() {
      selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 15,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        unselectedItemColor: Colors.black45,
        selectedItemColor: Colors.teal,
        elevation: 0,
        iconSize: 25,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "HOME",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: "CART",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_sharp),
            label: "FAV",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: "ACCOUNT",
          ),
        ],
        currentIndex: selectIndex,
        onTap: onItemTapped,
      ),
      body: body.elementAt(selectIndex),
    );
  }
}
