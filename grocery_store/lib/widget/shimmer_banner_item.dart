import 'package:flutter/material.dart';

class ShimmerBannerItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Icon(
          Icons.image,
          color: Colors.grey.withOpacity(0.3),
          size: 50.0,
        ),
      ),
    );
  }
}
