part of 'category_bloc.dart';

@immutable
abstract class CategoryState {}

class CategoryInitialState extends CategoryState {
  @override
  String toString() => 'CategoryInitialState';
}

class LoadCategoriesInProgressState extends CategoryState {
  @override
  String toString() => 'LoadCategoriesInProgressState';
}

class LoadCategoriesCompletedState extends CategoryState {
  final List<Category> categories;

  LoadCategoriesCompletedState(this.categories);
  @override
  String toString() => 'LoadCategoriesInProgressState';
}

class LoadCategoriesInFailedState extends CategoryState {
  @override
  String toString() => 'LoadCategoriesInFailedState';
}
