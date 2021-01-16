import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/all_delivery_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/deactivate_delivery_user_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/manage_delivery_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_users_bloc/all_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_users_bloc/block_user_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_users_bloc/manage_users_bloc.dart';
import 'package:ecommerce_store_admin/models/delivery_user.dart';
import 'package:ecommerce_store_admin/models/user.dart';
import 'package:ecommerce_store_admin/screens/manage_delivery_users_screen/edit_delivery_user_screen.dart';
import 'package:ecommerce_store_admin/widgets/common_delivery_user_item.dart';
import 'package:ecommerce_store_admin/widgets/common_user_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AllDeliveryUsersScreen extends StatefulWidget {
  @override
  _AllDeliveryUsersScreenState createState() => _AllDeliveryUsersScreenState();
}

class _AllDeliveryUsersScreenState extends State<AllDeliveryUsersScreen>
    with SingleTickerProviderStateMixin {
  List<DeliveryUser> deliveryUsers;
  AllDeliveryUsersBloc allDeliveryUsersBloc;
  DeactivateDeliveryUserBloc deactivateDeliveryUserBloc;
  bool isChanged;

  @override
  void initState() {
    super.initState();

    allDeliveryUsersBloc = BlocProvider.of<AllDeliveryUsersBloc>(context);
    deactivateDeliveryUserBloc =
        BlocProvider.of<DeactivateDeliveryUserBloc>(context);
    deliveryUsers = List();

    allDeliveryUsersBloc.add(GetAllDeliveryUsersEvent());

    deactivateDeliveryUserBloc.listen((state) {
      if (state is DeactivateDeliveryUserCompletedState ||
          state is ActivateDeliveryUserCompletedState) {
        //refresh
        allDeliveryUsersBloc.add(GetAllDeliveryUsersEvent());
      }
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
                      'All Users',
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
              cubit: allDeliveryUsersBloc,
              buildWhen: (previous, current) {
                if (current is GetAllDeliveryUsersCompletedState ||
                    current is GetAllDeliveryUsersInProgressState ||
                    current is GetAllDeliveryUsersFailedState) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is GetAllDeliveryUsersInProgressState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                  //TODO: ADD SHIMMER
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    itemBuilder: (context, index) {
                      // return Shimmer.fromColors(
                      //   period: Duration(milliseconds: 800),
                      //   baseColor: Colors.grey.withOpacity(0.5),
                      //   highlightColor: Colors.black.withOpacity(0.5),
                      //   child: ShimmerUserItem(size: size),
                      // );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 15.0,
                      );
                    },
                    itemCount: 5,
                  );
                }
                if (state is GetAllDeliveryUsersFailedState) {
                  return Center(
                    child: Text(
                      'Failed to load users!',
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  );
                }
                if (state is GetAllDeliveryUsersCompletedState) {
                  if (state.deliveryUsers != null) {
                    deliveryUsers = List();

                    if (state.deliveryUsers.length == 0) {
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
                            'No users found!',
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
                      deliveryUsers = state.deliveryUsers;

                      return ListView.separated(
                        padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                        itemBuilder: (context, index) {
                          return CommonDeliveryUserItem(
                            size: size,
                            user: deliveryUsers[index],
                            isChanged: isChanged,
                            deactivateDeliveryUserBloc:
                                deactivateDeliveryUserBloc,
                            deliveryUserType: 'ALL',
                            allDeliveryUsersBloc: allDeliveryUsersBloc,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 16.0,
                          );
                        },
                        itemCount: deliveryUsers.length,
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
