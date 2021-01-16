import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final UserDataRepository userDataRepository;

  ProductBloc({this.userDataRepository}) : super(null);

  ProductState get initialState => ProductInitial();

  @override
  Stream<ProductState> mapEventToState(
    ProductEvent event,
  ) async* {
    if (event is LoadProductEvent) {
      yield* mapLoadProductToState(event.id);
    }

    if (event is LoadSimilarProductsEvent) {
      yield* mapLoadSimilarProductsEventToState(
        category: event.category,
        subCategory: event.subCategory,
      );
    }
  }

  Stream<ProductState> mapLoadProductToState(String id) async* {
    yield LoadProductInProgressState();
    try {
      Product product = await userDataRepository.getProduct(id);
      if (product != null) {
        yield LoadProductCompletedState(product);
      } else {
        yield LoadProductFailedState();
      }
    } catch (e) {
      print('Error: $e');
      yield LoadProductFailedState();
    }
  }

  Stream<ProductState> mapLoadSimilarProductsEventToState({
    String category,
    String subCategory,
  }) async* {
    yield LoadSimilarProductsInProgressState();
    try {
      List<Product> productList = await userDataRepository.getSimilarProducts(
          category: category, subCategory: subCategory);
      if (productList != null) {
        yield LoadSimilarProductsCompletedState(productList);
      } else {
        yield LoadSimilarProductsFailedState();
      }
    } catch (e) {
      print(e);
      yield LoadSimilarProductsFailedState();
    }
  }
}
