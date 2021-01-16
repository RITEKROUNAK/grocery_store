import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final UserDataRepository userDataRepository;

  SearchBloc({this.userDataRepository}) : super(null);

  @override
  SearchState get initialState => SearchInitialState();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is FirstSearchEvent) {
      yield* mapFirstSearchEventToState(searchWord: event.searchWord);
    }
    if (event is NewSearchEvent) {
      yield* mapNewSearchEventToState(
          searchWord: event.searchWord, productsList: event.products);
    }
  }

  Stream<SearchState> mapFirstSearchEventToState({String searchWord}) async* {
    yield FirstSearchInProgressState();
    try {
      List<Product> filteredList = List();
      List<Product> products =
          await userDataRepository.getFirstSearch(searchWord);
      if (products != null) {
        for (var product in products) {
          if (product.name.toLowerCase().contains(searchWord)) {
            filteredList.add(product);
          }
        }
        yield FirstSearchCompletedState(products, filteredList);
      } else {
        yield FirstSearchFailedState();
      }
    } catch (e) {
      print(e);
      yield FirstSearchFailedState();
    }
  }

  Stream<SearchState> mapNewSearchEventToState(
      {String searchWord, List<Product> productsList}) async* {
    yield NewSearchInProgressState();
    try {
      List<Product> filteredList =
          userDataRepository.getNewSearch(searchWord, productsList);
      if (filteredList != null) {
        yield NewSearchCompletedState(filteredList);
      } else {
        yield NewSearchFailedState();
      }
    } catch (e) {
      print(e);
      yield NewSearchFailedState();
    }
  }
}
