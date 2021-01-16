import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/blocs/products_bloc/products_bloc.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

class ActiveProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final UserDataRepository userDataRepository;

  ActiveProductsBloc({@required this.userDataRepository}) : super(null);

  @override
  ProductsState get initialState => ActiveProductsInitialState();

  @override
  Stream<ProductsState> mapEventToState(
    ProductsEvent event,
  ) async* {
    if (event is GetActiveProductsEvent) {
      yield* mapGetActiveProductsEventToState();
    }
  }

    Stream<ProductsState> mapGetActiveProductsEventToState() async* {
    yield GetActiveProductsInProgressState();
    try {
      List<Product> products = await userDataRepository.getActiveProducts();
      if (products != null) {
        yield GetActiveProductsCompletedState(products: products);
      } else {
        yield GetActiveProductsFailedState();
      }
    } catch (e) {
      print(e);
      yield GetActiveProductsFailedState();
    }
  }
}
