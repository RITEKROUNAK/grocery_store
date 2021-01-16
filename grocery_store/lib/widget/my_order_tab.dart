import 'package:grocery_store/models/my_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'my_order_item.dart';

class MyOrderTab extends StatefulWidget {
  const MyOrderTab({
    @required this.size,
    @required this.orders,
  });

  final Size size;
  final List<MyOrder> orders;

  @override
  _MyOrderTabState createState() => _MyOrderTabState();
}

class _MyOrderTabState extends State<MyOrderTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.orders.length > 0
        ? ListView.separated(
            padding: const EdgeInsets.only(bottom: 15.0, top: 5.0),
            itemBuilder: (context, index) {
              return MyOrderItem(
                size: widget.size,
                myOrder: widget.orders[index],
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 15.0,
              );
            },
            itemCount: widget.orders.length,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/empty_prod.svg',
                width: widget.size.width * 0.6,
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'No orders found!',
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: GoogleFonts.poppins(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
            ],
          );
    ;
  }

  @override
  bool get wantKeepAlive => true;
}
