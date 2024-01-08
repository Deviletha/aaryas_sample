import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CartTile extends StatelessWidget {
  final String itemName;
  final String imagePath;
  final String price;
  final String quantity;
  final void Function()? onTap;
  final void Function()? increment;
  final void Function()? decrement;

  const CartTile(
      {super.key,
      required this.itemName,
      required this.imagePath,
      required this.price,
      required this.quantity,
      this.onTap,
      this.increment,
      this.decrement});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imagePath,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/aryas_logo.png",
                              ),
                              colorFilter: ColorFilter.mode(
                                  Colors.grey, BlendMode.color))),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemName,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "₹$price",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: decrement,
                            icon: Icon(
                              Icons.remove_circle_outline_rounded,
                              size: 25,
                            )),
                        Card(
                          color: Colors.grey.shade700,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 8, bottom: 8),
                            child: Text(
                              quantity,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: increment,
                            icon: Icon(
                              Icons.add_circle_outline_rounded,
                              size: 25,
                            )),
                        IconButton(
                            onPressed: onTap,
                            icon: Icon(
                              Iconsax.trash,
                              color: Colors.red,
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
