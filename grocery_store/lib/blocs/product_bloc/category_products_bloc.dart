import 'package:grocery_store/blocs/product_bloc/product_bloc.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryProductsBloc extends Bloc<ProductEvent, ProductState> {
  final UserDataRepository userDataRepository;

  CategoryProductsBloc({this.userDataRepository}) : super(null);

  @override
  ProductState get initialState => InitialCategoryProductsState();

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is LoadCategoryProductsEvent) {
      yield* mapLoadCategoryProductssEventToState(
        category: event.category,
      );
    }
  }

  Stream<ProductState> mapLoadCategoryProductssEventToState({
    String category,
  }) async* {
    yield LoadCategoryProductsInProgressState();
    try {
      List<Product> productList = await userDataRepository.getCategoryProducts(
        category: category,
      );
      if (productList != null) {
        yield LoadCategoryProductsCompletedState(productList);
      } else {
        yield LoadCategoryProductsFailedState();
      }
    } catch (e) {
      print(e);
      yield LoadCategoryProductsFailedState();
    }
  }
}
