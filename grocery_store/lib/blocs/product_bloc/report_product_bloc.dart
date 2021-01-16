import 'dart:async';
import 'package:grocery_store/blocs/product_bloc/product_bloc.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportProductBloc extends Bloc<ProductEvent, ProductState> {
  final UserDataRepository userDataRepository;

  ReportProductBloc({this.userDataRepository}) : super(null);

  ProductState get initialState => InitialReportProductState();

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is ReportProductEvent) {
      yield* mapReportProductEventToState(
        productId: event.productId,
        uid: event.uid,
        reportDescription: event.reportDescription,
      );
    }
  }

  Stream<ProductState> mapReportProductEventToState({
    String uid,
    String productId,
    String reportDescription,
  }) async* {
    yield ReportProductInProgressState();
    try {
      bool isPosted = await userDataRepository.reportProduct(
        uid,
        productId,
        reportDescription,
      );
      if (isPosted) {
        yield ReportProductCompletedState();
      } else {
        yield ReportProductFailedState();
      }
    } catch (e) {
      print(e);
      yield ReportProductFailedState();
    }
  }
}
