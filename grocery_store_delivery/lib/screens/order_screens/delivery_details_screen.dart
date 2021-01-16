import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store_delivery/blocs/manage_delivery_bloc/assigned_delivery_orders_bloc.dart';
import 'package:grocery_store_delivery/blocs/manage_delivery_bloc/manage_delivery_bloc.dart';
import 'package:grocery_store_delivery/config/config.dart';
import 'package:grocery_store_delivery/models/order.dart';
import 'package:grocery_store_delivery/widgets/dialogs/cancel_order_dialog.dart';
import 'package:grocery_store_delivery/widgets/dialogs/deliver_order_dialog.dart';
import 'package:grocery_store_delivery/widgets/dialogs/processing_dialog.dart';
import 'package:grocery_store_delivery/widgets/dialogs/task_cancelled_dialog.dart';
import 'package:grocery_store_delivery/widgets/dialogs/task_completed_dialog.dart';
import 'package:grocery_store_delivery/widgets/order_product_item.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  final Order order;
  final bool previous;

  const DeliveryDetailsScreen({Key key, this.order, this.previous})
      : super(key: key);

  @override
  _DeliveryDetailsScreenState createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  AssignedDeliveryOrdersBloc assignedDeliveryOrdersBloc;
  bool isDelivering;
  bool isCancelling;

  @override
  void initState() {
    super.initState();

    isCancelling = false;
    isDelivering = false;

    assignedDeliveryOrdersBloc =
        BlocProvider.of<AssignedDeliveryOrdersBloc>(context);

    assignedDeliveryOrdersBloc.listen((state) {
      print('MANAGE DELIVERY BLOC :: $state');
      if (state is DeliverOrderInProgressState) {
        //in progress
        if (isDelivering) {
          showUpdatingDialog('Updating order..\nPlease wait!');
        }
      }
      if (state is DeliverOrderFailedState) {
        //failed
        if (isDelivering) {
          Navigator.pop(context);
          showFailedSnack('Failed to update order!', context);
          isDelivering = false;
        }
      }
      if (state is DeliverOrderCompletedState) {
        //completed
        if (isDelivering) {
          isDelivering = false;
          Navigator.pop(context);
          showDeliveredDialog('Order delivered successfully');
        }
      }
      if (state is CancelOrderInProgressState) {
        //in progress
        if (isCancelling) {
          showUpdatingDialog('Cancelling order..\nPlease wait!');
        }
      }
      if (state is CancelOrderFailedState) {
        //failed
        if (isCancelling) {
          Navigator.pop(context);
          showFailedSnack('Failed to cancel order!', context);
          isCancelling = false;
        }
      }
      if (state is CancelOrderCompletedState) {
        //completed
        if (isCancelling) {
          isCancelling = false;
          Navigator.pop(context);
          showCancelledDialog('Order cancelled successfully');
        }
      }
    });
  }

  _launchCaller(String mobileNo) async {
    var url = "tel:$mobileNo";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  showUpdatingDialog(String message) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProcessingDialog(
          message: '$message',
        );
      },
    );
  }

  showDeliveredDialog(String message) async {
    bool isDone = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return TaskCompletedDialog(
          message: '$message',
        );
      },
    );

    if (isDone) {
      Navigator.pop(context, true);
    }
  }

  showCancelledDialog(String message) async {
    bool isDone = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return TaskCancelledDialog(
          message: '$message',
        );
      },
    );

    if (isDone) {
      Navigator.pop(context, true);
    }
  }

  void showFailedSnack(String text, BuildContext context) {
    Flushbar(
      margin: const EdgeInsets.all(8.0),
      borderRadius: 8.0,
      backgroundColor: Colors.red.shade500,
      animationDuration: Duration(milliseconds: 300),
      isDismissible: true,
      boxShadows: [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 1.0,
          blurRadius: 5.0,
          offset: Offset(0.0, 2.0),
        )
      ],
      shouldIconPulse: false,
      duration: Duration(milliseconds: 2000),
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
      messageText: Text(
        '$text',
        style: GoogleFonts.poppins(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          color: Colors.white,
        ),
      ),
    )..show(context);
  }

  Future deliverOrderDialog() async {
    bool isProceed = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return DeliverOrderDialog(widget.order, assignedDeliveryOrdersBloc);
      },
    );

    if (isProceed != null) {
      if (isProceed) {
        //delivering
        //proceed
        isDelivering = true;
      }
    }
  }

  Future cancelOrderDialog() async {
    bool isCancelled = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CancelOrderDialog(widget.order, assignedDeliveryOrdersBloc);
      },
    );

    if (isCancelled != null) {
      if (isCancelled) {
        //canceling
        //proceed
        isCancelling = true;
      }
    }
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
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
                      'Delivery Details',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              children: <Widget>[
                ListView.separated(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 0.0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return OrderProductItem(
                      size: size,
                      product: widget.order.products[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 16.0,
                    );
                  },
                  itemCount: widget.order.products.length,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: size.width,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        'Order Summary',
                        style: GoogleFonts.poppins(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Divider(),
                      Text(
                        'Order id: ${widget.order.orderId}',
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        'Items: ${widget.order.products.length}',
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
                      Text(
                        'Total amount: ${Config().currency}${widget.order.charges.totalAmt}',
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
                            '${widget.order.orderStatus}',
                            style: GoogleFonts.poppins(
                              color: Colors.green.shade600,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      widget.order.orderStatus != 'Delivered'
                          ? SizedBox()
                          : Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  'Delivered on: 25 Jun 2020, 10:10 am',
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
                        height: 5.0,
                      ),
                      Text(
                        widget.order.paymentMethod == 'COD'
                            ? 'Payment status: Cash on delivery'
                            : 'Payment status: Paid',
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
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: size.width,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(15.0),
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
                            '${widget.order.custDetails.name}',
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
                                '${widget.order.custDetails.mobileNo}',
                                style: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.8),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                          !widget.previous
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Material(
                                    color: Theme.of(context).primaryColor,
                                    child: InkWell(
                                      splashColor:
                                          Colors.white.withOpacity(0.5),
                                      onTap: () {
                                        _launchCaller(
                                            widget.order.custDetails.mobileNo);
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
                          '${widget.order.custDetails.address}',
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
                widget.order.orderStatus == 'Out for delivery'
                    ? Column(
                        children: <Widget>[
                          SizedBox(
                            height: 25.0,
                          ),
                          Container(
                            height: 43.0,
                            width: size.width,
                            child: FlatButton(
                              onPressed: () {
                                deliverOrderDialog();
                              },
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Text(
                                'Deliver Order',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            height: 43.0,
                            width: size.width,
                            child: FlatButton(
                              onPressed: () {
                                cancelOrderDialog();
                              },
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Text(
                                'Cancel Order',
                                style: GoogleFonts.poppins(
                                  color: Colors.red,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
