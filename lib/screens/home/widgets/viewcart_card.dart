import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../theme/colors.dart';

class ViewCartTile extends StatelessWidget {
  final void Function()? onTap;

  const ViewCartTile({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // backgroundBlendMode: BlendMode.srcATop, // Example blend mode
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: const [
              Color(ColorT.lightGreen),
              Color(ColorT.themeColor),
            ],
          ),
        ),
        height: 55,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 12, right: 10, top: 8, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your cart items",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Row(
                children: [
                  Text("View Cart",
                      style: TextStyle(color: Colors.white, fontSize: 15)),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    color: Colors.white,
                    height: 20,
                    width: 1,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Iconsax.shopping_bag,
                    color: Colors.white,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
