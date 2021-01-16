import 'dart:async';
import 'package:grocery_store/blocs/product_bloc/product_bloc.dart';
import 'package:grocery_store/repositories/user_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostQuestionBloc extends Bloc<ProductEvent, ProductState> {
  final UserDataRepository userDataRepository;

  PostQuestionBloc({this.userDataRepository}) : super(null);

  @override
  ProductState get initialState => InitialPostQuestionState();

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is PostQuestionEvent) {
      yield* mapPostQuestionEventToState(
        productId: event.productId,
        question: event.question,
        uid: event.uid,
      );
    }
  }

  Stream<ProductState> mapPostQuestionEventToState({
    String uid,
    String productId,
    String question,
  }) async* {
    yield PostQuestionInProgressState();
    try {
      bool isPosted =
          await userDataRepository.postQuestion(uid, productId, question);
      if (isPosted) {
        yield PostQuestionCompletedState();
      } else {
        yield PostQuestionFailedState();
      }
    } catch (e) {
      print(e);
      yield PostQuestionFailedState();
    }
  }
}
