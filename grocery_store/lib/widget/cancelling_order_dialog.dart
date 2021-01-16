import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CancellingOrderDialog extends StatelessWidget {
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
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            width: 15.0,
          ),
          Text(
            'Cancelling the order',
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.9),
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
