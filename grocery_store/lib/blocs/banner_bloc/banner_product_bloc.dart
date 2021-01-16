import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/repositories/user_data_repository.dart';

import 'banner_bloc.dart';

class BannerProductBloc extends Bloc<BannerEvent, BannerState> {
  final UserDataRepository userDataRepository;

  BannerProductBloc({this.userDataRepository}) : super(null);

  @override
  BannerState get initialState => BannerInitialState();

  @override
  Stream<BannerState> mapEventToState(
    BannerEvent event,
  ) async* {
    if (event is LoadBannerAllProductsEvent) {
      yield* mapLoadBannerAllProductsEventToState(event.category);
    }
  }

  Stream<BannerState> mapLoadBannerAllProductsEventToState(
      String category) async* {
    yield LoadBannerAllProductsInProgressState();

    try {
      List<Product> products =
          await userDataRepository.getBannerAllProducts(category);
      if (products != null) {
        yield LoadBannerAllProductsCompletedState(products);
      } else {
        yield LoadBannerAllProductsFailedState();
      }
    } catch (e) {
      print(e);
      yield LoadBannerAllProductsFailedState();
    }
  }
}
