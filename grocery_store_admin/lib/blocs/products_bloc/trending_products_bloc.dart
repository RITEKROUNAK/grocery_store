import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/blocs/products_bloc/products_bloc.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

class TrendingProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final UserDataRepository userDataRepository;

  TrendingProductsBloc({@required this.userDataRepository}) : super(null);

  @override
  ProductsState get initialState => TrendingProductsInitialState();

  @override
  Stream<ProductsState> mapEventToState(
    ProductsEvent event,
  ) async* {
    if (event is GetTrendingProductsEvent) {
      yield* mapGetTrendingProductsEventToState();
    }
  }

    Stream<ProductsState> mapGetTrendingProductsEventToState() async* {
    yield GetTrendingProductsInProgressState();
    try {
      List<Product> products = await userDataRepository.getTrendingProducts();
      if (products != null) {
        yield GetTrendingProductsCompletedState(products: products);
      } else {
        yield GetTrendingProductsFailedState();
      }
    } catch (e) {
      print(e);
      yield GetTrendingProductsFailedState();
    }
  }
}
