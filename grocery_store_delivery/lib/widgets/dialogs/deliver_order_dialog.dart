import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store_delivery/blocs/manage_delivery_bloc/assigned_delivery_orders_bloc.dart';
import 'package:grocery_store_delivery/blocs/manage_delivery_bloc/manage_delivery_bloc.dart';
import 'package:grocery_store_delivery/models/order.dart';

class DeliverOrderDialog extends StatefulWidget {
  final Order order;
  final AssignedDeliveryOrdersBloc assignedDeliveryOrdersBloc;
  DeliverOrderDialog(this.order, this.assignedDeliveryOrdersBloc);
  @override
  _DeliverOrderDialogState createState() => _DeliverOrderDialogState();
}

class _DeliverOrderDialogState extends State<DeliverOrderDialog> {
  TextEditingController controller = TextEditingController();
  Map deliverOrderMap = Map();

  void showSnack(String text, BuildContext context) {
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
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      elevation: 5.0,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(
                'Please confirm the OTP',
                textAlign: TextAlign.center,
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
            Container(
              height: 45.0,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                enableInteractiveSelection: false,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14.0,
                  color: Colors.black87,
                  letterSpacing: 5.0,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                  border: InputBorder.none,
                  hintText: 'OTP',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14.0,
                    color: Colors.black54,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Center(
              child: SizedBox(
                width: size.width * 0.5,
                child: FlatButton(
                  onPressed: () {
                    //proceed
                    if (controller.text.trim().isNotEmpty) {
                      if (widget.order.deliveryDetails.otp ==
                          controller.text.trim()) {
                        deliverOrderMap.putIfAbsent(
                            'orderId', () => widget.order.orderId);
                        deliverOrderMap.putIfAbsent(
                            'otp', () => controller.text.trim());
                        widget.assignedDeliveryOrdersBloc
                            .add(DeliverOrderEvent(deliverOrderMap));
                        Navigator.pop(context, true);
                      } else {
                        showSnack('OTP is incorrect!', context);
                      }
                    }
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
          ],
        ),
      ),
    );
  }
}
