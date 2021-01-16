import 'package:grocery_store/blocs/my_orders_bloc/my_orders_bloc.dart';
import 'package:grocery_store/config/config.dart';
import 'package:grocery_store/models/my_order.dart';
import 'package:grocery_store/widget/cancel_order_dialog.dart';
import 'package:grocery_store/widget/cancelled_order_dialog.dart';
import 'package:grocery_store/widget/cancelling_order_dialog.dart';
import 'package:grocery_store/widget/cart_item.dart';
import 'package:grocery_store/widget/my_order_product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MyOrderDetailScreen extends StatefulWidget {
  final MyOrder myOrder;

  const MyOrderDetailScreen({this.myOrder});

  @override
  _MyOrderDetailScreenState createState() => _MyOrderDetailScreenState();
}

class _MyOrderDetailScreenState extends State<MyOrderDetailScreen> {
  MyOrdersBloc myOrdersBloc;
  String _orderStatus;
  bool isCancelled;

  @override
  void initState() {
    super.initState();

    isCancelled = false;
    _orderStatus = widget.myOrder.orderStatus;

    myOrdersBloc = BlocProvider.of<MyOrdersBloc>(context);

    myOrdersBloc.listen((state) {
      if (state is CancelOrderInProgressState) {
        //show dialog
        if (isCancelled) {
          showCancellingOrderDialog();
        }
      }
      if (state is CancelOrderFailedState) {
        //show failed dialog
        if (isCancelled) {
          // showCancellingOrderDialog();
        }
      }
      if (state is CancelOrderCompletedState) {
        if (isCancelled) {
          Navigator.pop(context);
          showCancelledOrderDialog();
          setState(() {
            _orderStatus = 'Cancelled';
          });
          myOrdersBloc.add(GetAllOrdersEvent(widget.myOrder.custDetails.uid));
        }
      }
    });
  }

  showCancelledOrderConfimationDialog(Size size) async {
    bool isProceeded = await showDialog(
      barrierDismissible: false,
      context: context,
      child: CancelOrderDialog(
        myOrder: widget.myOrder,
        myOrdersBloc: myOrdersBloc,
      ),
    );

    if (isProceeded != null) {
      if (isProceeded) {
        isCancelled = true;
      }
    }
  }

  showCancelledOrderDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CancelledOrderDialog();
      },
    );
  }

  showCancellingOrderDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CancellingOrderDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            width: size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.white.withOpacity(0.5),
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                width: 38.0,
                                height: 35.0,
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          'Order Details',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(bottom: 30.0),
              children: <Widget>[
                ListView.separated(
                  padding: const EdgeInsets.only(top: 20.0),
                  itemCount: widget.myOrder.products.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return MyOrderProductItem(
                      product: widget.myOrder.products[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 20.0);
                  },
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0.0),
                        blurRadius: 15.0,
                        spreadRadius: 2.0,
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Order details: ',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Order id: ',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.65),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            '${widget.myOrder.orderId}',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        'User details:',
                        style: GoogleFonts.poppins(
                          color: Colors.black.withOpacity(0.65),
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${widget.myOrder.custDetails.name}',
                              style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                            widget.myOrder.custDetails.mobileNo.isEmpty
                                ? SizedBox()
                                : Text(
                                    '${widget.myOrder.custDetails.mobileNo}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                            Text(
                              '${widget.myOrder.custDetails.address}',
                              style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.75),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Order status: ',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.65),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            _orderStatus,
                            style: GoogleFonts.poppins(
                              color: widget.myOrder.orderStatus == 'Cancelled'
                                  ? Colors.red.shade700
                                  : Colors.black.withOpacity(0.8),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Order date: ',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.65),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${new DateFormat('dd MMM yyyy, hh:mm a').format(widget.myOrder.orderTimestamp.toDate())}',
                              style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      widget.myOrder.deliveryTimestamp != null
                          ? Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 8.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Delivery date: ',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.65),
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${new DateFormat('dd MMM yyyy, hh:mm a').format(widget.myOrder.deliveryTimestamp.toDate())}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black.withOpacity(0.8),
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Payment method: ',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.65),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.myOrder.paymentMethod == 'COD'
                                  ? 'Cash on delivery'
                                  : 'Credit/Debit card',
                              style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      widget.myOrder.paymentMethod == 'CARD' ||
                              widget.myOrder.paymentMethod == 'RAZORPAY' ||
                              widget.myOrder.paymentMethod == 'PAYPAL'
                          ? Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 8.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Transaction id: ',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.65),
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${widget.myOrder.transactionId}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black.withOpacity(0.8),
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                widget.myOrder.orderStatus == 'Out for delivery'
                    ? Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            width: double.infinity,
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 0.0),
                                  blurRadius: 15.0,
                                  spreadRadius: 2.0,
                                  color: Colors.black.withOpacity(0.05),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Delivery details: ',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Divider(),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Name: ',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.65),
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    Text(
                                      '${widget.myOrder.deliveryDetails.name}',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.8),
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Mobile no.: ',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.65),
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    Text(
                                      '${widget.myOrder.deliveryDetails.mobileNo}',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.8),
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'OTP: ',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.65),
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    Text(
                                      '${widget.myOrder.deliveryDetails.otp}',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.8),
                                        fontSize: 14.5,
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
                      )
                    : SizedBox(),
                widget.myOrder.orderStatus == 'Cancelled'
                    ? Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            width: double.infinity,
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 0.0),
                                  blurRadius: 15.0,
                                  spreadRadius: 2.0,
                                  color: Colors.black.withOpacity(0.05),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Order cancellation details: ',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Divider(),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Cancelled by: ',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.65),
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${widget.myOrder.cancelledBy}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black.withOpacity(0.8),
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Cancellation reason: ',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.65),
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${widget.myOrder.reason}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black.withOpacity(0.8),
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Refund status: ',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.65),
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${widget.myOrder.refundStatus}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black.withOpacity(0.8),
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                widget.myOrder.paymentMethod == 'CARD' ||
                                        widget.myOrder.paymentMethod ==
                                            'RAZORPAY' ||
                                        widget.myOrder.paymentMethod == 'PAYPAL'
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Refund transaction id: ',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black
                                                      .withOpacity(0.65),
                                                  fontSize: 14.5,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  widget.myOrder.refundStatus ==
                                                          'Processed'
                                                      ? '${widget.myOrder.refundTransactionId}'
                                                      : 'NA',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black
                                                        .withOpacity(0.8),
                                                    fontSize: 14.5,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            'NOTE: You\'ll receive your refund in 5-10 business days',
                                            style: GoogleFonts.poppins(
                                              color:
                                                  Colors.brown.withOpacity(0.8),
                                              fontSize: 14.5,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0.0),
                        blurRadius: 15.0,
                        spreadRadius: 2.0,
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Price details: ',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            'Total selling amount: ',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.65),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            '${Config().currency}${widget.myOrder.charges.orderAmt}',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            'Discount: ',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.65),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            '-${Config().currency}${widget.myOrder.charges.discountAmt}',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            'Shipping: ',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.65),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            '${Config().currency}${widget.myOrder.charges.shippingAmt}',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            'Tax amount: ',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.65),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            '${Config().currency}${widget.myOrder.charges.taxAmt}',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            'Total amount: ',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.65),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            '${Config().currency}${widget.myOrder.charges.totalAmt}',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                (_orderStatus == 'Processing' ||
                        _orderStatus == 'Out for delivery')
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 25.0,
                            ),
                            Container(
                              height: 43.0,
                              width: size.width,
                              child: FlatButton(
                                onPressed: () {
                                  //TODO: after cancelling the order send back a cancel status to previous activity to refresh the orders

                                  showCancelledOrderConfimationDialog(size);
                                },
                                color: Colors.red.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Text(
                                  'Cancel Order',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
