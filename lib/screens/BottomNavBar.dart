import 'package:aaryas_sample/screens/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'Cart_page.dart';
import 'Profile_page.dart';
import 'homepage.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  int selectindex=0;

  List body= <Widget>[
    HomePage(),
    Cart_page(),
    Wishlist(),
    Profile_page()
  ];

  void onitemtapped(int index){
    setState(() {
      selectindex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.black45,
          selectedItemColor: Colors.teal,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
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
              icon: Icon(Icons.account_circle_sharp),
              label: "ACCOUNT",
            ),
          ],
          currentIndex: selectindex,
          onTap: onitemtapped,
        ),
      ),
      body: body.elementAt(selectindex),
    );
  }
}
