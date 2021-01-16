import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:ecommerce_store_admin/models/product_analytics.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final UserDataRepository userDataRepository;
  StreamSubscription productAnalyticsSubscription;

  ProductsBloc({this.userDataRepository}) : super(null);

  @override
  ProductsState get initialState => ProductsInitialState();

  @override
  Future<void> close() {
    print('Closing Product BLOC');
    productAnalyticsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<ProductsState> mapEventToState(
    ProductsEvent event,
  ) async* {
    if (event is GetProductAnalyticsEvent) {
      yield* mapGetProductAnalyticsEventToState();
    }
    if (event is UpdateProductAnalyticsEvent) {
      yield* mapUpdateProductAnalyticsEventToState(event.productAnalytics);
    }
  }

  Stream<ProductsState> mapGetProductAnalyticsEventToState() async* {
    yield GetProductAnalyticsInProgressState();

    try {
      productAnalyticsSubscription?.cancel();
      productAnalyticsSubscription =
          userDataRepository.getProductAnalytics().listen((productAnalytics) {
        add(UpdateProductAnalyticsEvent(productAnalytics: productAnalytics));
      }, onError: (err) {
        print(err);
        return GetProductAnalyticsFailedState();
      });
    } catch (e) {
      print(e);
      yield GetProductAnalyticsFailedState();
    }
  }

  Stream<ProductsState> mapUpdateProductAnalyticsEventToState(
      ProductAnalytics productAnalytics) async* {
    yield GetProductAnalyticsCompletedState(productAnalytics: productAnalytics);
  }
}
