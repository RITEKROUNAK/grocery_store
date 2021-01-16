import 'package:grocery_store/blocs/my_orders_bloc/my_orders_bloc.dart';
import 'package:grocery_store/models/my_order.dart';
import 'package:grocery_store/widget/my_order_item.dart';
import 'package:grocery_store/widget/my_order_tab.dart';
import 'package:grocery_store/widget/shimmer_my_order_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class MyOrdersScreen extends StatefulWidget {
  final User currentUser;

  MyOrdersScreen({this.currentUser});

  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  MyOrdersBloc myOrdersBloc;
  List<MyOrder> allOrders = List();
  List<MyOrder> deliveredOrders = List();
  List<MyOrder> cancelledOrders = List();
  List<Widget> tabViews;
  List<MyOrderTab> myOrderTabs = List();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    myOrdersBloc = BlocProvider.of<MyOrdersBloc>(context);
    tabViews = List();

    myOrdersBloc.listen((state) {
      print('ORDERS :: $state');
      if (state is GetAllOrdersCompletedState) {
        // make a list of all, delivered, and cancelled orders
        if (state.allOrders != null) {
          // allOrders = state.allOrders;
          myOrdersBloc.add(GetDeliveredOrdersEvent(allOrders));
          myOrdersBloc.add(GetCancelledOrdersEvent(allOrders));
        }
      }
      if (state is GetAllOrdersFailedState) {
        //show failed text
      }
      if (state is GetAllOrdersInProgressState) {
        //show shimmer
      }
    });

    myOrdersBloc.add(GetAllOrdersEvent(widget.currentUser.uid));
  }

  @override
  Widget build(BuildContext context) {
    print('BUILT');
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.white.withOpacity(0.5),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            width: 38.0,
                            height: 35.0,
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      'My Orders',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Container(
            height: 38.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TabBar(
              tabs: [
                Tab(
                  text: 'All',
                ),
                Tab(
                  text: 'Delivered',
                ),
                Tab(
                  text: 'Cancelled',
                ),
              ],
              controller: _tabController,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: EdgeInsets.symmetric(horizontal: 25.0),
              indicatorPadding: EdgeInsets.symmetric(horizontal: 10.0),
              indicator: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              unselectedLabelColor: Colors.black45,
              labelColor: Colors.white,
              labelStyle: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: BlocBuilder(
              cubit: myOrdersBloc,
              buildWhen: (previous, current) {
                if (current is GetAllOrdersInProgressState ||
                    current is GetAllOrdersFailedState ||
                    current is GetAllOrdersCompletedState) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is GetAllOrdersInProgressState) {
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        period: Duration(milliseconds: 800),
                        baseColor: Colors.grey.withOpacity(0.5),
                        highlightColor: Colors.black.withOpacity(0.5),
                        child: ShimmerMyOrderItem(size: size),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 15.0,
                      );
                    },
                    itemCount: 5,
                  );
                }
                if (state is GetAllOrdersFailedState) {
                  return Center(
                    child: Text(
                      'Failed to load orders!',
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  );
                }
                if (state is GetAllOrdersCompletedState) {
                  if (state.allOrders != null) {
                    tabViews = List();
                    allOrders = List();
                    deliveredOrders = List();
                    cancelledOrders = List();

                    print('RUNNING');
                    if (state.allOrders.length > 0) {
                      allOrders = state.allOrders;
                      //add to list
                      for (var order in allOrders) {
                        if (order.orderStatus == 'Delivered') {
                          deliveredOrders.add(order);
                        }
                        if (order.orderStatus == 'Cancelled') {
                          cancelledOrders.add(order);
                        }
                      }

                      myOrderTabs = [
                        MyOrderTab(size: size, orders: allOrders),
                        MyOrderTab(size: size, orders: deliveredOrders),
                        MyOrderTab(size: size, orders: cancelledOrders),
                      ];

                      return TabBarView(
                        children: myOrderTabs,
                        controller: _tabController,
                      );
                    } else {
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
                            'No orders found!',
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
                  }
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
