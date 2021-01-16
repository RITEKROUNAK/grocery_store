import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grocery_store/models/card.dart';
import 'package:grocery_store/models/cart.dart';
import 'package:grocery_store/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final UserDataRepository userDataRepository;

  CheckoutBloc({this.userDataRepository}) : super(null);

  @override
  CheckoutState get initialState => CheckoutInitial();

  @override
  Stream<CheckoutState> mapEventToState(
    CheckoutEvent event,
  ) async* {
    if (event is ProceedOrderEvent) {
      yield* mapProceedOrderToState(
          event.paymentMethod, event.uid, event.cartList);
    }
    if (event is PlaceOrderEvent) {
      yield* mapPlaceOrderEventToState(
        cartList: event.cartList,
        discountAmt: event.discountAmt,
        orderAmt: event.orderAmt,
        paymentMethod: event.paymentMethod,
        shippingAmt: event.shippingAmt,
        totalAmt: event.totalAmt,
        taxAmt: event.taxAmt,
        uid: event.uid,
        card: event.card,
        razorpayTxnId: event.razorpayTxnId,
      );
    }
  }

  Stream<CheckoutState> mapProceedOrderToState(
      int paymentMethod, String uid, List<Cart> cartList) async* {
    yield ProceedOrderInProgressState();
    try {
      if (paymentMethod == 1) {
        yield ProceedOrderCompletedState('PLACE_ORDER');
      } else {
        yield ProceedOrderCompletedState('CARD');
      }
    } catch (e) {
      print(e);
      yield ProceedOrderFailedState();
    }
  }

  Stream<CheckoutState> mapPlaceOrderEventToState({
    int paymentMethod,
    String uid,
    List<Cart> cartList,
    String orderAmt,
    String shippingAmt,
    String discountAmt,
    String totalAmt,
    String taxAmt,
    Card card,
    String razorpayTxnId,
  }) async* {
    yield PlaceOrderInProgressState();
    try {
      switch (paymentMethod) {
        case 1:
          //cod
          bool isPlaced = await userDataRepository.placeOrder(
            paymentMethod,
            uid,
            cartList,
            orderAmt,
            shippingAmt,
            discountAmt,
            totalAmt,
            taxAmt,
          );
          if (isPlaced) {
            yield PlaceOrderCompletedState();
          } else {
            yield PlaceOrderFailedState();
          }
          break;
        case 2:
          //card payment
          bool isPlaced = await userDataRepository.placeOrder(
            paymentMethod,
            uid,
            cartList,
            orderAmt,
            shippingAmt,
            discountAmt,
            totalAmt,
            taxAmt,
            card: card,
          );
          if (isPlaced) {
            yield PlaceOrderCompletedState();
          } else {
            yield PlaceOrderFailedState();
          }
          break;
        case 3:
          //razorpay
          bool isPlaced = await userDataRepository.placeOrder(
            paymentMethod,
            uid,
            cartList,
            orderAmt,
            shippingAmt,
            discountAmt,
            totalAmt,
            taxAmt,
            razorpayTxnId: razorpayTxnId,
          );
          if (isPlaced) {
            yield PlaceOrderCompletedState();
          } else {
            yield PlaceOrderFailedState();
          }
          break;
      }
    } catch (e) {
      print(e);
      yield PlaceOrderFailedState();
    }
  }
}
