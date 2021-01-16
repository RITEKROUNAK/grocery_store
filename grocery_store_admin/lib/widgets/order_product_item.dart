import 'package:ecommerce_store_admin/config/config.dart';
import 'package:ecommerce_store_admin/models/order.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderProductItem extends StatelessWidget {
  final Size size;
  final OrderProduct product;

  const OrderProductItem({
    @required this.size,
    @required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: size.width * 0.25,
                height: size.width * 0.25,
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
                      fit: BoxFit.cover,
                      fadeInDuration: Duration(milliseconds: 250),
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
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '${product.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      '${product.unitQuantity}',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.75),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '${Config().currency}${product.price}',
                          style: GoogleFonts.poppins(
                            color: Colors.green.shade700,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '${Config().currency}${product.price}',
                          style: GoogleFonts.poppins(
                            color: Colors.black54,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'Category: ${product.category}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.75),
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            'Quantity: ${product.quantity}',
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.75),
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          // SizedBox(
          //   height: 5.0,
          // ),
          // FlatButton(
          //   splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
          //   onPressed: () {},
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(12.0),
          //     side: BorderSide(
          //         width: 1.0,
          //         color: Colors.black.withOpacity(0.4),
          //         style: BorderStyle.solid),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: <Widget>[
          //       Icon(
          //         Icons.edit,
          //         size: 20.0,
          //         color: Colors.black.withOpacity(0.7),
          //       ),
          //       SizedBox(
          //         width: 8.0,
          //       ),
          //       Text(
          //         'View Product',
          //         maxLines: 1,
          //         overflow: TextOverflow.ellipsis,
          //         style: GoogleFonts.poppins(
          //           color: Colors.black.withOpacity(0.7),
          //           fontSize: 14.0,
          //           fontWeight: FontWeight.w600,
          //           letterSpacing: 0.3,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
