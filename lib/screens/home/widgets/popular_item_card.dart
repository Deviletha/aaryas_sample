import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PopularItemTile extends StatelessWidget {
  final String itemName;
  final String imagePath;
  final void Function()? onTap;
  const PopularItemTile({super.key, required this.itemName, required this.imagePath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(360))),
            height: 60,
            width: 60,
            clipBehavior: Clip.antiAlias,
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
                        colorFilter:
                        ColorFilter.mode(Colors.grey, BlendMode.color))),
              ),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            itemName,
            style: TextStyle(fontSize: 12),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
