import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductAddedDialog extends StatelessWidget {
  final String message;

  const ProductAddedDialog({@required this.message});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      elevation: 5.0,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Image.asset(
            'assets/images/order_placed.png',
            width: size.width * 0.4,
          ),
          SizedBox(
            height: 35.0,
          ),
          Text(
            '$message',
            style: GoogleFonts.poppins(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: Colors.black87,
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          SizedBox(
            width: size.width * 0.5,
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context, 'ADDED');
              },
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                'OK',
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
            height: 15.0,
          ),
        ],
      ),
    );
  }
}
