import 'package:grocery_store/blocs/product_bloc/product_bloc.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistProductBloc extends Bloc<ProductEvent, ProductState> {
  final UserDataRepository userDataRepository;

  WishlistProductBloc({this.userDataRepository}) : super(null);

  @override
  ProductState get initialState => InitialWishlistProductState();

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is LoadWishlistProductEvent) {
      yield* mapLoadWishlistProductsEventToState(event.uid);
    }
    if (event is AddToWishlistEvent) {
      yield* mapAddToWishlistEventToState(event.uid, event.productId);
    }
    if (event is RemoveFromWishlistEvent) {
      yield* mapRemoveFromWishlistEventToState(event.uid, event.productId);
    }
    if (event is InitializeWishlistEvent) {
      yield InitialWishlistProductState();
    }
  }

//TODO: implement wishlist BLOC
  Stream<ProductState> mapLoadWishlistProductsEventToState(String uid) async* {
    yield LoadWishlistProductInProgressState();
    try {
      List<Product> productList =
          await userDataRepository.getWishlistProducts(uid);
      if (productList != null) {
        yield LoadWishlistProductCompletedState(productList);
      } else {
        yield LoadWishlistProductFailedState();
      }
    } catch (e) {
      print(e);
      yield LoadWishlistProductFailedState();
    }
  }

  Stream<ProductState> mapAddToWishlistEventToState(
      String uid, String productId) async* {
    yield AddToWishlistInProgressState();
    try {
      bool isAdded = await userDataRepository.addToWishlist(productId, uid);
      if (isAdded) {
        yield AddToWishlistCompletedState();
      } else {
        yield AddToWishlistFailedState();
      }
    } catch (e) {
      print(e);
      yield AddToWishlistFailedState();
    }
  }

  Stream<ProductState> mapRemoveFromWishlistEventToState(
      String uid, String productId) async* {
    yield RemoveFromWishlistInProgressState();
    try {
      bool isRemoved = await userDataRepository.removeFromCart(productId, uid);
      if (isRemoved) {
        yield RemoveFromWishlistCompletedState();
      } else {
        yield RemoveFromWishlistFailedState();
      }
    } catch (e) {
      print(e);
      yield RemoveFromWishlistFailedState();
    }
  }
}
