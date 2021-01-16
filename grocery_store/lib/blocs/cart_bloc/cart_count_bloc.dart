import 'dart:async';
import 'package:grocery_store/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_bloc.dart';

class CartCountBloc extends Bloc<CartEvent, CartState> {
  final UserDataRepository userDataRepository;
  StreamSubscription cartCountSubscription;

  CartCountBloc({this.userDataRepository}) : super(null);

  @override
  CartState get initialState => CartCountInitialState();

  @override
  Future<void> close() {
    print('CLOSING CART BLOC');
    cartCountSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is GetCartCountEvent) {
      yield* mapGetCartCountEventToState(event.uid);
    }
    if (event is CartCountUpdateEvent) {
      yield* mapCartCountUpdateEventToState(event.cartCount);
    }
  }

  Stream<CartState> mapGetCartCountEventToState(String uid) async* {
    yield GetCartCountInProgressState();
    try {
      cartCountSubscription?.cancel();
      cartCountSubscription = userDataRepository.getCartCount(uid).listen(
        (cartCount) => add(CartCountUpdateEvent(cartCount)),
        onError: (err) {
          print(err);
          return GetCartCountFailedState();
        },
      );
    } catch (e) {
      print(e);
      yield GetCartCountFailedState();
    }
  }

  Stream<CartState> mapCartCountUpdateEventToState(int cartCount) async* {
    yield CartCountUpdateState(cartCount);
  }
}
