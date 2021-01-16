import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShimmerCheckoutAddress extends StatelessWidget {
  final Size size;

  const ShimmerCheckoutAddress({
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 25.0,
            width: size.width * 0.5,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            height: 22.0,
            width: size.width * 0.3,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            height: 22.0,
            width: size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            height: 22.0,
            width: size.width * 0.6,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ],
      ),
    );
  }
}
