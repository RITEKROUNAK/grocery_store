import 'package:grocery_store/blocs/product_bloc/product_bloc.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimilarProductBloc extends Bloc<ProductEvent, ProductState> {
  final UserDataRepository userDataRepository;

  SimilarProductBloc({this.userDataRepository}) : super(null);

  @override
  ProductState get initialState => InitialSimilarProductState();

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is LoadSimilarProductsEvent) {
      yield* mapLoadSimilarProductsEventToState(
        category: event.category,
        subCategory: event.subCategory,
        productId: event.productId,
      );
    }
  }

  Stream<ProductState> mapLoadSimilarProductsEventToState(
      {String category, String subCategory, String productId}) async* {
    yield LoadSimilarProductsInProgressState();
    try {
      List<Product> productList = await userDataRepository.getSimilarProducts(
        category: category,
        subCategory: subCategory,
        productId: productId,
      );
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
