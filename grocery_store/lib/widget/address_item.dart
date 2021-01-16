import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/edit_address_screen.dart';

class AddressItem extends StatelessWidget {
  const AddressItem({
    @required this.user,
    @required this.address,
    @required this.index,
    @required this.currentUser,
    @required this.accountBloc,
  });
  final Address address;
  final GroceryUser user;
  final int index;
  final User currentUser;
  final AccountBloc accountBloc;

  editAddress(context) async {
    bool isEdited = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAddressScreen(
          currentUser: currentUser,
          index: index,
          user: user,
        ),
      ),
    );

    if (isEdited != null) {
      if (isEdited) {
        accountBloc.add(GetAccountDetailsEvent(user.uid));
      }
    }
  }

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
                    editAddress(context);
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
