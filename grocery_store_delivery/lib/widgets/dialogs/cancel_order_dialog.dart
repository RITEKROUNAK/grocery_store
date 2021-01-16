import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store_delivery/blocs/manage_delivery_bloc/assigned_delivery_orders_bloc.dart';
import 'package:grocery_store_delivery/blocs/manage_delivery_bloc/manage_delivery_bloc.dart';
import 'package:grocery_store_delivery/config/config.dart';
import 'package:grocery_store_delivery/models/order.dart';

class CancelOrderDialog extends StatefulWidget {
  final Order order;
  final AssignedDeliveryOrdersBloc assignedDeliveryOrdersBloc;
  CancelOrderDialog(this.order, this.assignedDeliveryOrdersBloc);

  @override
  _CancelOrderDialogState createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends State<CancelOrderDialog> {
  TextEditingController controller = TextEditingController();
  int selectedValue;
  String cancelOrderReason;
  Map cancelOrderMap = Map();

  @override
  void initState() {
    super.initState();

    selectedValue = -1;
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
      content: Container(
        height: size.height * 0.5,
        width: double.maxFinite,
        constraints: BoxConstraints.loose(size),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
                  'Please specify the reason for cancellation',
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
              ListView.builder(
                itemCount: Config().cancelOrderReason.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return RadioListTile(
                    dense: true,
                    title: Text(
                      '${Config().cancelOrderReason[index]}',
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    value: index,
                    groupValue: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;

                        cancelOrderReason =
                            Config().cancelOrderReason[selectedValue];

                        if (cancelOrderReason == 'Other') {
                          cancelOrderReason = '';
                        }
                      });
                      print(cancelOrderReason);
                    },
                  );
                },
              ),
              cancelOrderReason == 'Other'
                  ? Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: TextFormField(
                            controller: controller,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.done,
                            enableInteractiveSelection: false,
                            maxLines: 3,
                            onChanged: (value) {
                              cancelOrderReason = value.trim();
                            },
                            maxLength: 150,
                            style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              color: Colors.black87,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 8.0),
                              border: InputBorder.none,
                              hintText: 'Type your reason',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 14.0,
                                color: Colors.black54,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w400,
                              ),
                              counterStyle: GoogleFonts.poppins(
                                fontSize: 12.5,
                                color: Colors.black54,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                      //cancel order

                      if (cancelOrderReason != null) {
                        if (cancelOrderReason.trim().isNotEmpty) {
                          print(cancelOrderReason);

                          cancelOrderMap.putIfAbsent(
                              'orderId', () => widget.order.orderId);
                          cancelOrderMap.putIfAbsent(
                              'reason', () => cancelOrderReason);
                          cancelOrderMap.putIfAbsent('paymentMethod',
                              () => widget.order.paymentMethod);

                          widget.assignedDeliveryOrdersBloc
                              .add(CancelOrderEvent(cancelOrderMap));

                          Navigator.pop(context, true);
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
      ),
    );
  }
}
