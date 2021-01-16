import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grocery_store/models/category.dart';
import 'package:grocery_store/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final UserDataRepository userDataRepository;

  CategoryBloc({this.userDataRepository}) : super(null);

  CategoryState get initialState => CategoryInitialState();

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if (event is LoadCategories) {
      yield* mapLoadCategoriesToState();
    }
  }

  Stream<CategoryState> mapLoadCategoriesToState() async* {
    yield LoadCategoriesInProgressState();
    try {
      List<Category> categories = await userDataRepository.getCategories();
      if (categories != null) {
        yield LoadCategoriesCompletedState(categories);
      } else {
        yield LoadCategoriesInFailedState();
      }
    } catch (e) {
      print(e);
      yield LoadCategoriesInFailedState();
    }
  }
}
