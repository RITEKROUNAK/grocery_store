import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store_delivery/blocs/manage_delivery_bloc/assigned_delivery_orders_bloc.dart';
import 'package:grocery_store_delivery/blocs/manage_delivery_bloc/manage_delivery_bloc.dart';
import 'package:grocery_store_delivery/models/order.dart';
import 'package:grocery_store_delivery/widgets/assigned_order_item.dart';

class AssignedOrders extends StatefulWidget {
  final User firebaseUser;
  AssignedOrders(this.firebaseUser);

  @override
  _AssignedOrdersState createState() => _AssignedOrdersState();
}

class _AssignedOrdersState extends State<AssignedOrders> {
  ManageDeliveryBloc manageDeliveryBloc;
  List<Order> orders;

  @override
  void initState() {
    super.initState();

    manageDeliveryBloc = BlocProvider.of<ManageDeliveryBloc>(context);

    manageDeliveryBloc.add(GetAllAssignedOrdersEvent(widget.firebaseUser.uid));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: BlocBuilder(
        buildWhen: (previous, current) {
          if (current is GetAllAssignedOrdersCompletedState ||
              current is GetAllAssignedOrdersFailedState ||
              current is GetAllAssignedOrdersInProgressState) {
            return true;
          }
          return false;
        },
        cubit: manageDeliveryBloc,
        builder: (context, state) {
          if (state is GetAllAssignedOrdersInProgressState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GetAllAssignedOrdersFailedState) {
            return Center(
              child: Text(
                'Failed to load orders!',
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            );
          }
          if (state is GetAllAssignedOrdersCompletedState) {
            orders = state.allOrders;
            if (state.allOrders.length == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/images/empty_prod.svg',
                    width: size.width * 0.6,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    'No assigned orders found!',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              itemBuilder: (context, index) {
                return AssignedOrderItem(
                  size: size,
                  order: orders[index],
                  previous: false,
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 15.0,
                );
              },
              itemCount: orders.length,
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
