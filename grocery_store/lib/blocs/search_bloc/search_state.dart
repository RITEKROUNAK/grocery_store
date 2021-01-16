part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitialState extends SearchState {
  @override
  String toString() => 'SearchInitialState';
}

class FirstSearchInProgressState extends SearchState {
  @override
  String toString() => 'FirstSearchInProgressState';
}

class FirstSearchFailedState extends SearchState {
  @override
  String toString() => 'FirstSearchFailedState';
}

class FirstSearchCompletedState extends SearchState {
  final List<Product> searchList;
  final List<Product> filteredList;

  FirstSearchCompletedState(this.searchList, this.filteredList);

  @override
  String toString() => 'FirstSearchCompletedState';
}

class NewSearchInProgressState extends SearchState {
  @override
  String toString() => 'NewSearchInProgressState';
}

class NewSearchFailedState extends SearchState {
  @override
  String toString() => 'NewSearchFailedState';
}

class NewSearchCompletedState extends SearchState {
  final List<Product> filteredList;
  NewSearchCompletedState(this.filteredList);

  @override
  String toString() => 'NewSearchCompletedState';
}
