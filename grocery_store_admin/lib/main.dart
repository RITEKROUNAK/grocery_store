import 'package:ecommerce_store_admin/blocs/banners_bloc/banners_bloc.dart';
import 'package:ecommerce_store_admin/blocs/initial_setup_bloc/initial_setup_bloc.dart';
import 'package:ecommerce_store_admin/blocs/inventory_bloc/all_categories_bloc.dart';
import 'package:ecommerce_store_admin/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:ecommerce_store_admin/blocs/inventory_bloc/low_inventory_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_cart_bloc/manage_cart_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/activated_delivery_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/active_delivery_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/add_new_delivery_user_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/all_delivery_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/deactivate_delivery_user_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/deactivated_delivery_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/edit_delivery_user_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/inactive_delivery_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/manage_delivery_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/ready_delivery_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_users_bloc/active_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_users_bloc/all_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_users_bloc/block_user_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_users_bloc/blocked_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_users_bloc/inactive_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_users_bloc/manage_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_users_bloc/users_order_bloc.dart';
import 'package:ecommerce_store_admin/blocs/messages_bloc/all_messages_bloc.dart';
import 'package:ecommerce_store_admin/blocs/messages_bloc/messages_bloc.dart';
import 'package:ecommerce_store_admin/blocs/messages_bloc/new_messages_bloc.dart';
import 'package:ecommerce_store_admin/blocs/my_account_bloc/add_new_admin_bloc.dart';
import 'package:ecommerce_store_admin/blocs/my_account_bloc/all_admins_bloc.dart';
import 'package:ecommerce_store_admin/blocs/my_account_bloc/deactivate_admin_bloc.dart';
import 'package:ecommerce_store_admin/blocs/my_account_bloc/my_account_bloc.dart';
import 'package:ecommerce_store_admin/blocs/notification_bloc/notification_bloc.dart';
import 'package:ecommerce_store_admin/blocs/orders_bloc/cancelled_orders_bloc.dart';
import 'package:ecommerce_store_admin/blocs/orders_bloc/delivered_orders_bloc.dart';
import 'package:ecommerce_store_admin/blocs/orders_bloc/new_orders_bloc.dart';
import 'package:ecommerce_store_admin/blocs/orders_bloc/orders_bloc.dart';
import 'package:ecommerce_store_admin/blocs/orders_bloc/out_for_delivery_orders_bloc.dart';
import 'package:ecommerce_store_admin/blocs/orders_bloc/proceed_order_bloc.dart';
import 'package:ecommerce_store_admin/blocs/orders_bloc/processed_orders_bloc.dart';
import 'package:ecommerce_store_admin/blocs/payment_method_settings_bloc/payment_method_settings_bloc.dart';
import 'package:ecommerce_store_admin/blocs/products_bloc/active_products_bloc.dart';
import 'package:ecommerce_store_admin/blocs/products_bloc/all_products_bloc.dart';
import 'package:ecommerce_store_admin/blocs/products_bloc/edit_product_bloc.dart';
import 'package:ecommerce_store_admin/blocs/products_bloc/featured_products_bloc.dart';
import 'package:ecommerce_store_admin/blocs/products_bloc/inactive_products_bloc.dart';
import 'package:ecommerce_store_admin/blocs/products_bloc/trending_products_bloc.dart';
import 'package:ecommerce_store_admin/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:ecommerce_store_admin/blocs/user_reports_bloc/user_report_product_bloc.dart';
import 'package:ecommerce_store_admin/blocs/user_reports_bloc/user_reports_bloc.dart';
import 'package:ecommerce_store_admin/repositories/authentication_repository.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:ecommerce_store_admin/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/my_account_bloc/edit_admin_bloc.dart';
import 'blocs/orders_bloc/manage_order_bloc.dart';
import 'blocs/products_bloc/add_new_product_bloc.dart';
import 'blocs/products_bloc/products_bloc.dart';
import 'screens/home_screen.dart';
import 'screens/initial_setup_screen.dart';
import 'screens/sign_in_sign_up_screens/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final UserDataRepository userDataRepository = UserDataRepository();
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<OrdersBloc>(
          create: (context) => OrdersBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<NewOrdersBloc>(
          create: (context) => NewOrdersBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<ProcessedOrdersBloc>(
          create: (context) => ProcessedOrdersBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<OutForDeliveryOrdersBloc>(
          create: (context) => OutForDeliveryOrdersBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<DeliveredOrdersBloc>(
          create: (context) => DeliveredOrdersBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<CancelledOrdersBloc>(
          create: (context) => CancelledOrdersBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<ProductsBloc>(
          create: (context) => ProductsBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<AllProductsBloc>(
          create: (context) => AllProductsBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<ActiveProductsBloc>(
          create: (context) => ActiveProductsBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<InactiveProductsBloc>(
          create: (context) => InactiveProductsBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<TrendingProductsBloc>(
          create: (context) => TrendingProductsBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<FeaturedProductsBloc>(
          create: (context) => FeaturedProductsBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<InventoryBloc>(
          create: (context) => InventoryBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<LowInventoryBloc>(
          create: (context) => LowInventoryBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<AllCategoriesBloc>(
          create: (context) => AllCategoriesBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<MessagesBloc>(
          create: (context) => MessagesBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<AllMessagesBloc>(
          create: (context) => AllMessagesBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<NewMessagesBloc>(
          create: (context) => NewMessagesBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<AddNewProductBloc>(
          create: (context) => AddNewProductBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<EditProductBloc>(
          create: (context) => EditProductBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<ManageUsersBloc>(
          create: (context) => ManageUsersBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<AllUsersBloc>(
          create: (context) => AllUsersBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<ActiveUsersBloc>(
          create: (context) => ActiveUsersBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<InactiveUsersBloc>(
          create: (context) => InactiveUsersBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<BlockedUsersBloc>(
          create: (context) => BlockedUsersBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<UserReportsBloc>(
          create: (context) => UserReportsBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<UserReportProductBloc>(
          create: (context) => UserReportProductBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<UsersOrderBloc>(
          create: (context) => UsersOrderBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<MyAccountBloc>(
          create: (context) => MyAccountBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<BlockUserBloc>(
          create: (context) => BlockUserBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<SignInBloc>(
          create: (context) => SignInBloc(
            authenticationRepository: authenticationRepository,
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<InitialSetupBloc>(
          create: (context) => InitialSetupBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<AllAdminsBloc>(
          create: (context) => AllAdminsBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<BannersBloc>(
          create: (context) => BannersBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<ManageDeliveryUsersBloc>(
          create: (context) => ManageDeliveryUsersBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<AllDeliveryUsersBloc>(
          create: (context) => AllDeliveryUsersBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<ActiveDeliveryUsersBloc>(
          create: (context) => ActiveDeliveryUsersBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<InactiveDeliveryUsersBloc>(
          create: (context) => InactiveDeliveryUsersBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<ActivatedDeliveryUsersBloc>(
          create: (context) => ActivatedDeliveryUsersBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<DeactivatedDeliveryUsersBloc>(
          create: (context) => DeactivatedDeliveryUsersBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<DeactivateDeliveryUserBloc>(
          create: (context) => DeactivateDeliveryUserBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<EditDeliveryUserBloc>(
          create: (context) => EditDeliveryUserBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<AddNewDeliveryUserBloc>(
          create: (context) => AddNewDeliveryUserBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<ManageOrderBloc>(
          create: (context) => ManageOrderBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<ReadyDeliveryUsersBloc>(
          create: (context) => ReadyDeliveryUsersBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<ProceedOrderBloc>(
          create: (context) => ProceedOrderBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<AddNewAdminBloc>(
          create: (context) => AddNewAdminBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<EditAdminBloc>(
          create: (context) => EditAdminBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<NotificationBloc>(
          create: (context) => NotificationBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<DeactivateAdminBloc>(
          create: (context) => DeactivateAdminBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<ManageCartBloc>(
          create: (context) => ManageCartBloc(
            userDataRepository: userDataRepository,
          ),
        ),
        BlocProvider<PaymentMethodSettingsBloc>(
          create: (context) => PaymentMethodSettingsBloc(
            userDataRepository: userDataRepository,
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery Store Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColorDark: Color(0xFF7936ff),
        primaryColor: Color(0xFF8b50ff),
        accentColor: Colors.pink,
        backgroundColor: Colors.white,
        canvasColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/initial_setup': (context) => InitialSetupScreen(),
        '/splash_screen': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/sign_in': (context) => SignInScreen(),
      },
    );
  }
}
