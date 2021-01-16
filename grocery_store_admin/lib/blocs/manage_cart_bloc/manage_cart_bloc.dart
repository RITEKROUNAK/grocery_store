import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/cart_info.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'manage_cart_event.dart';
part 'manage_cart_state.dart';

class ManageCartBloc extends Bloc<ManageCartEvent, ManageCartState> {
  final UserDataRepository userDataRepository;
  ManageCartBloc({this.userDataRepository}) : super(ManageCartInitial());

  @override
  Stream<ManageCartState> mapEventToState(
    ManageCartEvent event,
  ) async* {
    if (event is GetCartInfo) {
      yield* mapGetCartInfoToState();
    }
    if (event is UpdateCartInfo) {
      yield* mapUpdateCartInfoToState(event.map);
    }
  }

  Stream<ManageCartState> mapGetCartInfoToState() async* {
    yield GetCartInfoInProgressState();
    try {
      CartInfo cartInfo = await userDataRepository.getCartInfo();
      if (cartInfo != null) {
        yield GetCartInfoCompletedState(cartInfo);
      } else {
        yield GetCartInfoFailedState();
      }
    } catch (e) {
      print(e);
      yield GetCartInfoFailedState();
    }
  }

  Stream<ManageCartState> mapUpdateCartInfoToState(Map map) async* {
    yield UpdateCartInfoInProgressState();
    try {
      bool isUpdated = await userDataRepository.updateCartInfo(map);
      if (isUpdated) {
        yield UpdateCartInfoCompletedState();
      } else {
        yield UpdateCartInfoFailedState();
      }
    } catch (e) {
      print(e);
      yield UpdateCartInfoFailedState();
    }
  }
}
