import 'dart:ffi';

import 'package:grocery_store/blocs/product_bloc/post_question_bloc.dart';
import 'package:grocery_store/blocs/product_bloc/product_bloc.dart';
import 'package:grocery_store/blocs/product_bloc/rate_product_bloc.dart';
import 'package:grocery_store/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RateProductDialog extends StatefulWidget {
  final RateProductBloc rateProductBloc;
  final String uid;
  final String id;
  final Review review;
  final String result;
  final  Product product;

  RateProductDialog(
    this.rateProductBloc,
    this.uid,
    this.id,
    this.review,
    this.result,this.product,
  );

  @override
  _RateProductDialogState createState() => _RateProductDialogState();
}

class _RateProductDialogState extends State<RateProductDialog> {
  final TextEditingController controller = TextEditingController();
  double rating;

  @override
  void initState() {
    super.initState();

    if (widget.result == 'RATED') {
      rating = double.parse(widget.review.rating);
      controller.text = widget.review.review;
    } else {
      rating = 0.0;
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
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(
                'Rate Product',
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Center(
              child: SmoothStarRating(
                allowHalfRating: true,
                onRated: (v) {
                  setState(() {
                    rating = v;
                  });
                },
                starCount: 5,
                rating: rating,
                size: 38.0,
                isReadOnly: false,
                color: Colors.green.shade500,
                borderColor: Colors.green.shade500,
                spacing: 1.0,
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
                maxLines: 5,
                maxLength: 250,
                style: GoogleFonts.poppins(
                  fontSize: 14.0,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                  border: InputBorder.none,
                  hintText: 'Type your review',
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
            SizedBox(
              height: 15.0,
            ),
            Center(
              child: SizedBox(
                width: size.width * 0.5,
                child: FlatButton(
                  onPressed: () {
                    //rate event
                    if (rating > 0.0) {
                      //proceed
                      widget.rateProductBloc.add(
                        RateProductEvent(
                          widget.uid,
                          widget.id,
                          rating.toString(),
                          controller.text.trim(),
                          widget.result,
                          widget.product,
                        ),
                      );
                    }
                  },
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'Rate',
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
