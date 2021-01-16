import 'package:ecommerce_store_admin/blocs/products_bloc/products_bloc.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:ecommerce_store_admin/models/product_analytics.dart';
import 'package:ecommerce_store_admin/screens/product_screens/active_products_screen.dart';
import 'package:ecommerce_store_admin/screens/product_screens/add_product_screen.dart';
import 'package:ecommerce_store_admin/screens/product_screens/all_products_screen.dart';
import 'package:ecommerce_store_admin/screens/product_screens/featured_products_screen.dart';
import 'package:ecommerce_store_admin/screens/product_screens/inactive_products_screen.dart';
import 'package:ecommerce_store_admin/screens/product_screens/trending_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with AutomaticKeepAliveClientMixin {
  ProductsBloc productsBloc;
  ProductAnalytics productAnalytics;

  @override
  void initState() {
    super.initState();

    productsBloc = BlocProvider.of<ProductsBloc>(context);
    productsBloc.add(GetProductAnalyticsEvent());

    productsBloc.listen((state) {
      print('PRODUCTS BLOC :: $state');

      if (state is GetProductAnalyticsCompletedState) {
        print('${state.productAnalytics.allProducts}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocBuilder(
        cubit: productsBloc,
        buildWhen: (previous, current) {
          if (current is GetProductAnalyticsFailedState ||
              current is GetProductAnalyticsInProgressState ||
              current is GetProductAnalyticsCompletedState) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is GetProductAnalyticsInProgressState) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is GetProductAnalyticsFailedState) {
            return Text('Failed');
          }
          if (state is GetProductAnalyticsCompletedState) {
            productAnalytics = state.productAnalytics;

            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              scrollDirection: Axis.vertical,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Material(
                    child: InkWell(
                      splashColor: Colors.red.withOpacity(0.3),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllProductsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.01),
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            width: 1.0,
                            style: BorderStyle.solid,
                            color: Colors.black.withOpacity(0.08),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              width: size.width * 0.25,
                              height: size.width * 0.25,
                              padding: const EdgeInsets.all(15.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green.withOpacity(0.2),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.boxOpen,
                                color: Colors.green.shade500,
                                size: size.width * 0.1,
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              '${productAnalytics.allProducts}',
                              style: GoogleFonts.poppins(
                                color: Colors.black87,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'All Products',
                              style: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Material(
                    child: InkWell(
                      splashColor: Colors.blue.withOpacity(0.3),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActiveProductsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.01),
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            width: 1.0,
                            style: BorderStyle.solid,
                            color: Colors.black.withOpacity(0.08),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  '${productAnalytics.activeProducts}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Active Products',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 55.0,
                              height: 55.0,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue.withOpacity(0.2),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.shippingFast,
                                color: Colors.blue.shade500,
                                size: 23.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Material(
                    child: InkWell(
                      splashColor: Colors.blue.withOpacity(0.3),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InactiveProductsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.01),
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            width: 1.0,
                            style: BorderStyle.solid,
                            color: Colors.black.withOpacity(0.08),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  '${productAnalytics.inactiveProducts}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Inactive Products',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 55.0,
                              height: 55.0,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orange.withOpacity(0.2),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.box,
                                color: Colors.orange.shade500,
                                size: 23.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Material(
                          child: InkWell(
                            splashColor: Colors.blue.withOpacity(0.3),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TrendingProductsScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.01),
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                  color: Colors.black.withOpacity(0.08),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Trending Products',
                                    overflow: TextOverflow.clip,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black54,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '${productAnalytics.trendingProducts}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black87,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Icon(
                                        Icons.trending_up,
                                        color: Colors.green,
                                        size: 20.0,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Material(
                          child: InkWell(
                            splashColor: Colors.blue.withOpacity(0.3),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FeaturedProductsScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.01),
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                  color: Colors.black.withOpacity(0.08),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Featured Products',
                                    overflow: TextOverflow.clip,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black54,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '${productAnalytics.featuredProducts}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black87,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.fire,
                                        color: Colors.green.shade500,
                                        size: 16.0,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Material(
                    child: InkWell(
                      splashColor: Colors.blue.withOpacity(0.3),
                      onTap: () {
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddProductScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.01),
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            width: 1.0,
                            style: BorderStyle.solid,
                            color: Colors.black.withOpacity(0.08),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  Icons.add,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Add New Product',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 55.0,
                              height: 55.0,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.brown.withOpacity(0.2),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.folderPlus,
                                color: Colors.brown.shade500,
                                size: 23.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
