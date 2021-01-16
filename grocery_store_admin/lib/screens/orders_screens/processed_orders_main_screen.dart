import 'package:ecommerce_store_admin/screens/orders_screens/processed_orders_screens/out_for_delivery_orders_screen.dart';
import 'package:ecommerce_store_admin/screens/orders_screens/processed_orders_screens/processed_orders_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ProcessedOrdersMainScreen extends StatefulWidget {
  @override
  _ProcessedOrdersMainScreenState createState() =>
      _ProcessedOrdersMainScreenState();
}

class _ProcessedOrdersMainScreenState extends State<ProcessedOrdersMainScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  PageController _pageController = PageController(initialPage: 0);
  TabController _tabController;
  List<Widget> tabs;

  @override
  void initState() {
    super.initState();

    tabs = [
      Tab(
        text: 'Processed',
      ),
      Tab(
        text: 'Out for delivery',
      ),
    ];

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 12.0),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.06),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
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
                            'Processed Orders',
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
                    tabs: tabs,
                    controller: _tabController,
                    onTap: (value) {
                      _pageController.animateToPage(
                        value,
                        curve: Curves.easeInOut,
                        duration: Duration(
                          milliseconds: 150,
                        ),
                      );
                    },
                    isScrollable: false,
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
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                ProcessedOrdersScreen(),
                OutForDeliveryOrdersScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
