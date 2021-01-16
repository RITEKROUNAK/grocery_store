import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class FullScreenImageScreen extends StatelessWidget {
  final List images;

  const FullScreenImageScreen({this.images});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExtendedImageGesturePageView.builder(
        itemBuilder: (BuildContext context, int index) {
          var item = images[index];
          // Widget image = ExtendedImage.network(
          //   item,
          //   fit: BoxFit.contain,
          //   mode: ExtendedImageMode.gesture,
          // );
          Widget image = ExtendedImage.network(
            images[index],
            mode: ExtendedImageMode.gesture,
          );

          image = Container(
            child: image,
            padding: EdgeInsets.all(5.0),
          );

          return image;
        },
        itemCount: images.length,
        onPageChanged: (int index) {},
        controller: PageController(
          initialPage: 0,
        ),
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
