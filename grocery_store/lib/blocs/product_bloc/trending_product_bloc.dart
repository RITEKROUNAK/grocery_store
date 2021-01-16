import 'package:grocery_store/blocs/product_bloc/product_bloc.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrendingProductBloc extends Bloc<ProductEvent, ProductState> {
  final UserDataRepository userDataRepository;

  TrendingProductBloc({this.userDataRepository}) : super(null);

  @override
  ProductState get initialState => InitialTrendingProductState();

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is LoadTrendingProductsEvent) {
      yield* mapLoadTrendingProductsEventToState();
    }
  }

  Stream<ProductState> mapLoadTrendingProductsEventToState() async* {
    yield LoadTrendingProductsInProgressState();
    try {
      List<Product> productList =
          await userDataRepository.getTrendingProducts();
      if (productList != null) {
        yield LoadTrendingProductsCompletedState(productList);
      } else {
        yield LoadTrendingProductsFailedState();
      }
    } catch (e) {
      print(e);
      yield LoadTrendingProductsFailedState();
    }
  }
}
