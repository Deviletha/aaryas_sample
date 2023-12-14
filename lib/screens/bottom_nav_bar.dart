import 'package:aaryas_sample/screens/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/colors.dart';
import 'cart_page.dart';
import 'accounts_page/account_page.dart';
import 'home/homepage.dart';

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
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black,
        selectedItemColor: Color(ColorT.themeColor),
        elevation: 0,
        iconSize: 25,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home,),
            label: "HOME",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.bag_2,),
            label: "CART",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.heart,),
            label: "FAV",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.user,),
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
