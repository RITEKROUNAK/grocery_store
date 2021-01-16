import 'dart:async';
import 'package:grocery_store/blocs/product_bloc/product_bloc.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RateProductBloc extends Bloc<ProductEvent, ProductState> {
  final UserDataRepository userDataRepository;

  RateProductBloc({this.userDataRepository}) : super(null);

  @override
  ProductState get initialState => InitialRateProductState();

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is RateProductEvent) {
      yield* mapRateProductEventToState(
        productId: event.productId,
        uid: event.uid,
        rating: event.rating,
        review: event.review,
        result: event.result,
        product: event.product,
      );
    }
    if (event is CheckRateProductEvent) {
      yield* mapCheckRateProductEventToState(
        productId: event.productId,
        uid: event.uid,
        product: event.product,
      );
    }
  }

  Stream<ProductState> mapCheckRateProductEventToState({
    String uid,
    String productId,
    Product product,
  }) async* {
    yield CheckRateProductInProgressState();
    try {
      Map<dynamic, dynamic> res =
          await userDataRepository.checkRateProduct(uid, productId,product);

      if (res != null) {
        yield CheckRateProductCompletedState(res['review'], res['result']);
      } else {
        yield CheckRateProductFailedState();
      }
    } catch (e) {
      print(e);
      yield CheckRateProductFailedState();
    }
  }

  Stream<ProductState> mapRateProductEventToState({
    String uid,
    String productId,
    String rating,
    String review,
    String result,
    Product product,
  }) async* {
    yield RateProductInProgressState();
    try {
      bool isPosted =
          await userDataRepository.rateProduct(uid, productId, rating, review,result,product);
      if (isPosted) {
        yield RateProductCompletedState();
      } else {
        yield RateProductFailedState();
      }
    } catch (e) {
      print(e);
      yield RateProductFailedState();
    }
  }
}
