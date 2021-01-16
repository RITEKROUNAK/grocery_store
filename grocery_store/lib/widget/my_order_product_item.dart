import 'package:grocery_store/config/config.dart';
import 'package:grocery_store/models/my_order.dart';
import 'package:grocery_store/screens/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyOrderProductItem extends StatelessWidget {
  final OrderProduct product;

  const MyOrderProductItem({this.product});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductScreen(
              productId: product.id,
            ),
          ),
        );
      },
      child: Container(
        height: 120.0,
        width: size.width,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 104.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(11.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11.0),
                child: Center(
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/icons/category_placeholder.png',
                    image: product.productImage,
                    fadeInDuration: Duration(milliseconds: 250),
                    fit: BoxFit.cover,
                    fadeInCurve: Curves.easeInOut,
                    fadeOutDuration: Duration(milliseconds: 150),
                    fadeOutCurve: Curves.easeInOut,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 12.0,
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '${product.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${product.unitQuantity}',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Category: ${product.category}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 3.0, right: 3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '${Config().currency}${product.price}',
                            style: GoogleFonts.poppins(
                              color: Colors.green.shade700,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            'Qty: ${product.quantity}',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
