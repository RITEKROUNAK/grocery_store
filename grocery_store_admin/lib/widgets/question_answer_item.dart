import 'package:ecommerce_store_admin/models/product.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class QuestionAnswerItem extends StatelessWidget {
  final QuestionAnswer queAndAns;
  QuestionAnswerItem(this.queAndAns);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Q: ${queAndAns.que}',
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(
            height: 6.0,
          ),
          Text(
            queAndAns.ans.isEmpty
                ? 'A: Not answered yet'
                : 'A: ${queAndAns.userName}',
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(
            height: 6.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${queAndAns.userName}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ),
              Text(
                '${new DateFormat('dd MMM yyyy').format(queAndAns.timestamp.toDate())}',
                style: GoogleFonts.poppins(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                  color: Colors.black.withOpacity(0.55),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
