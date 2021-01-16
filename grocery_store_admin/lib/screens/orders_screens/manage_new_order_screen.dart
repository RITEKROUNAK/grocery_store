import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/ready_delivery_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/orders_bloc/orders_bloc.dart';
import 'package:ecommerce_store_admin/blocs/orders_bloc/proceed_order_bloc.dart';
import 'package:ecommerce_store_admin/config/config.dart';
import 'package:ecommerce_store_admin/models/delivery_user.dart';
import 'package:ecommerce_store_admin/models/order.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/cancel_order_dialog.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/proceed_order_dialog.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/processing_dialog.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/product_added_dialog.dart';
import 'package:ecommerce_store_admin/widgets/order_product_item.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../blocs/manage_delivery_users_bloc/manage_delivery_users_bloc.dart';

class ManageNewOrderScreen extends StatefulWidget {
  final Order order;

  const ManageNewOrderScreen({this.order});

  @override
  _ManageNewOrderScreenState createState() => _ManageNewOrderScreenState();
}

class _ManageNewOrderScreenState extends State<ManageNewOrderScreen> {
  String _orderStatus;
  ReadyDeliveryUsersBloc readyDeliveryUsersBloc;
  List<DeliveryUser> deliveryUsers;
  ProceedOrderBloc proceedOrderBloc;

  bool isProceeding, isProcessing;

  @override
  void initState() {
    super.initState();

    _orderStatus = widget.order.orderStatus;

    isProceeding = false;
    isProcessing = false;

    readyDeliveryUsersBloc = BlocProvider.of<ReadyDeliveryUsersBloc>(context);
    proceedOrderBloc = BlocProvider.of<ProceedOrderBloc>(context);

    readyDeliveryUsersBloc.listen((state) {
      print('READY DELIVERY USERS BLOC :: $state');

      if (state is GetReadyDeliveryUsersInProgressState) {
        //in progress
        if (isProceeding) {
          showUpdatingDialog('Fetching user data..\nPlease wait!');
        }
      }
      if (state is GetReadyDeliveryUsersFailedState) {
        //failed
        if (isProceeding) {
          showFailedSnack('Failed to get delivery users!', context);
          isProceeding = false;
        }
      }
      if (state is GetReadyDeliveryUsersCompletedState) {
        //completed
        if (isProceeding) {
          isProceeding = false;
          deliveryUsers = state.deliveryUsers;
          Navigator.pop(context);
          showProceedDialog();
        }
      }
    });

    proceedOrderBloc.listen((state) {
      print('PROCEED ORDER BLOC :: $state');

      if (state is ProceedOrderInProgressState) {
        //in progress
        if (isProcessing) {
          showUpdatingDialog('Proceeding the order..\nPlease wait!');
        }
      }
      if (state is ProceedOrderFailedState) {
        //failed
        if (isProcessing) {
          Navigator.pop(context);
          showFailedSnack('Failed to proceed order!', context);
          isProcessing = false;
        }
      }
      if (state is ProceedOrderCompletedState) {
        //completed
        if (isProcessing) {
          isProcessing = false;
          Navigator.pop(context);
          showProcessedCompletedDialog('Order processed successfully');
        }
      }

      if (state is CancelOrderInProgressState) {
        //in progress
        if (isProcessing) {
          showUpdatingDialog('Cancelling the order..\nPlease wait!');
        }
      }
      if (state is CancelOrderFailedState) {
        //failed
        if (isProcessing) {
          Navigator.pop(context);
          showFailedSnack('Failed to cancel order!', context);
          isProcessing = false;
        }
      }
      if (state is CancelOrderCompletedState) {
        //completed
        if (isProcessing) {
          isProcessing = false;
          Navigator.pop(context);
          showProcessedCompletedDialog('Order cancelled successfully');
        }
      }
    });
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

  showProcessedCompletedDialog(String message) async {
    String isDone = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProductAddedDialog(
          message: '$message',
        );
      },
    );
    if (isDone == 'ADDED') {
      Navigator.pop(context);
    }
  }

  proceedOrder() {
    readyDeliveryUsersBloc.add(GetReadyDeliveryUsersEvent());
    isProceeding = true;
  }

  showProceedDialog() async {
    bool isProceeded = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProceedOrderDialog(
          deliveryUsers: deliveryUsers,
          proceedOrderBloc: proceedOrderBloc,
          order: widget.order,
        );
      },
    );

    if (isProceeded != null) {
      if (isProceeded) {
        isProcessing = true;
      }
    }
  }

  showCancelDialog() async {
    bool isProceeded = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CancelOrderDialog(
          proceedOrderBloc: proceedOrderBloc,
          order: widget.order,
        );
      },
    );

    if (isProceeded != null) {
      if (isProceeded) {
        isProcessing = true;
      }
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
                      'Manage Order',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 19.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              children: <Widget>[
                ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
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
                  height: 25.0,
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
                            '${widget.order.orderId}',
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
                        'Delivery details:',
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
                              '${widget.order.custDetails.name}',
                              style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                            widget.order.custDetails.mobileNo.isEmpty
                                ? SizedBox()
                                : Text(
                                    '${widget.order.custDetails.mobileNo}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                            Text(
                              '${widget.order.custDetails.address}',
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
                              color: widget.order.orderStatus == 'Cancelled'
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
                              '${new DateFormat('dd MMM yyyy, hh:mm a').format(widget.order.orderTimestamp.toDate())}',
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
                              widget.order.paymentMethod == 'COD'
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
                      widget.order.paymentMethod != 'COD'
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
                                        '${widget.order.transactionId}',
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
                SizedBox(
                  height: 25.0,
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
                            '${Config().currency}${widget.order.charges.orderAmt}',
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
                            '-${Config().currency}${widget.order.charges.discountAmt}',
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
                            '${Config().currency}${widget.order.charges.shippingAmt}',
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
                            'Tax:',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.65),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            '${Config().currency}${widget.order.charges.taxAmt}',
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
                            '${Config().currency}${widget.order.charges.totalAmt}',
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
                Padding(
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
                            proceedOrder();
                          },
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Text(
                            'Proceed Order',
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: 43.0,
                        width: size.width,
                        child: FlatButton(
                          onPressed: () {
                            showCancelDialog();
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
                  ),
                ),
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
