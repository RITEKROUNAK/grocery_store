import 'package:ecommerce_store_admin/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:ecommerce_store_admin/blocs/inventory_bloc/low_inventory_bloc.dart';
import 'package:ecommerce_store_admin/blocs/products_bloc/products_bloc.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:ecommerce_store_admin/widgets/low_inventory_item.dart';
import 'package:ecommerce_store_admin/widgets/shimmers/shimmer_low_inventory_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class LowInventoryScreen extends StatefulWidget {
  @override
  _LowInventoryScreenState createState() => _LowInventoryScreenState();
}

class _LowInventoryScreenState extends State<LowInventoryScreen>
    with SingleTickerProviderStateMixin {
  LowInventoryBloc lowInventoryBloc;
  List<Product> productsList;

  @override
  void initState() {
    super.initState();

    productsList = List();
    lowInventoryBloc = BlocProvider.of<LowInventoryBloc>(context);

    lowInventoryBloc.add(GetLowInventoryProductsEvent());

    lowInventoryBloc.listen((state) {
      print('LOW INVENTORY STATE :: $state');
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      'Low Inventory',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 19.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder(
              cubit: lowInventoryBloc,
              buildWhen: (previous, current) {
                if (current is GetLowInventoryProductsCompletedState ||
                    current is GetLowInventoryProductsInProgressState ||
                    current is GetLowInventoryProductsFailedState) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is GetLowInventoryProductsInProgressState) {
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        period: Duration(milliseconds: 800),
                        baseColor: Colors.grey.withOpacity(0.5),
                        highlightColor: Colors.black.withOpacity(0.5),
                        child: ShimmerLowInventoryItem(size: size),
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
                if (state is GetLowInventoryProductsFailedState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/banners/retry.svg',
                        width: size.width * 0.6,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        'Failed to load products!',
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
                if (state is GetLowInventoryProductsCompletedState) {
                  if (state.products != null) {
                    productsList = List();

                    if (state.products.length == 0) {
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
                            'No products found!',
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
                    } else {
                      productsList = state.products;

                      return ListView.separated(
                        padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return LowInventoryItem(
               
                            product: productsList[index],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 16.0,
                          );
                        },
                        itemCount: productsList.length,
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
