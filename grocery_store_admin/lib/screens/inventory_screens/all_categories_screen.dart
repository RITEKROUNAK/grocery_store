import 'package:ecommerce_store_admin/blocs/inventory_bloc/all_categories_bloc.dart';
import 'package:ecommerce_store_admin/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:ecommerce_store_admin/models/category.dart';
import 'package:ecommerce_store_admin/widgets/category_item.dart';
import 'package:ecommerce_store_admin/widgets/shimmers/shimmer_order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import 'add_category_screen.dart';

class AllCategoriesScreen extends StatefulWidget {
  @override
  _AllCategoriesScreenState createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen>
    with SingleTickerProviderStateMixin {
  AllCategoriesBloc allCategoriesBloc;
  List<Category> categories;

  @override
  void initState() {
    super.initState();

    categories = List();
    allCategoriesBloc = BlocProvider.of<AllCategoriesBloc>(context);

    allCategoriesBloc.add(GetAllCategoriesEvent());

    allCategoriesBloc.listen((state) {
      print('ALL CATEGORIES STATE :: $state');
    });
  }

  addCategory() async {
    bool isAdded = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCategoryScreen(),
      ),
    );

    if (isAdded != null) {
      if (isAdded) {
        allCategoriesBloc.add(GetAllCategoriesEvent());
      }
    }
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
                      'All Categories',
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
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              children: <Widget>[
                BlocBuilder(
                  cubit: allCategoriesBloc,
                  buildWhen: (previous, current) {
                    if (current is GetAllCategoriesCompletedState ||
                        current is GetAllCategoriesInProgressState ||
                        current is GetAllCategoriesFailedState) {
                      return true;
                    }
                    return false;
                  },
                  builder: (context, state) {
                    if (state is GetAllCategoriesInProgressState) {
                      return ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
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
                    if (state is GetAllCategoriesFailedState) {
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
                    if (state is GetAllCategoriesCompletedState) {
                      if (state.categories != null) {
                        categories = List();

                        if (state.categories.length == 0) {
                          return Center(
                            child: Column(
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
                                  'No categories found!',
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
                            ),
                          );
                        } else {
                          categories = state.categories;

                          return ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                            ),
                            itemBuilder: (context, index) {
                              return CategoryItem(
                                size: size,
                                category: categories[index],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 16.0,
                              );
                            },
                            itemCount: categories.length,
                          );
                        }
                      }
                    }
                    return SizedBox();
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  height: 45.0,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: FlatButton(
                    onPressed: () {
                      //add category
                      addCategory();
                    },
                    color: Colors.green.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'Add New Category',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
