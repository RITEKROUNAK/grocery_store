import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/blocs/products_bloc/products_bloc.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

class AllProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final UserDataRepository userDataRepository;

  AllProductsBloc({@required this.userDataRepository}) : super(null);

  ProductsState get initialState => AllProductsInitialState();

  @override
  Stream<ProductsState> mapEventToState(
    ProductsEvent event,
  ) async* {
    if (event is GetAllProductsEvent) {
      yield* mapGetAllProductsEventToState();
    }
  }

    Stream<ProductsState> mapGetAllProductsEventToState() async* {
    yield GetAllProductsInProgressState();
    try {
      List<Product> products = await userDataRepository.getAllProducts();
      if (products != null) {
        yield GetAllProductsCompletedState(products: products);
      } else {
        yield GetAllProductsFailedState();
      }
    } catch (e) {
      print(e);
      yield GetAllProductsFailedState();
    }
  }
}
