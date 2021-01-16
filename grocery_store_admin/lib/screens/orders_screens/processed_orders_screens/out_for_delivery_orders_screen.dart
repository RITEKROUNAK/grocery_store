import 'package:ecommerce_store_admin/blocs/orders_bloc/orders_bloc.dart';
import 'package:ecommerce_store_admin/blocs/orders_bloc/out_for_delivery_orders_bloc.dart';
import 'package:ecommerce_store_admin/blocs/orders_bloc/processed_orders_bloc.dart';
import 'package:ecommerce_store_admin/models/order.dart';
import 'package:ecommerce_store_admin/widgets/common_order_item.dart';
import 'package:ecommerce_store_admin/widgets/shimmers/shimmer_order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class OutForDeliveryOrdersScreen extends StatefulWidget {
  @override
  _OutForDeliveryOrdersScreenState createState() =>
      _OutForDeliveryOrdersScreenState();
}

class _OutForDeliveryOrdersScreenState extends State<OutForDeliveryOrdersScreen>
    with AutomaticKeepAliveClientMixin {
  List<Order> outForDeliveryOrders;
  OutForDeliveryOrdersBloc outForDeliveryOrdersBloc;

  @override
  void initState() {
    super.initState();

    outForDeliveryOrdersBloc =
        BlocProvider.of<OutForDeliveryOrdersBloc>(context);

    outForDeliveryOrders = List();

    outForDeliveryOrdersBloc.add(GetOutForDeliveryOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Size size = MediaQuery.of(context).size;

    return Container(
      child: BlocBuilder(
        cubit: outForDeliveryOrdersBloc,
        buildWhen: (previous, current) {
          if (current is GetOutForDeliveryOrdersCompletedState ||
              current is GetOutForDeliveryOrdersInProgressState ||
              current is GetOutForDeliveryOrdersFailedState) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is GetOutForDeliveryOrdersInProgressState) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  period: Duration(milliseconds: 800),
                  baseColor: Colors.grey.withOpacity(0.5),
                  highlightColor: Colors.black.withOpacity(0.5),
                  child: ShimmerOrderItem(size: size),
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
          if (state is GetOutForDeliveryOrdersFailedState) {
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
          if (state is GetOutForDeliveryOrdersCompletedState) {
            if (state.outForDeliveryOrders != null) {
              outForDeliveryOrders = List();

              if (state.outForDeliveryOrders.length == 0) {
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
              } else {
                outForDeliveryOrders = state.outForDeliveryOrders;

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  itemBuilder: (context, index) {
                    return CommonOrderItem(
                      size: size,
                      order: outForDeliveryOrders[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 16.0,
                    );
                  },
                  itemCount: outForDeliveryOrders.length,
                );
              }
            }
          }
          return SizedBox();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
