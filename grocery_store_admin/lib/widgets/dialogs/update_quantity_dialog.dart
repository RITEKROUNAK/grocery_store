import 'package:ecommerce_store_admin/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:ecommerce_store_admin/blocs/inventory_bloc/low_inventory_bloc.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateQuantityDialog extends StatefulWidget {
  final Product product;
  final LowInventoryBloc lowInventoryBloc;

  const UpdateQuantityDialog({this.product, this.lowInventoryBloc});

  @override
  _UpdateQuantityDialogState createState() => _UpdateQuantityDialogState();
}

class _UpdateQuantityDialogState extends State<UpdateQuantityDialog> {
  TextEditingController controller = TextEditingController();
  bool isUpdating;

  @override
  void initState() {
    super.initState();

    isUpdating = false;
    widget.lowInventoryBloc.listen((state) {
      if (state is UpdateLowInventoryProductFailedState) {
        //failed to update quantity
        setState(() {
          isUpdating = false;
        });
      }
      if (state is UpdateLowInventoryProductCompletedState) {
        //completed
        Navigator.pop(context);
      }
    });
  }

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
                'Update Quantity',
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
            Text(
              'Available Quantity : ${widget.product.quantity}',
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              children: <Widget>[
                Text(
                  'New Quantity :  ',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 40.0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
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
                        hintText: 'Enter new quantity',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14.0,
                          color: Colors.black54,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            isUpdating
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    children: <Widget>[
                      Center(
                        child: SizedBox(
                          width: size.width * 0.5,
                          child: FlatButton(
                            onPressed: () {
                              // //TODO: temp disabled
                              // showSnack(
                              //     'You\'re not a Primary admin.\nAction not allowed!',
                              //     context);

                              //update inventory event
                              if (controller.text.trim().isNotEmpty) {
                                widget.lowInventoryBloc.add(
                                  UpdateLowInventoryProductEvent(
                                    id: widget.product.id,
                                    quantity: int.parse(controller.text),
                                  ),
                                );

                                setState(() {
                                  isUpdating = true;
                                });
                              }
                            },
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              'Update',
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
                  )
          ],
        ),
      ),
    );
  }
}
