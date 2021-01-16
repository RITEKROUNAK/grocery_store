import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/blocs/products_bloc/products_bloc.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

class InactiveProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final UserDataRepository userDataRepository;

  InactiveProductsBloc({@required this.userDataRepository}) : super(null);

  @override
  ProductsState get initialState => InactiveProductsInitialState();

  @override
  Stream<ProductsState> mapEventToState(
    ProductsEvent event,
  ) async* {
    if (event is GetInactiveProductsEvent) {
      yield* mapGetInactiveProductsEventToState();
    }
  }

    Stream<ProductsState> mapGetInactiveProductsEventToState() async* {
    yield GetInactiveProductsInProgressState();
    try {
      List<Product> products = await userDataRepository.getInactiveProducts();
      if (products != null) {
        yield GetInactiveProductsCompletedState(products: products);
      } else {
        yield GetInactiveProductsFailedState();
      }
    } catch (e) {
      print(e);
      yield GetInactiveProductsFailedState();
    }
  }
}
