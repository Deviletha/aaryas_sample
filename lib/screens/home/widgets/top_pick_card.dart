import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TopPicksTile extends StatelessWidget {
  final String imagePath;
  final void Function()? onTap;
  const TopPicksTile({super.key, required this.imagePath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 200,
        width: 330,
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
                    colorFilter:
                    ColorFilter.mode(Colors.grey, BlendMode.color))),
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
