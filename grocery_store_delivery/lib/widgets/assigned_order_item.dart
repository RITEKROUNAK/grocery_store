import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store_delivery/config/config.dart';
import 'package:grocery_store_delivery/models/order.dart';
import 'package:grocery_store_delivery/screens/order_screens/delivery_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AssignedOrderItem extends StatelessWidget {
  final Size size;
  final Order order;
  final bool previous;
  const AssignedOrderItem({
    @required this.size,
    @required this.order,
    @required this.previous,
  });

  _launchCaller(String mobileNo) async {
    var url = "tel:$mobileNo";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      // padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              top: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Order id: ${order.orderId}',
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              color: Colors.black87,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'Items: ${order.products.length}',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeliveryDetailsScreen(
                              order: order,
                              previous: previous,
                            ),
                          ),
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(
                            width: 1.0,
                            color: Colors.black.withOpacity(0.5),
                            style: BorderStyle.solid),
                      ),
                      child: Text(
                        'Delivery Details',
                        style: GoogleFonts.poppins(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Total amount: ${Config().currency}${order.charges.totalAmt}',
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Delivery status: ',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      '${order.orderStatus}',
                      style: GoogleFonts.poppins(
                        color: Colors.green.shade600,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   height: 5.0,
                // ),
                // false
                //     ? SizedBox()
                //     : Text(
                //         'Delivered on: 25 Jun 2020, 10:10 am',
                //         style: GoogleFonts.poppins(
                //           color: Colors.black.withOpacity(0.8),
                //           fontSize: 14.0,
                //           fontWeight: FontWeight.w500,
                //           letterSpacing: 0.3,
                //         ),
                //       ),
                // SizedBox(
                //   height: 5.0,
                // ),
                // Text(
                //   'Payment status: Cash on delivery/Paid',
                //   style: GoogleFonts.poppins(
                //     color: Colors.black.withOpacity(0.8),
                //     fontSize: 14.0,
                //     fontWeight: FontWeight.w500,
                //     letterSpacing: 0.3,
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            width: size.width,
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Customer Details',
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Text(
                      'Customer name: ',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.65),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      '${order.custDetails.name}',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Mobile no.: ',
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.65),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text(
                          '${order.custDetails.mobileNo}',
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    !previous
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Material(
                              color: Theme.of(context).primaryColor,
                              child: InkWell(
                                splashColor: Colors.white.withOpacity(0.5),
                                onTap: () {
                                  //call
                                  _launchCaller(
                                      '${order.custDetails.mobileNo}');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  width: 32.0,
                                  height: 30.0,
                                  child: Icon(
                                    Icons.call,
                                    color: Colors.white,
                                    size: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  'Delivery address:',
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.65),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    '${order.custDetails.address}',
                    style: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
