import 'package:ecommerce_store_admin/blocs/user_reports_bloc/user_reports_bloc.dart';
import 'package:ecommerce_store_admin/models/user_report.dart';
import 'package:ecommerce_store_admin/widgets/user_report_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class UserReportsPage extends StatefulWidget {
  @override
  _UserReportsPageState createState() => _UserReportsPageState();
}

class _UserReportsPageState extends State<UserReportsPage>
    with AutomaticKeepAliveClientMixin {
  UserReportsBloc userReportsBloc;
  List<UserReport> userReports;

  @override
  void initState() {
    super.initState();

    userReportsBloc = BlocProvider.of<UserReportsBloc>(context);
    userReports = List();

    userReportsBloc.add(LoadUserReportsEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocBuilder(
        cubit: userReportsBloc,
        buildWhen: (previous, current) {
          if (current is LoadUserReportsCompletedState ||
              current is LoadUserReportsInProgressState ||
              current is LoadUserReportsFailedState) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is LoadUserReportsInProgressState) {
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
          if (state is LoadUserReportsFailedState) {
            return Center(
              child: Text(
                'Failed to load user reports!',
                style: GoogleFonts.poppins(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            );
          }
          if (state is LoadUserReportsCompletedState) {
            if (state.userReports != null) {
              userReports = List();

              if (state.userReports.length == 0) {
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
                        'No user reports found!',
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
                userReports = state.userReports;

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  ),
                  itemBuilder: (context, index) {
                    return UserReportItem(
                      userReport: userReports[index],
                      size: size,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 16.0,
                    );
                  },
                  itemCount: userReports.length,
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
