import 'package:ecommerce_store_admin/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressItem extends StatelessWidget {
  const AddressItem({
    @required this.user,
    @required this.address,
    @required this.index,
  });
  final Address address;
  final GroceryUser user;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                address.landmark.isEmpty
                    ? '${address.houseNo}, ${address.addressLine1},\n${address.addressLine2},\n${address.city},  \n${address.state}, ${address.country} - ${address.pincode}'
                    : '${address.houseNo}, ${address.addressLine1},\n${address.addressLine2},\n${address.landmark}, ${address.city},  \n${address.state}, ${address.country} - ${address.pincode}',
                style: GoogleFonts.poppins(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.blue.withOpacity(0.5),
                  onTap: () {
                    //TODO: take user to edit address activity
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    width: 40.0,
                    height: 40.0,
                    child: Icon(
                      Icons.edit,
                      color: Colors.black87,
                      size: 24.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        user.defaultAddress == index.toString()
            ? Text(
                'Default address',
                style: GoogleFonts.poppins(
                  color: Colors.blue.shade900,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
