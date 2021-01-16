import 'package:grocery_store/blocs/product_bloc/product_bloc.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeaturedProductBloc extends Bloc<ProductEvent, ProductState> {
  final UserDataRepository userDataRepository;

  FeaturedProductBloc({this.userDataRepository}) : super(null);

  @override
  ProductState get initialState => InitialFeaturedProductState();

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is LoadFeaturedProductsEvent) {
      yield* mapLoadFeaturedProductsEventToState();
    }
  }

  Stream<ProductState> mapLoadFeaturedProductsEventToState() async* {
    yield LoadFeaturedProductsInProgressState();
    try {
      List<Product> productList =
          await userDataRepository.getFeaturedProducts();
      if (productList != null) {
        yield LoadFeaturedProductsCompletedState(productList);
      } else {
        yield LoadFeaturedProductsFailedState();
      }
    } catch (e) {
      print(e);
      yield LoadFeaturedProductsFailedState();
    }
  }
}
