import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/blocs/products_bloc/products_bloc.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

class FeaturedProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final UserDataRepository userDataRepository;

  FeaturedProductsBloc({@required this.userDataRepository}) : super(null);

  @override
  ProductsState get initialState => FeaturedProductsInitialState();

  @override
  Stream<ProductsState> mapEventToState(
    ProductsEvent event,
  ) async* {
    if (event is GetFeaturedProductsEvent) {
      yield* mapGetFeaturedProductsEventToState();
    }
  }

    Stream<ProductsState> mapGetFeaturedProductsEventToState() async* {
    yield GetFeaturedProductsInProgressState();
    try {
      List<Product> products = await userDataRepository.getFeaturedProducts();
      if (products != null) {
        yield GetFeaturedProductsCompletedState(products: products);
      } else {
        yield GetFeaturedProductsFailedState();
      }
    } catch (e) {
      print(e);
      yield GetFeaturedProductsFailedState();
    }
  }
}
