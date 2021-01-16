import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store_delivery/blocs/previous_orders_bloc/previous_orders_bloc.dart';
import 'package:grocery_store_delivery/blocs/user_bloc/user_bloc.dart';
import 'package:grocery_store_delivery/models/order.dart';
import 'package:grocery_store_delivery/widgets/assigned_order_item.dart';

class PreviousOrdersPage extends StatefulWidget {
  @override
  _PreviousOrdersPageState createState() => _PreviousOrdersPageState();
}

class _PreviousOrdersPageState extends State<PreviousOrdersPage>
    with AutomaticKeepAliveClientMixin {
  UserBloc userBloc;
  User firebaseUser;
  PreviousOrdersBloc previousOrdersBloc;
  List<Order> previousOrders;

  @override
  void initState() {
    super.initState();

    userBloc = BlocProvider.of<UserBloc>(context);
    previousOrdersBloc = BlocProvider.of<PreviousOrdersBloc>(context);

    userBloc.add(GetCurrentUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            width: size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
                child: Row(
                  children: [
                    Text(
                      'Previously Completed Orders',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(
                      height: 37.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder(
              buildWhen: (previous, current) {
                if (current is GetCurrentUserCompletedState ||
                    current is GetCurrentUserFailedState ||
                    current is GetCurrentUserInProgressState) {
                  return true;
                }
                return false;
              },
              cubit: userBloc,
              builder: (context, state) {
                if (state is GetCurrentUserInProgressState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is GetCurrentUserFailedState) {
                  return Center(
                    child: Text(
                      'Failed to load user!',
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  );
                }
                if (state is GetCurrentUserCompletedState) {
                  firebaseUser = state.firebaseUser;

                  previousOrdersBloc
                      .add(GetPreviousOrdersEvent(firebaseUser.uid));

                  return BlocBuilder(
                    buildWhen: (previous, current) {
                      if (current is GetPreviousOrdersCompletedState ||
                          current is GetPreviousOrdersFailedState ||
                          current is GetPreviousOrdersInProgressState) {
                        return true;
                      }
                      return false;
                    },
                    cubit: previousOrdersBloc,
                    builder: (context, state) {
                      print('PREVIOUS ORDERS BLOC :: $state');

                      if (state is GetPreviousOrdersInProgressState) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is GetPreviousOrdersFailedState) {
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
                      if (state is GetPreviousOrdersCompletedState) {
                        previousOrders = state.previousOrders;
                        if (state.previousOrders.length == 0) {
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
                                'No previous orders found!',
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
                              order: previousOrders[index],
                              previous: true,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 15.0,
                            );
                          },
                          itemCount: previousOrders.length,
                        );
                      }
                      return SizedBox();
                    },
                  );
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
