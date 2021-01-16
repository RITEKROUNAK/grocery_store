import 'package:grocery_store/blocs/cart_bloc/cart_bloc.dart';
import 'package:grocery_store/config/config.dart';
import 'package:grocery_store/models/cart.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/models/user_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/user_notification.dart' as prefix;

class NotificationItem extends StatelessWidget {
  final Size size;
  final UserNotification userNotification;
  final int index;
  final List<prefix.Notification> notificationList;

  const NotificationItem({
    @required this.size,
    @required this.userNotification,
    @required this.index,
    @required this.notificationList,
  });

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    return Container(
      width: size.width,
      padding: const EdgeInsets.only(
          left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '${notificationList[index].notificationTitle}',
            style: GoogleFonts.poppins(
              fontSize: 14.5,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            '${notificationList[index].notificationBody}',
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              color: Colors.black.withOpacity(0.7),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            '${dateFormat.format(notificationList[index].timestamp.toDate())}',
            style: GoogleFonts.poppins(
              fontSize: 13.0,
              color: Colors.black.withOpacity(0.5),
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
