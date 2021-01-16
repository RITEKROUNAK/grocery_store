import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grocery_store/models/cart.dart';
import 'package:grocery_store/models/cart_values.dart';
import 'package:grocery_store/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final UserDataRepository userDataRepository;

  CartBloc({this.userDataRepository}) : super(null);

  CartState get initialState => CartInitial();

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is AddToCartEvent) {
      yield* mapAddToCartEventToState(event.productId, event.uid);
    }
    if (event is RemoveFromCartEvent) {
      yield* mapRemoveFromCartEventToState(event.productId, event.uid);
    }
    if (event is InitializeCartEvent) {
      yield* mapInitializeCartEventToState();
    }
    if (event is GetCartProductsEvent) {
      yield* mapGetCartProductsEventToState(event.uid);
    }
    if (event is IncreaseQuantityEvent) {
      yield* mapIncreaseQuantityEventToState(
          event.quantity, event.uid, event.productId);
    }
    if (event is GetCartValuesEvent) {
      yield* mapGetCartValuesEventToState();
    }
  }

  Stream<CartState> mapAddToCartEventToState(
      String productId, String uid) async* {
    yield AddToCartInProgressState();
    try {
      //add to cart
      bool isAdded = await userDataRepository.addToCart(productId, uid);
      if (isAdded) {
        yield AddToCartCompletedState();
      } else {
        yield AddToCartFailedState();
      }
    } catch (e) {
      print('Error: $e');
      yield AddToCartFailedState();
    }
  }

  Stream<CartState> mapRemoveFromCartEventToState(
      String productId, String uid) async* {
    yield RemoveFromCartInProgressState();
    try {
      bool isRemoved = await userDataRepository.removeFromCart(productId, uid);
      if (isRemoved) {
        add(GetCartProductsEvent(uid));
        yield RemoveFromCartCompletedState();
      } else {
        yield RemoveFromCartFailedState();
      }
    } catch (e) {
      print('Error: $e');
      yield RemoveFromCartFailedState();
    }
  }

  Stream<CartState> mapInitializeCartEventToState() async* {
    yield CartInitial();
  }

  Stream<CartState> mapGetCartProductsEventToState(String uid) async* {
    yield GetCartProductsInProgressState();
    try {
      List<Cart> cartProducts = await userDataRepository.getCartProducts(uid);

      if (cartProducts != null) {
        yield GetCartProductsCompletedState(cartProducts);
      } else {
        yield GetCartProductsFailedState();
      }
    } catch (e) {
      print(e);
      yield GetCartProductsFailedState();
    }
  }

  Stream<CartState> mapIncreaseQuantityEventToState(
      String quantity, String uid, String productId) async* {
    yield IncreaseQuantityInProgressState();
    try {
      bool increased =
          await userDataRepository.increaseQuantity(quantity, uid, productId);
      if (increased) {
        // add(GetCartProductsEvent(uid));
        yield IncreaseQuantityCompletedState();
      } else {
        yield IncreaseQuantityFailedState();
      }
    } catch (e) {
      print(e);
      yield IncreaseQuantityFailedState();
    }
  }

  Stream<CartState> mapGetCartValuesEventToState() async* {
    yield GetCartValuesInProgressState();
    try {
      CartValues cartValues = await userDataRepository.getCartValues();
      if (cartValues != null) {
        yield GetCartValuesCompletedState(cartValues);
      } else {
        yield GetCartValuesFailedState();
      }
    } catch (e) {
      print(e);
      yield GetCartValuesFailedState();
    }
  }
}
