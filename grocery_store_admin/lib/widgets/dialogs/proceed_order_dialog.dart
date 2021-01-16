import 'dart:math';

import 'package:ecommerce_store_admin/blocs/orders_bloc/orders_bloc.dart';
import 'package:ecommerce_store_admin/blocs/orders_bloc/proceed_order_bloc.dart';
import 'package:ecommerce_store_admin/models/delivery_user.dart';
import 'package:ecommerce_store_admin/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class ProceedOrderDialog extends StatefulWidget {
  final List<DeliveryUser> deliveryUsers;
  final ProceedOrderBloc proceedOrderBloc;
  final Order order;

  const ProceedOrderDialog({
    this.deliveryUsers,
    this.proceedOrderBloc,
    this.order,
  });

  @override
  _ProceedOrderDialogState createState() => _ProceedOrderDialogState();
}

class _ProceedOrderDialogState extends State<ProceedOrderDialog> {
  String selectedDeliveryUser;
  int selectedDeliveryUserIndex;
  Map orderDeliveryMap;
  String otp;
  bool assignDeliveryGuy;

  @override
  void initState() {
    super.initState();

    orderDeliveryMap = Map();
    selectedDeliveryUserIndex = -1;
    assignDeliveryGuy = false;

    otp = Random().nextInt(999999).toString();
  }

  proceedOrder() async {
    if (assignDeliveryGuy) {
      if (selectedDeliveryUserIndex != -1) {
        orderDeliveryMap.putIfAbsent('assignDeliveryGuy', () => true);
        orderDeliveryMap.putIfAbsent(
            'uid', () => widget.deliveryUsers[selectedDeliveryUserIndex].uid);
        orderDeliveryMap.putIfAbsent('deliveryStatus', () => 'Assigned');
        orderDeliveryMap.putIfAbsent('mobileNo',
            () => widget.deliveryUsers[selectedDeliveryUserIndex].mobileNo);
        orderDeliveryMap.putIfAbsent(
            'name', () => widget.deliveryUsers[selectedDeliveryUserIndex].name);
        orderDeliveryMap.putIfAbsent('otp', () => otp);
        orderDeliveryMap.putIfAbsent('orderId', () => widget.order.orderId);

        widget.proceedOrderBloc.add(ProceedOrderEvent(orderDeliveryMap));
        Navigator.pop(context, true);
      }
    } else {
      orderDeliveryMap.putIfAbsent('assignDeliveryGuy', () => false);
      orderDeliveryMap.putIfAbsent('orderId', () => widget.order.orderId);
      orderDeliveryMap.putIfAbsent('deliveryStatus', () => 'Not assigned');
      widget.proceedOrderBloc.add(ProceedOrderEvent(orderDeliveryMap));
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      elevation: 5.0,
      contentPadding: EdgeInsets.all(0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text(
                'Proceed Order',
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            CheckboxListTile(
              dense: true,
              title: Text(
                'Do you want to assign a delivery guy?',
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              value: assignDeliveryGuy,
              onChanged: (value) {
                setState(() {
                  assignDeliveryGuy = !assignDeliveryGuy;
                });
              },
            ),
            assignDeliveryGuy
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Assign a delivery guy:',
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15.0),
                              labelText: 'Select',
                              labelStyle: TextStyle(
                                color: Colors.black87,
                                fontSize: 14.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            isEmpty: selectedDeliveryUser == null,
                            child: DropdownButton<String>(
                                underline: SizedBox(
                                  height: 0,
                                ),
                                value: selectedDeliveryUser,
                                isExpanded: true,
                                isDense: true,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                                items: widget.deliveryUsers
                                    .map(
                                      (e) => DropdownMenuItem(
                                        child: Text(
                                          '${e.name} (${e.mobileNo})',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14.0,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        value: e.uid,
                                      ),
                                    )
                                    .toList(),
                                onChanged: (String uid) {
                                  setState(() {
                                    selectedDeliveryUser = uid;

                                    for (var i = 0;
                                        i < widget.deliveryUsers.length;
                                        i++) {
                                      if (widget.deliveryUsers[i].uid ==
                                          selectedDeliveryUser) {
                                        selectedDeliveryUserIndex = i;
                                        break;
                                      }
                                    }
                                  });
                                }),
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          'OTP: $otp',
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          'NOTE: Delivery guy will verify the OTP from customer while delivering the order.',
                          style: GoogleFonts.poppins(
                            color: Colors.green.shade600,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            SizedBox(
              height: 15.0,
            ),
            Center(
              child: SizedBox(
                width: size.width * 0.5,
                child: FlatButton(
                  onPressed: () {
                    //proceed order
                    proceedOrder();
                  },
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'Proceed',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: size.width * 0.5,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
