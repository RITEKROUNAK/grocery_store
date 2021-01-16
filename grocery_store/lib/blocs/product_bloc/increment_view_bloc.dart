import 'dart:async';
import 'package:grocery_store/blocs/product_bloc/product_bloc.dart';
import 'package:grocery_store/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncrementViewBloc extends Bloc<ProductEvent, ProductState> {
  final UserDataRepository userDataRepository;

  IncrementViewBloc({this.userDataRepository}) : super(null);

  @override
  ProductState get initialState => InitialIncrementViewState();

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is IncrementViewEvent) {
      yield* mapIncrementViewEventToState(
        productId: event.productId,
      );
    }
  }

  Stream<ProductState> mapIncrementViewEventToState({
    String productId,
  }) async* {
    yield IncrementViewInProgressState();
    try {
      bool isPosted = await userDataRepository.incrementView(productId);
      if (isPosted) {
        yield IncrementViewCompletedState();
      } else {
        yield IncrementViewFailedState();
      }
    } catch (e) {
      print(e);
      yield IncrementViewFailedState();
    }
  }
}
